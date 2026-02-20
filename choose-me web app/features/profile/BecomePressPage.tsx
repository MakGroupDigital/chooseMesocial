import React, { useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ChevronLeft, Newspaper, Upload, CheckCircle2 } from 'lucide-react';
import { doc, getDoc, serverTimestamp, setDoc } from 'firebase/firestore';
import { getDownloadURL, getStorage, ref, uploadBytes } from 'firebase/storage';
import { getFirebaseApp, getFirestoreDb, useAuth } from '../../services/firebase';
import { UserType } from '../../types';
import { getPhoneCountries } from '../../utils/phoneCountries';
import { getCitiesByCountry } from '../../services/cityService';
import { MAJOR_CITIES } from '../../utils/sportsData';

type PressCategory =
  | 'independent_journalist'
  | 'newspaper_magazine'
  | 'tv_radio'
  | 'digital_media'
  | 'press_agency';

type PressField = {
  key: string;
  label: string;
  required?: boolean;
  placeholder?: string;
};

type PressDoc = {
  key: string;
  label: string;
  required?: boolean;
  accept?: string;
};

const CATEGORY_META: Record<
  PressCategory,
  {
    label: string;
    description: string;
    fields: PressField[];
    docs: PressDoc[];
  }
> = {
  independent_journalist: {
    label: 'Journaliste indépendant',
    description: 'Pour les reporters freelances et correspondants.',
    fields: [
      { key: 'fullName', label: 'Nom complet', required: true, placeholder: 'Ex: Sarah N. Mbayo' },
      { key: 'journalistCardNumber', label: 'Numéro de carte de presse', required: true, placeholder: 'Ex: JP-2026-0012' },
      { key: 'speciality', label: 'Spécialité (sport couvert)', required: true, placeholder: 'Ex: Football, Basketball' }
    ],
    docs: [
      { key: 'journalistCardFile', label: 'Carte de presse (scan/photo)', required: true, accept: '.pdf,image/*' },
      { key: 'identityFile', label: 'Pièce d’identité', required: true, accept: '.pdf,image/*' },
      { key: 'assignmentLetterFile', label: 'Lettre d’affectation / mission', accept: '.pdf,image/*' }
    ]
  },
  newspaper_magazine: {
    label: 'Magazine / Journal',
    description: 'Pour les médias imprimés ou en ligne structurés en rédaction.',
    fields: [
      { key: 'mediaName', label: 'Nom du média', required: true, placeholder: 'Ex: Sport Afrique Hebdo' },
      { key: 'registrationNumber', label: 'Numéro d’enregistrement', required: true, placeholder: 'Ex: RCCM/REG/0099' },
      { key: 'editorInChief', label: 'Nom du rédacteur en chef', required: true, placeholder: 'Ex: M. Jean Doe' }
    ],
    docs: [
      { key: 'businessLicenseFile', label: 'Registre de commerce / immatriculation', required: true, accept: '.pdf,image/*' },
      { key: 'publicationLicenseFile', label: 'Licence / autorisation de publication', required: true, accept: '.pdf,image/*' }
    ]
  },
  tv_radio: {
    label: 'Chaîne TV / Radio',
    description: 'Pour les diffuseurs audiovisuels nationaux, régionaux ou web radio.',
    fields: [
      { key: 'channelName', label: 'Nom de la chaîne / station', required: true, placeholder: 'Ex: Sport FM / Canal Sport' },
      { key: 'broadcastLicenseNumber', label: 'Numéro de licence de diffusion', required: true, placeholder: 'Ex: CSA-2026-889' },
      { key: 'frequency', label: 'Fréquence / Canal', placeholder: 'Ex: 98.5 FM / Canal 17' }
    ],
    docs: [
      { key: 'broadcastLicenseFile', label: 'Licence de diffusion', required: true, accept: '.pdf,image/*' },
      { key: 'regulatorApprovalFile', label: 'Approbation du régulateur', required: true, accept: '.pdf,image/*' }
    ]
  },
  digital_media: {
    label: 'Média digital',
    description: 'Pour plateformes médias web, pure players et webzines.',
    fields: [
      { key: 'mediaName', label: 'Nom du média digital', required: true, placeholder: 'Ex: FootData Afrique' },
      { key: 'domainName', label: 'Nom de domaine / URL', required: true, placeholder: 'Ex: https://footdata.africa' },
      { key: 'editorInChief', label: 'Responsable éditorial', required: true, placeholder: 'Ex: Fatou K.' }
    ],
    docs: [
      { key: 'domainProofFile', label: 'Preuve de propriété domaine', required: true, accept: '.pdf,image/*' },
      { key: 'publicationLicenseFile', label: 'Autorisation de publication (si applicable)', accept: '.pdf,image/*' }
    ]
  },
  press_agency: {
    label: 'Agence de presse',
    description: 'Pour agences de presse locales/internationales.',
    fields: [
      { key: 'agencyName', label: 'Nom de l’agence', required: true, placeholder: 'Ex: Agence Sport News' },
      { key: 'agencyLicenseNumber', label: 'Numéro de licence', required: true, placeholder: 'Ex: AP-00445' },
      { key: 'representativeName', label: 'Nom du représentant légal', required: true, placeholder: 'Ex: K. Mbuyi' }
    ],
    docs: [
      { key: 'agencyLicenseFile', label: 'Licence de l’agence', required: true, accept: '.pdf,image/*' },
      { key: 'representativeIdFile', label: 'Pièce d’identité du représentant', required: true, accept: '.pdf,image/*' }
    ]
  }
};

