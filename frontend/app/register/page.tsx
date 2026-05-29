'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';

export default function RegisterPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirmation, setPasswordConfirmation] = useState('');
  const [error, setError] = useState('');
  const { register } = useAuth();
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (password !== passwordConfirmation) {
      setError('Пароли не совпадают');
      return;
    }
    try {
      await register(email, password, passwordConfirmation);
      router.push('/');
    } catch (err: any) {
      setError(err.message || 'Ошибка регистрации');
    }
  };

  return (
    <div className="max-w-md mx-auto my-8 p-8 bg-white rounded-lg shadow">
      <h1 className="text-xl font-bold mb-4">Регистрация</h1>
      {error && <div className="bg-red-100 text-red-700 px-4 py-2 rounded mb-4 text-sm">{error}</div>}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-1">Email</label>
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required className="w-full px-3 py-2 border rounded" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">Пароль</label>
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} required className="w-full px-3 py-2 border rounded" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">Подтверждение пароля</label>
          <input type="password" value={passwordConfirmation} onChange={(e) => setPasswordConfirmation(e.target.value)} required className="w-full px-3 py-2 border rounded" />
        </div>
        <button type="submit" className="w-full bg-accent text-white py-2 rounded-md font-semibold">Зарегистрироваться</button>
      </form>
      <p className="mt-4 text-sm text-center">
        Уже есть аккаунт? <Link href="/login" className="text-accent hover:underline">Войти</Link>
      </p>
    </div>
  );
}
