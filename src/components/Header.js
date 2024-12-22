import React from 'react';

function Header({ onStartRelayer, onResetRelayer }) {
  return (
    <header className="bg-white shadow">
      <div className="container mx-auto px-4 py-6 flex justify-between items-center">
        <h1 className="text-2xl font-bold text-gray-900">Token Transfer</h1>
        <div className="space-x-4">
          <button
            onClick={onStartRelayer}
            className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            Start Relayer
          </button>
          <button
            onClick={onResetRelayer}
            className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
          >
            Reset Relayer
          </button>
        </div>
      </div>
    </header>
  );
}

export default Header;
