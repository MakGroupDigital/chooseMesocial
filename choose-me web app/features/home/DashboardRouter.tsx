import React from 'react';
import HomeChoosePage from './HomeChoosePage';
import { UserType } from '../../types';

interface Props {
  userType: UserType;
}

const DashboardRouter: React.FC<Props> = ({ userType }) => {
  // Le feed vidéo reste la page d'accueil pour tous les types de compte.
  return <HomeChoosePage userType={userType} />;
};

export default DashboardRouter;
