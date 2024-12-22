import React, { useState } from 'react';
import Header from './components/Header';
import ViewerSection from './components/ViewerSection';
import TransferSection from './components/TransferSection';

function App() {
  const [output, setOutput] = useState('');

  const executeCommand = async (command) => {
    try {
      const response = await fetch(`/api/${command}`);
      const data = await response.text();
      setOutput(data);
    } catch (error) {
      setOutput(`Error executing command: ${error.message}`);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <Header 
        onStartRelayer={() => executeCommand('start-relayer')}
        onResetRelayer={() => executeCommand('reset-relayer')}
      />
      <main className="container mx-auto px-4 py-8">
        <ViewerSection 
          output={output}
          onShowAddresses={() => executeCommand('show-addresses')}
          onShowChannels={() => executeCommand('show-channels')}
        />
        <TransferSection 
          onTransfer={(from, to, funds, addr, channel) => {
            executeCommand(`transfer/${from}/${to}/${funds}/${addr}/${channel}`);
          }}
        />
      </main>
    </div>
  );
}

export default App;
