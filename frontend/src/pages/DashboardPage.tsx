import { useEffect, useState } from "react";
import { useAuth } from "../auth/AuthProvider";
import { api, apiBaseUrl } from "../api/client";
import { Button } from "../components/Button";

type Me = { id: number; username: string; role: "user" | "admin" };
type WorkItem = { id: number; title: string; status: "open" | "done" };

export function DashboardPage() {
  const { token, logout } = useAuth();
  const [me, setMe] = useState<Me | null>(null);
  const [items, setItems] = useState<WorkItem[]>([]);
  const [title, setTitle] = useState("");
  const [err, setErr] = useState<string | null>(null);

  async function load() {
    setErr(null);
    const headers = { Authorization: `Bearer ${token}` };
    const meData = await api<Me>("/me", { headers });
    setMe(meData);
    const work = await api<WorkItem[]>("/work-items", { headers });
    setItems(work);
  }

  async function addItem() {
    if (!title.trim()) return;
    const headers = { Authorization: `Bearer ${token}` };
    await api<WorkItem>("/work-items", {
      method: "POST",
      headers,
      body: JSON.stringify({ title })
    });
    setTitle("");
    await load();
  }

  async function toggle(id: number) {
    const headers = { Authorization: `Bearer ${token}` };
    await api<WorkItem>(`/work-items/${id}/toggle`, { method: "POST", headers });
    await load();
  }

  useEffect(() => {
    load().catch((e) => setErr(e.message || "Failed to load"));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div className="min-h-screen p-6 max-w-3xl mx-auto">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold">Dashboard</h1>
          <p className="text-gray-400 text-sm">
            API: {apiBaseUrl} • Logged in as {me?.username ?? "…"}
          </p>
        </div>
        <Button variant="ghost" onClick={logout}>
          Logout
        </Button>
      </div>

      {err && (
        <div className="mt-4 p-3 rounded-xl border border-red-900 bg-red-950/40 text-red-200 text-sm">
          {err}
        </div>
      )}

      <div className="mt-6 flex gap-2">
        <input
          className="flex-1 bg-gray-950 border border-gray-800 rounded-xl px-3 py-2"
          placeholder="New work item..."
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
        <Button onClick={addItem}>Add</Button>
      </div>

      <div className="mt-6 space-y-2">
        {items.map((it) => (
          <div
            key={it.id}
            className="flex items-center justify-between p-3 rounded-xl border border-gray-800 bg-gray-900"
          >
            <div className="flex items-center gap-3">
              <input
                type="checkbox"
                checked={it.status === "done"}
                onChange={() => toggle(it.id)}
              />
              <span className={it.status === "done" ? "line-through text-gray-400" : ""}>
                {it.title}
              </span>
            </div>
            <span className="text-xs text-gray-400">{it.status}</span>
          </div>
        ))}
        {items.length === 0 && <div className="text-gray-500 text-sm mt-4">No work items yet.</div>}
      </div>
    </div>
  );
}
