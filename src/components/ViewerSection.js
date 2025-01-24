import React from 'react';

function ViewerSection({ output, onShowAddresses, onShowChannels }) {
  return (
    <div className="bg-white shadow rounded-lg p-6">
      <div className="mb-4 flex space-x-4">
        <button
          onClick={onShowAddresses}
          className="bg-gray-600 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded"
        >
          Show Addresses
        </button>
        <button
          onClick={onShowChannels}
          className="bg-gray-600 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded"
        >
          Show Channels
        </button>
      </div>
      <div className="bg-black text-white p-4 rounded font-mono whitespace-pre overflow-x-auto">
        {output || 'No output to display. Click one of the buttons above to fetch data.'}
      </div>
    </div>
  );
}

export default ViewerSection;
