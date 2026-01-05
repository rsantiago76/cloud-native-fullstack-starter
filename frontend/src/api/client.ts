const DEFAULT_BASE = "http://localhost:8000";
export const apiBaseUrl = (import.meta as any).env?.VITE_API_BASE_URL || DEFAULT_BASE;

export async function api<T>(path: string, opts: RequestInit = {}): Promise<T> {
  const res = await fetch(`${apiBaseUrl}${path}`, {
    ...opts,
    headers: { "Content-Type": "application/json", ...(opts.headers || {}) }
  });

  if (!res.ok) {
    let body: any = null;
    try { body = await res.json(); } catch { /* ignore */ }
    const msg = (body && (body.detail || JSON.stringify(body))) || `${res.status} ${res.statusText}`;
    throw new Error(msg);
  }

  return (await res.json()) as T;
}
