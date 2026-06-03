'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { api } from '@/lib/api';
import { useAuth } from '@/lib/auth';

export default function ProfileEditPage() {
  const { user, loading } = useAuth();
  const router = useRouter();
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  if (loading) return <p>Загрузка...</p>;
  if (!user) return <p>Войдите в систему</p>;

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSuccess('');
    try {
      await api.patch('/profile', { user: { first_name: firstName, last_name: lastName, phone, email } });
      setSuccess('Профиль обновлён');
      setTimeout(() => router.push('/profile'), 1000);
    } catch (err: any) {
      setError(err.message || 'Ошибка при обновлении профиля');
    }
  };

  return (
    <div className="max-w-[480px] mx-auto">
      <h1 className="text-2xl font-bold mb-6">Редактирование профиля</h1>
      {error && <div className="bg-red-100 text-red-700 px-4 py-3 rounded mb-4">{error}</div>}
      {success && <div className="bg-green-100 text-green-700 px-4 py-3 rounded mb-4">{success}</div>}
      <form onSubmit={submit} className="bg-white rounded-lg p-5 shadow space-y-4">
        <div>
          <label className="block text-sm font-medium mb-1">Имя</label>
          <input value={firstName} onChange={(e) => setFirstName(e.target.value)} className="w-full px-3 py-2 border rounded" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">Фамилия</label>
          <input value={lastName} onChange={(e) => setLastName(e.target.value)} className="w-full px-3 py-2 border rounded" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">Телефон</label>
          <input value={phone} onChange={(e) => setPhone(e.target.value)} className="w-full px-3 py-2 border rounded" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">Email</label>
          <input value={email} onChange={(e) => setEmail(e.target.value)} className="w-full px-3 py-2 border rounded" />
        </div>
        <button type="submit" className="bg-accent text-white px-5 py-2 rounded-md font-semibold">Сохранить</button>
      </form>
    </div>
  );
}