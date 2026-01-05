import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../auth/AuthProvider";
import { Button } from "../components/Button";

export function LoginPage() {
  const { login, register } = useAuth();
  const nav = useNavigate();
  const [username, setUsername] = useState("demo");
  const [password, setPassword] = useState("demo1234");
  const [err, setErr] = useState<string | null>(null);
  const [mode, setMode] = useState<"login" | "register">("login");

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setErr(null);
    try {
      if (mode === "login") await login(username, password);
      else await register(username, password);
      nav("/dashboard");
    } catch (e: any) {
      setErr(e.message || "Auth failed");
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-6">
      <div className="w-full max-w-md bg-gray-900 border border-gray-800 rounded-2xl p-6 shadow">
        <h1 className="text-xl font-semibold">Cloud-Native Full-Stack Starter</h1>
        <p className="text-gray-400 mt-1">React + FastAPI + JWT + Terraform</p>

        <form className="mt-6 space-y-4" onSubmit={onSubmit}>
          <div>
            <label className="text-sm text-gray-300">Username</label>
            <input
              className="mt-1 w-full bg-gray-950 border border-gray-800 rounded-xl px-3 py-2"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              autoComplete="username"
            />
          </div>
          <div>
            <label className="text-sm text-gray-300">Password</label>
            <input
              className="mt-1 w-full bg-gray-950 border border-gray-800 rounded-xl px-3 py-2"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete={mode === "login" ? "current-password" : "new-password"}
            />
          </div>

          {err && <div className="text-sm text-red-300">{err}</div>}

          <Button type="submit" className="w-full">
            {mode === "login" ? "Sign in" : "Create account"}
          </Button>

          <div className="flex justify-between text-sm text-gray-400">
            <button
              type="button"
              className="hover:text-gray-200"
              onClick={() => setMode(mode === "login" ? "register" : "login")}
            >
              {mode === "login" ? "Need an account?" : "Have an account?"}
            </button>
            <a href="http://localhost:8000/docs" target="_blank" rel="noreferrer">
              API Docs
            </a>
          </div>
        </form>
      </div>
    </div>
  );
}
