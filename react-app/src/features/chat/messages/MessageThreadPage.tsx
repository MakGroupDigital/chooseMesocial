import React from 'react';
import { useParams } from 'react-router-dom';

// Correspond à `message_widget.dart` (conversation détaillée / thread de messages)

export const MessageThreadPage: React.FC = () => {
  const { chatId } = useParams();

  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Conversation</h1>
        <p>Chat ID: {chatId}</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des messages + zone de saisie pour envoyer des messages à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

