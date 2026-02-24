import React, { useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ChevronLeft, Upload, CheckCircle2, ShieldCheck } from 'lucide-react';
import { doc, getDoc, serverTimestamp, setDoc } from 'firebase/firestore';
import { getDownloadURL, getStorage, ref, uploadBytes } from 'firebase/storage';
import { getFirebaseApp, getFirestoreDb, useAuth } from '../../services/firebase';
import { getPhoneCountries } from '../../utils/phoneCountries';
import { getCitiesByCountry } from '../../services/cityService';
import { MAJOR_CITIES } from '../../utils/sportsData';

type RecruiterDoc = {
  key: string;
  label: string;
  required?: boolean;
  accept?: string;
};

const RECRUITER_SUBCATEGORY_LABELS: Record<string, string> = {
  club: 'Club',
  manager: 'Manager',
  agent: 'Agent',
  academie: 'Académie',
  scout: 'Scout indépendant'
};

const RECRUITER_FIELDS: Record<string, Array<{ key: string; label: string; required?: boolean; placeholder?: string }>> = {
  club: [
    { key: 'organizationName', label: 'Nom du club', required: true, placeholder: 'Ex: AS Dakar FC' },
    { key: 'roleTitle', label: 'Fonction', required: true, placeholder: 'Ex: Directeur sportif' },
    { key: 'focusSport', label: 'Sport ciblé', required: true, placeholder: 'Ex: Football' }
  ],
  manager: [
    { key: 'organizationName', label: 'Nom de la structure', required: true, placeholder: 'Ex: Talent Management Group' },
    { key: 'roleTitle', label: 'Fonction', required: true, placeholder: 'Ex: Manager sportif' },
    { key: 'focusSport', label: 'Sport ciblé', required: true, placeholder: 'Ex: Basketball' }
  ],
  agent: [
    { key: 'organizationName', label: 'Nom de l’agence', required: true, placeholder: 'Ex: Elite Agency' },
    { key: 'licenseNumber', label: 'Numéro de licence agent', required: true, placeholder: 'Ex: LIC-2026-0044' },
    { key: 'focusSport', label: 'Sport ciblé', required: true, placeholder: 'Ex: Football' }
  ],
  academie: [
    { key: 'organizationName', label: 'Nom de l’académie', required: true, placeholder: 'Ex: Académie des Talents' },
    { key: 'roleTitle', label: 'Fonction', required: true, placeholder: 'Ex: Responsable détection' },
    { key: 'focusSport', label: 'Sport ciblé', required: true, placeholder: 'Ex: Athlétisme' }
  ],
  scout: [
    { key: 'organizationName', label: 'Organisation / Réseau', required: true, placeholder: 'Ex: Scout Pro Network' },
    { key: 'focusSport', label: 'Sport ciblé', required: true, placeholder: 'Ex: Football' },
    { key: 'yearsExperience', label: 'Années d’expérience', required: true, placeholder: 'Ex: 6' }
  ]
};

const RECRUITER_DOCS: Record<string, RecruiterDoc[]> = {
  club: [
    { key: 'registrationFile', label: 'Registre / existence légale du club', required: true, accept: '.pdf,image/*' },
    { key: 'authorizationFile', label: 'Justificatif de fonction au club', required: true, accept: '.pdf,image/*' }
  ],
  manager: [
    { key: 'registrationFile', label: 'Immatriculation de la structure', required: true, accept: '.pdf,image/*' },
    { key: 'idFile', label: 'Pièce d’identité du responsable', required: true, accept: '.pdf,image/*' }
  ],
  agent: [
    { key: 'licenseFile', label: 'Licence agent / intermédiaire', required: true, accept: '.pdf,image/*' },
    { key: 'idFile', label: 'Pièce d’identité', required: true, accept: '.pdf,image/*' }
  ],
  academie: [
    { key: 'accreditationFile', label: 'Accréditation / autorisation académie', required: true, accept: '.pdf,image/*' },
    { key: 'idFile', label: 'Pièce d’identité du responsable', required: true, accept: '.pdf,image/*' }
  ],
  scout: [
    { key: 'recommendationFile', label: 'Lettre de recommandation / mandat', required: true, accept: '.pdf,image/*' },
    { key: 'idFile', label: 'Pièce d’identité', required: true, accept: '.pdf,image/*' }
  ]
};

