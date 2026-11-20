import { useState } from "react";
import { useTheme } from "@/context/ThemeContext";

const PortfolioScreenshots = ({ screens, testId = "portfolio-screenshots" }) => {
  const { theme } = useTheme();
  const [active, setActive] = useState(0);
  const current = screens[active] ?? screens[0];

  if (!screens?.length) return null;

  return (
    <div data-testid={testId} className="flex flex-col h-full min-h-[320px]">
      <div
        className={`relative flex-1 overflow-hidden ${
          theme === "dark" ? "bg-[#000000]" : "bg-slate-100"
        }`}
      >
        <div className="absolute inset-0 bg-gradient-to-br from-[#007AFF]/10 to-transparent pointer-events-none z-10" />
        <img
          key={current.src}
          src={current.src}
          alt={current.alt}
          className="absolute inset-0 w-full h-full object-contain object-top p-3 sm:p-4"
        />
      </div>

      <div
        className={`grid grid-cols-4 gap-1 p-2 border-t ${
          theme === "dark" ? "border-white/10 bg-[#0a1628]/80" : "border-black/10 bg-white"
        }`}
      >
        {screens.map((screen, index) => (
          <button
            key={screen.src}
            type="button"
            onClick={() => setActive(index)}
            data-testid={`${testId}-thumb-${index}`}
            aria-label={`View ${screen.label}`}
            aria-pressed={active === index}
            className={`relative overflow-hidden rounded-lg border-2 transition-all aspect-[4/3] ${
              active === index
                ? "border-[#007AFF] ring-2 ring-[#007AFF]/30"
                : theme === "dark"
                ? "border-white/10 opacity-70 hover:opacity-100"
                : "border-black/10 opacity-80 hover:opacity-100"
            }`}
          >
            <img
              src={screen.src}
              alt=""
              aria-hidden
              className="w-full h-full object-cover object-top"
            />
            <span
              className={`absolute inset-x-0 bottom-0 py-0.5 text-[9px] font-semibold text-center truncate ${
                theme === "dark"
                  ? "bg-black/75 text-slate-200"
                  : "bg-white/90 text-slate-700"
              }`}
            >
              {screen.label}
            </span>
          </button>
        ))}
      </div>
    </div>
  );
};

export default PortfolioScreenshots;
