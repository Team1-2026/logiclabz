import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { ArrowRight, ArrowUpRight, Building2, Fuel, BookOpen, Calculator } from "lucide-react";
import { Link } from "react-router-dom";
import PortfolioScreenshots from "@/components/PortfolioScreenshots";
import DynamicIcon from "@/components/DynamicIcon";
import { FUEL_MANAGEMENT_SCREENS } from "@/data/fuelManagementScreens";
import { useTheme } from "@/context/ThemeContext";

const fadeUp = {
  initial: { opacity: 0, y: 22 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-60px" },
  transition: { duration: 0.55 },
};

const PROJECTS = [
  {
    id: "logic-erp",
    title: "Logic ERP",
    pillar: "ERP Solutions",
    icon: Building2,
    summary:
      "An end-to-end ERP suite consolidating finance, inventory and HR — built on a Docker-based modular architecture serving 12k+ daily users.",
    image:
      "https://static.prod-images.emergentagent.com/jobs/ab47ab39-9ae3-4f62-903a-fabf5bc57ffb/images/45be161bcc51a044c5702a318c198d20c44fc4b1b78f6db7bf2706edff118dac.png",
    metrics: [
      { k: "Daily users", v: "12k+" },
      { k: "Modules", v: "18" },
      { k: "Uptime", v: "99.97%" },
    ],
    tech: ["Laravel", "React", "Postgres", "Docker"],
  },
  {
    id: "fuel-management",
    title: "Petrol Pump Management",
    pillar: "Fuel Management",
    icon: Fuel,
    summary:
      "End-to-end petrol pump software for daily opening and closing readings, multi-nozzle sales (HSD, MS, XP, XG), and payment reconciliation across cash, UPI, card, and wallet.",
    screenshots: FUEL_MANAGEMENT_SCREENS,
    metrics: [
      { k: "Pumps", v: "4+" },
      { k: "Payments", v: "Cash · UPI · Card" },
      { k: "Workflow", v: "Open → Close" },
    ],
    tech: ["React", "Laravel", "PostgreSQL"],
  },
  {
    id: "accounting",
    title: "Accounting Module",
    pillar: "Specialized Modules",
    icon: Calculator,
    summary:
      "GAAP-compliant accounting engine plugged into the Logic ERP — handling multi-entity consolidations and audit trails.",
    image:
      "https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1200&q=80",
    metrics: [
      { k: "Entities", v: "Multi" },
      { k: "Reports", v: "GAAP" },
      { k: "Audit", v: "Full trail" },
    ],
    tech: ["Laravel", "Vue", "Postgres"],
  },
  {
    id: "student-scheduling",
    title: "Student / Faculty Scheduling",
    pillar: "Education Tech",
    icon: BookOpen,
    summary:
      "Constraint-solver-backed scheduling for higher-ed institutions — automating timetables across faculty, rooms, and electives.",
    image:
      "https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=1200&q=80",
    metrics: [
      { k: "Institutions", v: "12" },
      { k: "Time saved", v: "85%" },
      { k: "Conflicts", v: "Auto-resolved" },
    ],
    tech: ["Next.js", "Python", "OR-Tools"],
  },
];

const Portfolio = () => {
  const { theme } = useTheme();
  const isDark = theme === "dark";
  const [projectList, setProjectList] = useState(PROJECTS);

  useEffect(() => {
    const API_BASE_URL =
      process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";
    fetch(`${API_BASE_URL}/api/projects`)
      .then((res) => {
        if (!res.ok) throw new Error("API failed");
        return res.json();
      })
      .then((data) => {
        if (Array.isArray(data) && data.length > 0) {
          setProjectList(data);
        }
      })
      .catch((err) => {
        console.warn(
          "Using offline fallback projects due to API error:",
          err.message
        );
      });
  }, []);

  const renderIcon = (iconSource, className) => {
    if (typeof iconSource === "string") {
      return <DynamicIcon name={iconSource} className={className} />;
    }
    const IconComponent = iconSource;
    return <IconComponent className={className} />;
  };

  return (
    <div data-testid="portfolio-page" className="pt-28 pb-24">
      <section className="relative overflow-hidden pb-12">
        <div
          className={`absolute inset-0 ${
            isDark ? "hero-mesh opacity-60" : "hero-mesh-light"
          }`}
        />
        <div className="relative max-w-7xl mx-auto px-6 sm:px-10">
          <motion.div
            initial={{ opacity: 0, y: 14 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="max-w-3xl"
          >
            <span
              className={`inline-flex px-3.5 py-1.5 rounded-full border text-[11px] font-semibold tracking-wide uppercase text-[#007AFF] ${
                isDark
                  ? "border-[#007AFF]/40 bg-[#007AFF]/10"
                  : "border-[#007AFF]/30 bg-[#007AFF]/5"
              }`}
            >
              Our Work
            </span>
            <h1 className="mt-5 text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tighter leading-[1.08]">
              Products that{" "}
              <span className="text-[#007AFF]">move metrics.</span>
            </h1>
            <p
              className={`mt-6 text-lg leading-relaxed ${
                isDark ? "text-slate-300" : "text-slate-600"
              }`}
            >
              ERP, fuel management, accounting, and education platforms —
              selected for technical depth, not vanity.
            </p>
          </motion.div>
        </div>
      </section>

      <section className="max-w-7xl mx-auto px-6 sm:px-10 space-y-8">
        {projectList.map((p, i) => (
          <motion.div
            key={p.id || p.slug || i}
            {...fadeUp}
            data-testid={`portfolio-item-${p.slug || p.id}`}
            className={`group relative overflow-hidden rounded-3xl border ${
              isDark
                ? "border-white/10 bg-[#0a1628]/70"
                : "border-black/8 bg-white shadow-sm"
            } hover:border-[#007AFF]/50 transition-all`}
          >
            <div
              className={`grid md:grid-cols-12 gap-0 ${
                i % 2 === 1 ? "md:[direction:rtl]" : ""
              }`}
            >
              <div className="md:col-span-5 p-8 sm:p-10 md:[direction:ltr]">
                <div className="inline-flex items-center gap-2 text-[#007AFF] text-xs font-semibold uppercase tracking-widest">
                  <span className="w-9 h-9 rounded-full bg-[#007AFF]/15 grid place-items-center">
                    {renderIcon(p.icon, "w-4 h-4")}
                  </span>
                  {p.pillar}
                </div>
                <h3 className="mt-5 text-3xl sm:text-4xl font-bold tracking-tighter">
                  {p.title}
                </h3>
                <div className="mt-3 w-8 h-0.5 bg-[#007AFF] rounded-full" />
                <p
                  className={`mt-4 leading-relaxed ${
                    isDark ? "text-slate-400" : "text-slate-600"
                  }`}
                >
                  {p.summary}
                </p>
                <div className="mt-6 grid grid-cols-3 gap-4">
                  {p.metrics?.map((m) => (
                    <div key={m.k}>
                      <div className="text-xl font-bold text-[#007AFF]">
                        {m.v}
                      </div>
                      <div
                        className={`text-[11px] uppercase tracking-wider mt-1 ${
                          isDark ? "text-slate-500" : "text-slate-500"
                        }`}
                      >
                        {m.k}
                      </div>
                    </div>
                  ))}
                </div>
                <div className="mt-6 flex flex-wrap gap-2">
                  {p.tech?.map((t) => (
                    <span
                      key={t}
                      className={`text-[11px] px-2.5 py-1 rounded-full border ${
                        isDark
                          ? "border-white/10 text-slate-300"
                          : "border-black/10 text-slate-700"
                      }`}
                    >
                      {t}
                    </span>
                  ))}
                </div>
                <button
                  data-testid={`portfolio-detail-${p.slug || p.id}`}
                  className="mt-8 inline-flex items-center gap-2 text-sm font-semibold text-[#007AFF] hover:gap-3 transition-all"
                >
                  Read case study <ArrowUpRight className="w-4 h-4" />
                </button>
              </div>
              <div className="md:col-span-7 relative md:[direction:ltr]">
                {p.screenshots && p.screenshots.length > 0 ? (
                  <PortfolioScreenshots
                    screens={p.screenshots}
                    testId={`portfolio-screens-${p.slug || p.id}`}
                  />
                ) : (
                  <div
                    className={`relative h-full min-h-[280px] ${
                      isDark ? "bg-[#050a14]" : "bg-slate-100"
                    }`}
                  >
                    <div className="absolute inset-0 bg-gradient-to-br from-[#007AFF]/15 to-transparent z-[1]" />
                    {p.image && (
                      <img
                        src={p.image}
                        alt={p.title}
                        className="absolute inset-0 w-full h-full object-cover opacity-90"
                      />
                    )}
                  </div>
                )}
              </div>
            </div>
          </motion.div>
        ))}

        <motion.div
          {...fadeUp}
          className={`mt-12 relative overflow-hidden rounded-3xl p-10 sm:p-14 border text-center ${
            isDark
              ? "border-white/10 bg-gradient-to-br from-[#007AFF]/15 via-[#0a1628]/60 to-transparent"
              : "border-black/8 bg-gradient-to-br from-[#007AFF]/8 via-white to-slate-50"
          }`}
        >
          <h2 className="text-3xl sm:text-4xl font-bold tracking-tighter">
            Have a product worth shipping well?
          </h2>
          <p
            className={`mt-4 max-w-xl mx-auto ${
              isDark ? "text-slate-300" : "text-slate-600"
            }`}
          >
            Tell us about your build — we&apos;ll map architecture, risks, and a
            clear delivery path.
          </p>
          <Link
            to="/contact"
            className="mt-8 inline-flex items-center gap-2 px-7 py-4 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white font-semibold brand-glow transition-all"
          >
            Get in Touch <ArrowRight className="w-4 h-4" />
          </Link>
        </motion.div>
      </section>
    </div>
  );
};

export default Portfolio;
