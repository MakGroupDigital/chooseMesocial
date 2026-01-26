
import React from 'react';
import { Wallet, TrendingUp, History, ArrowUpRight, ArrowDownLeft } from 'lucide-react';
import Button from '../../components/Button';

const WalletPage: React.FC = () => {
  return (
    <div className="p-6">
      <header className="mb-8">
        <h1 className="text-3xl font-readex font-bold text-white flex items-center gap-3">
          <Wallet className="text-[#19DB8A]" />
          Portefeuille
        </h1>
        <p className="text-white/40 mt-1">Gérez vos gains et récompenses</p>
      </header>

      {/* Balance Card */}
      <div className="bg-gradient-to-br from-[#208050] to-[#0A0A0A] rounded-[2rem] p-8 shadow-2xl relative overflow-hidden border border-white/10 mb-8">
        <div className="absolute top-0 right-0 p-8 opacity-20">
          <Wallet size={80} className="text-white" />
        </div>
        
        <p className="text-white/70 text-sm font-medium uppercase tracking-widest mb-2">Solde Actuel</p>
        <div className="flex items-baseline gap-2">
          <span className="text-5xl font-readex font-bold">14.500</span>
          <span className="text-[#19DB8A] font-bold">XOF</span>
        </div>

        <div className="grid grid-cols-2 gap-4 mt-8 pt-6 border-t border-white/10">
          <div>
            <p className="text-white/40 text-[10px] uppercase font-bold tracking-wider mb-1">Gains du mois</p>
            <p className="text-xl font-bold flex items-center gap-1">
              +4.200 <span className="text-xs font-normal opacity-40">XOF</span>
            </p>
          </div>
          <div>
            <p className="text-white/40 text-[10px] uppercase font-bold tracking-wider mb-1">Points CHOOSE</p>
            <p className="text-xl font-bold flex items-center gap-1 text-[#FF8A3C]">
              1.240 <span className="text-xs font-normal opacity-40">PTS</span>
            </p>
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="grid grid-cols-2 gap-4 mb-10">
        <Button className="py-4">
          <ArrowUpRight size={20} /> Retrait
        </Button>
        <Button variant="secondary" className="py-4">
          Dépôt
        </Button>
      </div>

      {/* History */}
      <div className="space-y-4">
        <div className="flex justify-between items-center mb-4">
          <h3 className="font-bold flex items-center gap-2">
            <History size={18} className="text-white/50" /> Historique
          </h3>
          <button className="text-[#19DB8A] text-xs font-bold uppercase">Tout voir</button>
        </div>

        {[
          { label: 'Gain Pronostic #124', date: 'Aujourd\'hui, 14:20', amount: '+1.500', type: 'gain' },
          { label: 'Retrait Orange Money', date: 'Hier, 18:05', amount: '-5.000', type: 'withdrawal' },
          { label: 'Bonus Inscription', date: '20 Mai, 10:00', amount: '+500', type: 'gain' },
        ].map((tx, idx) => (
          <div key={idx} className="bg-[#0A0A0A] border border-white/5 rounded-2xl p-4 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className={`p-3 rounded-xl ${tx.type === 'gain' ? 'bg-green-500/10 text-green-500' : 'bg-red-500/10 text-red-500'}`}>
                {tx.type === 'gain' ? <ArrowDownLeft size={20} /> : <ArrowUpRight size={20} />}
              </div>
              <div>
                <p className="font-bold text-sm text-white">{tx.label}</p>
                <p className="text-white/30 text-[10px]">{tx.date}</p>
              </div>
            </div>
            <p className={`font-readex font-bold ${tx.type === 'gain' ? 'text-green-500' : 'text-white'}`}>
              {tx.amount} <span className="text-[10px] opacity-40">XOF</span>
            </p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default WalletPage;
