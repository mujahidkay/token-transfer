import React, { useState } from 'react';

function TransferSection({ onTransfer }) {
  const [formData, setFormData] = useState({
    address: '',
    funds: '',
    fromChain: '',
    toChain: '',
    channelId: ''
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    const { fromChain, toChain, funds, address, channelId } = formData;
    onTransfer(fromChain, toChain, funds, address, channelId);
  };

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  return (
    <div className="bg-white shadow rounded-lg p-6 mt-6">
      <h2 className="text-xl font-bold mb-4">Transfer Funds</h2>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700">From Chain</label>
            <input
              type="text"
              name="fromChain"
              value={formData.fromChain}
              onChange={handleChange}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700">To Chain</label>
            <input
              type="text"
              name="toChain"
              value={formData.toChain}
              onChange={handleChange}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700">Funds</label>
            <input
              type="text"
              name="funds"
              value={formData.funds}
              onChange={handleChange}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700">Address</label>
            <input
              type="text"
              name="address"
              value={formData.address}
              onChange={handleChange}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700">Channel ID</label>
            <input
              type="text"
              name="channelId"
              value={formData.channelId}
              onChange={handleChange}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              required
            />
          </div>
        </div>
        <button
          type="submit"
          className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
        >
          Transfer
        </button>
      </form>
    </div>
  );
}

export default TransferSection;
