import { useId } from "react";

const SIGNAL_PATHS = [
  "M200 250 C200 205 198 155 200 100 C202 70 200 48 200 36",
  "M188 252 C162 210 148 158 162 108 C176 78 190 52 198 38",
  "M212 252 C238 210 252 158 238 108 C224 78 210 52 202 38",
  "M176 254 C140 208 122 156 148 106 C168 76 186 50 197 37",
  "M224 254 C260 208 278 156 252 106 C232 76 214 50 203 37",
];

/** Floating icon hotspots — moving LED points inside panels */
const ICON_ZONES = [
  { left: "8%", top: "16%", label: "chart" },
  { left: "6%", top: "38%", label: "code" },
  { left: "14%", top: "58%", label: "gear" },
  { left: "78%", top: "18%", label: "user" },
  { left: "82%", top: "40%", label: "cloud" },
  { left: "74%", top: "58%", label: "donut" },
];

/**
 * Hero artwork with soft background blend, climbing signals, and moving icon points.
 */
const HeroVisual = ({ theme = "dark" }) => {
  const isDark = theme === "dark";
  const uid = useId().replace(/:/g, "");

  return (
    <div
      className="relative w-full max-w-2xl mx-auto aspect-[5/4] select-none"
      aria-hidden
      data-testid="hero-visual"
    >
      {/* Artwork — soft mask blends into background */}
      <div className="absolute inset-0 hero-scene-mask">
        <img
          src="/marketing/hero-ai-laptop.jpg"
          alt=""
          className="absolute inset-0 w-full h-full object-cover object-center scale-[1.02]"
          draggable={false}
        />
        <div
          className={`absolute inset-0 pointer-events-none ${
            isDark ? "hero-scene-fade-dark" : "hero-scene-fade-light"
          }`}
        />
      </div>

      {/* Animations (signals + icon points) */}
      <div className="absolute inset-0 pointer-events-none">
        {/* Signals climbing to bulb */}
        <svg
          className="absolute inset-0 w-full h-full"
          viewBox="0 0 400 400"
          preserveAspectRatio="xMidYMid slice"
        >
          <defs>
            <filter id={`sg-${uid}`} x="-50%" y="-50%" width="200%" height="200%">
              <feGaussianBlur stdDeviation="2" result="b" />
              <feMerge>
                <feMergeNode in="b" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>
          </defs>
          {SIGNAL_PATHS.map((d, i) => (
            <g key={i} filter={`url(#sg-${uid})`}>
              <circle r="3" fill="#00D1FF">
                <animateMotion
                  dur={`${2.2 + i * 0.3}s`}
                  repeatCount="indefinite"
                  begin={`${i * 0.35}s`}
                  path={d}
                />
              </circle>
              <circle r="1.4" fill="#fff">
                <animateMotion
                  dur={`${2.2 + i * 0.3}s`}
                  repeatCount="indefinite"
                  begin={`${i * 0.35 + 0.12}s`}
                  path={d}
                />
              </circle>
            </g>
          ))}
        </svg>

        {/* Moving points inside icon panels */}
        {ICON_ZONES.map((zone, zi) => (
          <div
            key={zone.label}
            className="absolute w-[14%] aspect-square"
            style={{ left: zone.left, top: zone.top }}
          >
            {Array.from({ length: 5 }).map((_, pi) => (
              <span
                key={pi}
                className="absolute w-1.5 h-1.5 rounded-full bg-[#00D1FF] hero-icon-point"
                style={{
                  left: `${18 + ((pi * 17 + zi * 9) % 64)}%`,
                  top: `${22 + ((pi * 23 + zi * 11) % 56)}%`,
                  animationDelay: `${zi * 0.2 + pi * 0.28}s`,
                  animationDuration: `${2.4 + (pi % 3) * 0.5}s`,
                }}
              />
            ))}
          </div>
        ))}
      </div>
    </div>
  );
};

export default HeroVisual;
