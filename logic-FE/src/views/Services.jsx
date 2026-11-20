import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import {
  Code2,
  Smartphone,
  Container,
  Database,
  Shield,
  Cpu,
  Layers,
  ArrowRight,
  ArrowUpRight,
  GraduationCap,
  Users,
  Briefcase,
  Cloud,
} from "lucide-react";
import { Link } from "react-router-dom";
import DynamicIcon from "@/components/DynamicIcon";
import { useTheme } from "@/context/ThemeContext";

const fadeUp = {
  initial: { opacity: 0, y: 20 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-60px" },
  transition: { duration: 0.55 },
};

const STATIC_SERVICES = [
  {
    id: "web",
    icon: Code2,
    title: "Enterprise Web Platforms",
    desc: "Laravel + Next.js stacks engineered for transactional scale, type-safe APIs, and edge-cached delivery.",
    tags: ["Laravel", "Next.js", "tRPC", "Postgres"],
  },
  {
    id: "mobile",
    icon: Smartphone,
    title: "Cross-Platform Mobile",
    desc: "Flutter applications with native performance, fluid motion and offline-first design.",
    tags: ["Flutter", "Dart", "Firebase"],
  },
  {
    id: "cloud",
    icon: Cloud,
    title: "Cloud & DevOps",
    desc: "Docker-based architectures, CI/CD pipelines, and cloud infrastructure that keeps releases calm.",
    tags: ["Docker", "Compose", "K8s", "CI/CD"],
  },
  {
    id: "data",
    icon: Database,
    title: "Data & APIs",
    desc: "Polyglot persistence, event-driven systems, and APIs designed to evolve gracefully.",
    tags: ["PostgreSQL", "MongoDB", "Redis", "Kafka"],
  },
  {
    id: "ai",
    icon: Cpu,
    title: "AI Integrations",
    desc: "Embeddings, agents and classification flows woven directly into your product pipeline.",
    tags: ["OpenAI", "Claude", "Gemini"],
  },
  {
    id: "security",
    icon: Shield,
    title: "Security & Compliance",
    desc: "Hardened auth, audit logging, and infrastructure baselines for regulated industries.",
    tags: ["OAuth", "SOC2", "GDPR"],
  },
  {
    id: "outsourcing",
    icon: Briefcase,
    title: "IT Outsourcing Services",
    desc: "End-to-end outsourcing for custom product engineering, integrations, and lifecycle support.",
    tags: ["Product Dev", "Outsourcing", "QA", "Managed Delivery"],
  },
  {
    id: "staffing",
    icon: Users,
    title: "Resource Provisioning",
    desc: "Senior developers, DevOps specialists, and designers embedded directly into your squads.",
    tags: ["Staff Augmentation", "React & Laravel", "On-Demand"],
  },
  {
    id: "training",
    icon: GraduationCap,
    title: "Corporate Technical Training",
    desc: "Architectural workshops, framework bootcamps, and best-practice training for engineering teams.",
    tags: ["Laravel", "Next.js", "System Design"],
  },
  {
    id: "modernization",
    icon: Layers,
    title: "Modernization",
    desc: "Strangler-fig migrations from legacy CMS / monoliths to clean, headless platforms.",
    tags: ["Headless", "API-first"],
  },
];

const Services = () => {
  const { theme } = useTheme();
  const isDark = theme === "dark";
  const [serviceList, setServiceList] = useState(STATIC_SERVICES);

  useEffect(() => {
    const API_BASE_URL =
      process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";
    fetch(`${API_BASE_URL}/api/services`)
      .then((res) => {
        if (!res.ok) throw new Error("API failed");
        return res.json();
      })
      .then((data) => {
        if (Array.isArray(data) && data.length > 0) {
          setServiceList(data);
        }
      })
      .catch((err) => {
        console.warn(
          "Using offline fallback services due to API error:",
          err.message
        );
      });
  }, []);

  const renderIcon = (iconSource, className) => {
    if (typeof iconSource === "string") {
      return <DynamicIcon name={iconSource} className={className} />;
    }
    const IconComponent = iconSource || Container;
    return <IconComponent className={className} />;
  };

  return (
    <div data-testid="services-page" className="pt-28 pb-24">
      {/* Hero */}
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
              Our Services
            </span>
            <h1 className="mt-5 text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tighter leading-[1.08]">
              Smart Solutions.{" "}
              <span className="text-[#007AFF]">Real Impact.</span>
            </h1>
            <p
              className={`mt-6 text-lg leading-relaxed ${
                isDark ? "text-slate-300" : "text-slate-600"
              }`}
            >
              Custom software, ERP, cloud, and AI — engineered in Kottayam for
              teams across India that need depth, not fluff.
            </p>
          </motion.div>
        </div>
      </section>

      {/* Grid */}
      <section className="max-w-7xl mx-auto px-6 sm:px-10">
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {serviceList.map((s, i) => (
            <motion.div
              key={s.title || s.id || i}
              id={s.id}
              {...fadeUp}
              transition={{ ...fadeUp.transition, delay: (i % 3) * 0.05 }}
              data-testid={`service-card-${i}`}
              className={`group relative overflow-hidden rounded-3xl p-7 sm:p-8 border transition-all ${
                isDark
                  ? "border-white/10 bg-[#0a1628]/70 hover:border-[#007AFF]/50"
                  : "border-black/8 bg-white shadow-sm hover:border-[#007AFF]/40 hover:shadow-md"
              }`}
            >
              <div className="w-12 h-12 rounded-full bg-[#007AFF]/15 grid place-items-center mb-5">
                {renderIcon(s.icon, "w-5 h-5 text-[#007AFF]")}
              </div>
              <h3 className="text-xl font-bold tracking-tight">{s.title}</h3>
              <div className="mt-3 w-8 h-0.5 bg-[#007AFF] rounded-full" />
              <p
                className={`mt-4 text-sm leading-relaxed ${
                  isDark ? "text-slate-400" : "text-slate-600"
                }`}
              >
                {s.desc}
              </p>
              <div className="mt-5 flex flex-wrap gap-2">
                {s.tags?.map((t) => (
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
              <div className="absolute right-6 top-6 opacity-0 group-hover:opacity-100 transition">
                <ArrowUpRight className="w-4 h-4 text-[#007AFF]" />
              </div>
            </motion.div>
          ))}
        </div>

        {/* CTA */}
        <motion.div
          {...fadeUp}
          className={`mt-20 relative overflow-hidden rounded-3xl p-10 sm:p-14 border ${
            isDark
              ? "border-white/10 bg-gradient-to-br from-[#007AFF]/15 via-[#0a1628]/60 to-transparent"
              : "border-black/8 bg-gradient-to-br from-[#007AFF]/8 via-white to-slate-50"
          }`}
        >
          <div className="absolute -right-20 -bottom-20 w-80 h-80 bg-[#007AFF]/15 blur-3xl rounded-full" />
          <div className="relative grid md:grid-cols-2 gap-8 items-center">
            <div>
              <h2 className="text-3xl sm:text-4xl font-bold tracking-tighter">
                Want a tailored engagement model?
              </h2>
              <p
                className={`mt-4 ${
                  isDark ? "text-slate-300" : "text-slate-600"
                }`}
              >
                Fixed scope, retainer, or embedded squad — designed around how
                your team actually works.
              </p>
            </div>
            <div className="flex md:justify-end">
              <Link
                to="/contact"
                data-testid="services-cta"
                className="inline-flex items-center gap-2 px-7 py-4 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white font-semibold brand-glow transition-all"
              >
                Get in Touch <ArrowRight className="w-4 h-4" />
              </Link>
            </div>
          </div>
        </motion.div>
      </section>
    </div>
  );
};

export default Services;
