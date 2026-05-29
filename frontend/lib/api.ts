const API_BASE = process.env.NEXT_PUBLIC_API_URL || '/api';

async function fetchApi(path: string, options: RequestInit = {}) {
  const url = `${API_BASE}${path}`;
  const token = typeof window !== 'undefined' ? localStorage.getItem('token') : null;

  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...((options.headers as Record<string, string>) || {}),
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const res = await fetch(url, { ...options, headers });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.error || err.message || `HTTP ${res.status}`);
  }
  return res.json();
}

export const api = {
  get: (path: string) => fetchApi(path, { method: 'GET' }),
  post: (path: string, body?: unknown) => fetchApi(path, { method: 'POST', body: body ? JSON.stringify(body) : undefined }),
  patch: (path: string, body?: unknown) => fetchApi(path, { method: 'PATCH', body: body ? JSON.stringify(body) : undefined }),
  del: (path: string) => fetchApi(path, { method: 'DELETE' }),
};
