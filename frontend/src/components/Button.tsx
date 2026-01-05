import React from "react";

export function Button(
  props: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: "primary" | "ghost" }
) {
  const { variant = "primary", className = "", ...rest } = props;
  const styles =
    variant === "primary"
      ? "bg-indigo-600 hover:bg-indigo-500 text-white"
      : "bg-transparent hover:bg-gray-800 text-gray-100 border border-gray-700";
  return (
    <button
      className={`px-4 py-2 rounded-xl text-sm font-medium transition ${styles} ${className}`}
      {...rest}
    />
  );
}
