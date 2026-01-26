import React from 'react';

// Correspond à `chat_page_widget.dart` (liste de conversations)

export const ChatPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Messagerie</h1>
        <p>Vos conversations avec les autres utilisateurs.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des conversations (chats) à implémenter ici.</p>
        </div>
      </div>
    </div>
  );
};

