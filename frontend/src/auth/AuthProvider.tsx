import React, { createContext, useContext, useMemo, useState } from "react";
import { api } from "../api/client";

type AuthContextType = {
  token: string | null;
  login: (username: string, password: string) => Promise<void>;
  register: (username: string, password: string) => Promise<void>;
  logout: () => void;
};

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [token, setToken] = useState<string | null>(localStorage.getItem("token"));

  const ctx = useMemo<AuthContextType>(() => ({
    token,
    async login(username, password) {
      const data = await api<{ access_token: string }>("/auth/login", {
        method: "POST",
        body: JSON.stringify({ username, password })
      });
      localStorage.setItem("token", data.access_token);
      setToken(data.access_token);
    },
    async register(username, password) {
      await api<{ ok: boolean }>("/auth/register", {
        method: "POST",
        body: JSON.stringify({ username, password })
      });
      await this.login(username, password);
    },
    logout() {
      localStorage.removeItem("token");
      setToken(null);
    }
  }), [token]);

  return <AuthContext.Provider value={ctx}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