const PRESS_FEATURES = [
  'Publier des contenus presse dans la section Articles',
  'Accès aux outils de couverture et narration média',
  'Visibilité “Presse / Média” vérifiée sur le profil',
  'Collaboration directe avec talents, clubs et recruteurs'
];

const BecomePressPage: React.FC = () => {
  const navigate = useNavigate();
  const { currentUser } = useAuth();
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [loadingCities, setLoadingCities] = useState(false);
  const [cityOptions, setCityOptions] = useState<string[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const [category, setCategory] = useState<PressCategory>('independent_journalist');
  const [currentType, setCurrentType] = useState<string>('');
  const [form, setForm] = useState<Record<string, string>>({
    country: '',
    city: '',
    phone: '',
    emailPro: '',
    website: '',
    description: ''
  });
  const [docs, setDocs] = useState<Record<string, File | null>>({});

  const phoneCountries = getPhoneCountries();
  const categoryMeta = CATEGORY_META[category];

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
          setCurrentType(data.type || '');
          setForm((prev) => ({
            ...prev,
            country: data.country || data.pays || '',
            city: data.city || data.ville || '',
            phone: data.phone || data.phoneNumber || '',
            website: data.website || '',
            emailPro: data.email || '',
            description: data.pressProfile?.description || ''
          }));
        }
      } catch (e) {
        console.error('Erreur chargement profil presse:', e);
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
    () =>
      [
        { key: 'country', label: 'Pays' },
        { key: 'city', label: 'Ville' },
        { key: 'phone', label: 'Téléphone pro' },
        { key: 'emailPro', label: 'Email pro' },
        ...categoryMeta.fields.filter((f) => f.required).map((f) => ({ key: f.key, label: f.label }))
      ],
    [categoryMeta.fields]
  );

  const requiredDocs = useMemo(() => categoryMeta.docs.filter((d) => d.required), [categoryMeta.docs]);

  const onDocChange = (docKey: string, file: File | null) => {
    setDocs((prev) => ({ ...prev, [docKey]: file }));
  };

  const uploadPressDoc = async (docKey: string, file: File): Promise<{ url: string; path: string; name: string }> => {
    if (!currentUser?.uid) throw new Error('Utilisateur non connecté');
    const storage = getStorage(getFirebaseApp());
    const safeName = file.name.replace(/\s+/g, '_');
    const path = `press_verification/${currentUser.uid}/${category}/${docKey}_${Date.now()}_${safeName}`;
    const storageRef = ref(storage, path);
    await uploadBytes(storageRef, file, { contentType: file.type || 'application/octet-stream' });
    const url = await getDownloadURL(storageRef);
    return { url, path, name: file.name };
  };

  const handleSubmit = async () => {
    if (!currentUser?.uid) return;
    setError(null);
    setSuccess(null);

    for (const field of requiredFields) {
      if (!String(form[field.key] || '').trim()) {
        setError(`Champ requis: ${field.label}`);
        return;
      }
    }

    for (const reqDoc of requiredDocs) {
      if (!docs[reqDoc.key]) {
        setError(`Document requis: ${reqDoc.label}`);
        return;
      }
    }

    setSubmitting(true);
    try {
      const uploadedDocs: Record<string, { url: string; path: string; name: string }> = {};
      for (const docDef of categoryMeta.docs) {
        const file = docs[docDef.key];
        if (!file) continue;
        uploadedDocs[docDef.key] = await uploadPressDoc(docDef.key, file);
      }

      const db = getFirestoreDb();
      const dynamicFields = categoryMeta.fields.reduce<Record<string, string>>((acc, f) => {
        acc[f.key] = form[f.key] || '';
        return acc;
      }, {});

      await setDoc(
        doc(db, 'users', currentUser.uid),
        {
          type: UserType.PRESS,
          statut: 'pending_press_verification',
          etat: 'review',
          country: form.country,
          city: form.city,
          website: form.website || null,
          phoneNumber: form.phone,
          pressProfile: {
            category,
            categoryLabel: categoryMeta.label,
            emailPro: form.emailPro,
            description: form.description || '',
            ...dynamicFields
          },
          pressVerificationRequest: {
            status: 'pending',
            category,
            submittedAt: serverTimestamp(),
            documents: uploadedDocs
          },
          updatedAt: serverTimestamp()
        },
        { merge: true }
      );

      setSuccess('Demande presse envoyée. Votre compte est désormais en mode presse (vérification en cours).');
      setCurrentType(UserType.PRESS);
      setTimeout(() => navigate('/profile'), 900);
    } catch (e) {
      console.error('Erreur soumission compte presse:', e);
      setError('Impossible de soumettre la demande pour le moment.');
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
          <button onClick={() => navigate('/settings')} className="p-2 rounded-full bg-white/10 text-white">
            <ChevronLeft size={20} />
          </button>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <Newspaper size={22} className="text-[#19DB8A]" />
            Obtenir un compte presse
          </h1>
        </div>
      </header>

      <div className="px-6 space-y-4">
        <section className="bg-[#0A0A0A] border border-white/5 rounded-3xl p-4">
          <h2 className="text-white font-semibold mb-2">À quoi sert le compte presse ?</h2>
          <div className="space-y-1">
            {PRESS_FEATURES.map((feature) => (
              <p key={feature} className="text-white/70 text-sm">
                • {feature}
              </p>
            ))}
          </div>
          {currentType === UserType.PRESS && (
            <div className="mt-3 py-2 px-3 bg-[#111111] border border-[#19DB8A]/40 rounded-xl text-[#19DB8A] text-sm">
              Ton compte est déjà en mode presse.
            </div>
          )}
        </section>

        <section className="bg-[#0A0A0A] border border-white/5 rounded-3xl p-4 space-y-3">
          <SimpleSelect
            label="Catégorie de presse"
            value={category}
            onChange={(value) => {
              setCategory(value as PressCategory);
              setDocs({});
            }}
            options={(Object.keys(CATEGORY_META) as PressCategory[]).map((key) => ({
              label: CATEGORY_META[key].label,
              value: key
            }))}
          />
          <p className="text-white/50 text-xs -mt-1">{categoryMeta.description}</p>

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
            placeholder="Ex: redaction@media.com"
          />
          <SimpleInput
            label="Site web (optionnel)"
            value={form.website}
            onChange={(value) => setForm((prev) => ({ ...prev, website: value }))}
            placeholder="https://..."
          />

          {categoryMeta.fields.map((field) => (
            <SimpleInput
              key={field.key}
              label={field.label}
              value={form[field.key] || ''}
              onChange={(value) => setForm((prev) => ({ ...prev, [field.key]: value }))}
              placeholder={field.placeholder || ''}
            />
          ))}

          <SimpleTextarea
            label="Description rédaction / ligne éditoriale"
            value={form.description}
            onChange={(value) => setForm((prev) => ({ ...prev, description: value }))}
            placeholder="Décrivez brièvement votre activité média."
          />
        </section>

        <section className="bg-[#0A0A0A] border border-white/5 rounded-3xl p-4 space-y-3">
          <h3 className="text-white font-semibold">Documents justificatifs</h3>
          {categoryMeta.docs.map((docDef) => (
            <DocInput
              key={docDef.key}
              label={docDef.label}
              required={Boolean(docDef.required)}
              file={docs[docDef.key] || null}
              accept={docDef.accept}
              onChange={(file) => onDocChange(docDef.key, file)}
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
          disabled={submitting}
          className="w-full py-3 bg-[#19DB8A] text-black font-semibold rounded-2xl disabled:opacity-60"
        >
          {submitting ? 'Soumission en cours...' : 'Soumettre ma demande presse'}
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

export default BecomePressPage;