const RecruiterVerificationPage: React.FC = () => {
  const navigate = useNavigate();
  const { currentUser } = useAuth();
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [loadingCities, setLoadingCities] = useState(false);
  const [cityOptions, setCityOptions] = useState<string[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [subcategory, setSubcategory] = useState('');
  const [form, setForm] = useState<Record<string, string>>({
    country: '',
    city: '',
    phone: '',
    emailPro: '',
    notes: ''
  });
  const [docs, setDocs] = useState<Record<string, File | null>>({});

  const phoneCountries = getPhoneCountries();
  const categoryFields = RECRUITER_FIELDS[subcategory] || [];
  const categoryDocs = RECRUITER_DOCS[subcategory] || [];

  useEffect(() => {
    const loadProfile = async () => {
      if (!currentUser?.uid) {
        setLoading(false);
        return;
      }
      try {
        const db = getFirestoreDb();
        const snap = await getDoc(doc(db, 'users', currentUser.uid));
        const data = snap.data() as any;
        if (data) {
          setSubcategory(String(data.recruiterSubcategory || ''));
          const recruiterProfile = (data.recruiterProfile || {}) as Record<string, any>;
          setForm((prev) => ({
            ...prev,
            country: data.country || data.pays || '',
            city: data.city || data.ville || '',
            phone: data.phone || data.phoneNumber || '',
            emailPro: data.email || '',
            notes: String(data.recruiterVerificationRequest?.notes || ''),
            ...Object.fromEntries(Object.keys(recruiterProfile).map((key) => [key, String(recruiterProfile[key] || '')]))
          }));
        }
      } catch (e) {
        console.error('Erreur chargement vérification recruteur:', e);
      } finally {
        setLoading(false);
      }
    };
    void loadProfile();
  }, [currentUser?.uid]);

  useEffect(() => {
    let active = true;
    const loadCities = async () => {
      if (!form.country) {
        setCityOptions([]);
        return;
      }
      setLoadingCities(true);
      const cities = await getCitiesByCountry(form.country, MAJOR_CITIES[form.country] || []);
      if (active) {
        setCityOptions(cities);
      }
      setLoadingCities(false);
    };
    void loadCities();
    return () => {
      active = false;
    };
  }, [form.country]);

  const requiredFields = useMemo(
    () => [
      { key: 'country', label: 'Pays' },
      { key: 'city', label: 'Ville' },
      { key: 'phone', label: 'Téléphone pro' },
      { key: 'emailPro', label: 'Email pro' },
      ...categoryFields.filter((f) => f.required).map((f) => ({ key: f.key, label: f.label }))
    ],
    [categoryFields]
  );

  const requiredDocs = useMemo(() => categoryDocs.filter((docDef) => docDef.required), [categoryDocs]);

  const uploadRecruiterDoc = async (docKey: string, file: File): Promise<{ url: string; path: string; name: string }> => {
    if (!currentUser?.uid) throw new Error('Utilisateur non connecté');
    const storage = getStorage(getFirebaseApp());
    const safeName = file.name.replace(/\s+/g, '_');
    const path = `recruiter_verification/${currentUser.uid}/${subcategory}/${docKey}_${Date.now()}_${safeName}`;
    const storageRef = ref(storage, path);
    await uploadBytes(storageRef, file, { contentType: file.type || 'application/octet-stream' });
    const url = await getDownloadURL(storageRef);
    return { url, path, name: file.name };
  };

  const handleSubmit = async () => {
    if (!currentUser?.uid) return;
    setError(null);
    setSuccess(null);

    if (!subcategory) {
      setError('Sous-catégorie recruteur manquante. Reprenez le choix de type.');
      return;
    }

    for (const field of requiredFields) {
      if (!String(form[field.key] || '').trim()) {
        setError(`Champ requis: ${field.label}`);
        return;
      }
    }

    for (const docDef of requiredDocs) {
      if (!docs[docDef.key]) {
        setError(`Document requis: ${docDef.label}`);
        return;
      }
    }

    setSubmitting(true);
    try {
      const uploadedDocs: Record<string, { url: string; path: string; name: string }> = {};
      for (const docDef of categoryDocs) {
        const file = docs[docDef.key];
        if (!file) continue;
        uploadedDocs[docDef.key] = await uploadRecruiterDoc(docDef.key, file);
      }

      const db = getFirestoreDb();
      const dynamicFields = categoryFields.reduce<Record<string, string>>((acc, field) => {
        acc[field.key] = form[field.key] || '';
        return acc;
      }, {});

      await setDoc(
        doc(db, 'users', currentUser.uid),
        {
          country: form.country,
          city: form.city,
          phoneNumber: form.phone,
          recruiterSubcategory: subcategory,
          recruiterProfile: {
            ...dynamicFields,
            verificationEmail: form.emailPro
          },
          recruiterVerificationRequest: {
            status: 'pending',
            subcategory,
            submittedAt: serverTimestamp(),
            notes: form.notes || '',
            documents: uploadedDocs
          },
          statut: 'pending_recruiter_verification',
          etat: 'review',
          updatedAt: serverTimestamp()
        },
        { merge: true }
      );

      setSuccess('Dossier envoyé. Vous recevrez la réponse de vérification sur votre profil.');
      setTimeout(() => navigate('/profile'), 900);
    } catch (e) {
      console.error('Erreur soumission vérification recruteur:', e);
      setError('Impossible de soumettre le dossier pour le moment.');
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#050505] flex items-center justify-center">
        <div className="animate-spin rounded-full h-10 w-10 border-4 border-[#208050] border-t-transparent" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#050505] pb-24">
      <header className="p-6 pt-10 bg-gradient-to-b from-[#208050]/20 to-transparent">
        <div className="flex items-center gap-3">
          <button onClick={() => navigate('/profile')} className="p-2 rounded-full bg-white/10 text-white">
            <ChevronLeft size={20} />
          </button>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <ShieldCheck size={22} className="text-[#19DB8A]" />
            Vérification recruteur
          </h1>
        </div>
      </header>

      <div className="px-6 space-y-4">
        <section className="bg-[#0A0A0A] border border-[#19DB8A]/25 rounded-3xl p-4">
          <p className="text-white/80 text-sm">
            Cette vérification est obligatoire pour sécuriser la plateforme et continuer à utiliser les fonctionnalités recruteur.
          </p>
          <p className="text-[#19DB8A] text-sm font-semibold mt-2">
            Sous-catégorie: {RECRUITER_SUBCATEGORY_LABELS[subcategory] || 'Non définie'}
          </p>
          {!subcategory && (
            <button
              type="button"
              onClick={() => navigate('/onboarding/type')}
              className="mt-2 text-[#FF8A3C] text-sm font-bold hover:underline"
            >
              Définir ma sous-catégorie maintenant
            </button>
          )}
        </section>

        <section className="bg-[#0A0A0A] border border-white/5 rounded-3xl p-4 space-y-3">
          <SimpleSelect
            label="Pays"
            value={form.country}
            onChange={(value) => setForm((prev) => ({ ...prev, country: value, city: '' }))}
            options={phoneCountries.map((country) => ({ label: `${country.flag} ${country.name}`, value: country.name }))}
          />
          <SimpleSelect
            label="Ville"
            value={form.city}
            onChange={(value) => setForm((prev) => ({ ...prev, city: value }))}
            options={cityOptions.map((city) => ({ label: city, value: city }))}
            allowFreeInput
            placeholder={loadingCities ? 'Chargement des villes...' : 'Sélectionner ou saisir'}
          />
          <SimpleInput
            label="Téléphone pro"
            value={form.phone}
            onChange={(value) => setForm((prev) => ({ ...prev, phone: value }))}
            placeholder="Ex: +243 9xx xxx xxx"
          />
          <SimpleInput
            label="Email pro"
            value={form.emailPro}
            onChange={(value) => setForm((prev) => ({ ...prev, emailPro: value }))}
            placeholder="Ex: recrutement@club.com"
          />

          {categoryFields.map((field) => (
            <SimpleInput
              key={field.key}
              label={`${field.label}${field.required ? ' *' : ''}`}
              value={form[field.key] || ''}
              onChange={(value) => setForm((prev) => ({ ...prev, [field.key]: value }))}
              placeholder={field.placeholder || ''}
            />
          ))}

          <SimpleTextarea
            label="Notes complémentaires (optionnel)"
            value={form.notes || ''}
            onChange={(value) => setForm((prev) => ({ ...prev, notes: value }))}
            placeholder="Ajoutez des informations utiles au traitement du dossier."
          />
        </section>

        <section className="bg-[#0A0A0A] border border-white/5 rounded-3xl p-4 space-y-3">
          <h3 className="text-white font-semibold">Documents justificatifs</h3>
          {categoryDocs.map((docDef) => (
            <DocInput
              key={docDef.key}
              label={docDef.label}
              required={Boolean(docDef.required)}
              file={docs[docDef.key] || null}
              accept={docDef.accept}
              onChange={(file) => setDocs((prev) => ({ ...prev, [docDef.key]: file }))}
            />
          ))}
        </section>

        {error && (
          <div className="py-3 px-3 bg-red-500/10 border border-red-500/40 rounded-xl text-red-400 text-sm">
            {error}
          </div>
        )}
        {success && (
          <div className="py-3 px-3 bg-[#19DB8A]/10 border border-[#19DB8A]/40 rounded-xl text-[#19DB8A] text-sm flex items-center gap-2">
            <CheckCircle2 size={16} />
            {success}
          </div>
        )}

        <button
          onClick={handleSubmit}
          disabled={submitting || !subcategory}
          className="w-full py-3 bg-[#19DB8A] text-black font-semibold rounded-2xl disabled:opacity-60"
        >
          {submitting ? 'Soumission en cours...' : 'Soumettre mon dossier recruteur'}
        </button>
      </div>
    </div>
  );
};

const SimpleInput: React.FC<{
  label: string;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}> = ({ label, value, onChange, placeholder }) => (
  <div className="py-3 px-3 bg-[#111111] rounded-2xl border border-white/5">
    <label className="text-xs text-white/50 mb-1 block">{label}</label>
    <input
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      className="w-full bg-transparent text-white text-sm outline-none"
    />
  </div>
);

const SimpleTextarea: React.FC<{
  label: string;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}> = ({ label, value, onChange, placeholder }) => (
  <div className="py-3 px-3 bg-[#111111] rounded-2xl border border-white/5">
    <label className="text-xs text-white/50 mb-1 block">{label}</label>
    <textarea
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      rows={4}
      className="w-full bg-transparent text-white text-sm outline-none resize-none"
    />
  </div>
);

const SimpleSelect: React.FC<{
  label: string;
  value: string;
  onChange: (value: string) => void;
  options: Array<{ label: string; value: string }>;
  allowFreeInput?: boolean;
  placeholder?: string;
}> = ({ label, value, onChange, options, allowFreeInput = false, placeholder = 'Sélectionner' }) => (
  <div className="py-3 px-3 bg-[#111111] rounded-2xl border border-white/5">
    <label className="text-xs text-white/50 mb-1 block">{label}</label>
    {allowFreeInput ? (
      <>
        <input
          type="text"
          list={`datalist-${label}`}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          className="w-full bg-transparent text-white text-sm outline-none"
        />
        <datalist id={`datalist-${label}`}>
          {options.map((option) => (
            <option key={option.value} value={option.value} />
          ))}
        </datalist>
      </>
    ) : (
      <select
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full bg-transparent text-white text-sm outline-none"
      >
        <option value="" className="bg-[#111111]">{placeholder}</option>
        {options.map((option) => (
          <option key={option.value} value={option.value} className="bg-[#111111]">
            {option.label}
          </option>
        ))}
      </select>
    )}
  </div>
);

const DocInput: React.FC<{
  label: string;
  required: boolean;
  file: File | null;
  accept?: string;
  onChange: (file: File | null) => void;
}> = ({ label, required, file, accept, onChange }) => (
  <div className="py-3 px-3 bg-[#111111] rounded-2xl border border-white/5">
    <label className="text-xs text-white/50 mb-2 flex items-center justify-between">
      <span>
        {label} {required ? <span className="text-[#FF8A3C]">*</span> : null}
      </span>
      {file && <span className="text-[#19DB8A] text-[11px]">Prêt</span>}
    </label>
    <label className="w-full py-2 px-3 rounded-xl border border-dashed border-white/20 text-white/70 text-sm flex items-center gap-2 cursor-pointer">
      <Upload size={15} className="text-[#19DB8A]" />
      <span className="truncate">{file ? file.name : 'Choisir un document'}</span>
      <input
        type="file"
        accept={accept}
        className="hidden"
        onChange={(e) => onChange(e.target.files?.[0] || null)}
      />
    </label>
  </div>
);

export default RecruiterVerificationPage;
