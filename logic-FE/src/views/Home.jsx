import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import {
  ArrowRight,
  ArrowUpRight,
  Award,
  Cloud,
  Code2,
  Lightbulb,
  Map,
  Rocket,
  Shield,
  Smartphone,
  Trophy,
  Users,
} from "lucide-react";
import HeroVisual from "@/components/HeroVisual";
import ParticleBackground from "@/components/ParticleBackground";
import { useTheme } from "@/context/ThemeContext";

const fadeUp = {
  initial: { opacity: 0, y: 24 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-80px" },
  transition: { duration: 0.6, ease: [0.22, 1, 0.36, 1] },
};

const OFFICE_IMG =
  "https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1200&q=80";
const TEAM_IMG =
  "https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=1000&q=80";
const PHONE_IMG =
  "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?auto=format&fit=crop&w=600&q=80";
const SERVER_IMG =
  "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=600&q=80";

const TRUSTED = [
  { name: "Innovation First", mark: "→" },
  { name: "TechNova", mark: "◈" },
  { name: "NextGen Solutions", mark: "⬡" },
  { name: "BrightEdge", mark: "b" },
  { name: "PeakPerformance Labs", mark: "▲" },
];

const JOURNEY = [
  {
    value: "16+",
    label: "Years of Experience",
    icon: Award,
    color: "#007AFF",
    bg: "bg-[#007AFF]/15",
  },
  {
    value: "250+",
    label: "Web & Mobile Developed",
    icon: Smartphone,
    color: "#10b981",
    bg: "bg-emerald-500/15",
  },
  {
    value: "500+",
    label: "Projects Completed",
    icon: Rocket,
    color: "#a78bfa",
    bg: "bg-violet-500/15",
  },
  {
    value: "99.95%",
    label: "Uptime SLA",
    icon: Shield,
    color: "#f97316",
    bg: "bg-orange-500/15",
  },
];

const PROCESS = [
  {
    id: 1,
    label: "Discovery",
    desc: "Workshops to map goals, constraints, and success metrics.",
    icon: Lightbulb,
  },
  {
    id: 2,
    label: "Architecture",
    desc: "Service boundaries, data models, and delivery foundations.",
    icon: Map,
  },
  {
    id: 3,
    label: "Development",
    desc: "Sprint-based delivery on Laravel, React, and Flutter.",
    icon: Code2,
  },
  {
    id: 4,
    label: "Deployment",
    desc: "CI/CD, observability, and zero-downtime releases.",
    icon: Rocket,
  },
];

const TECH_STACK = [
  { name: "Laravel", category: "Backend" },
  { name: "Next.js", category: "Framework" },
  { name: "React", category: "Frontend" },
  { name: "Flutter", category: "Mobile" },
  { name: "TypeScript", category: "Language" },
  { name: "PHP", category: "Language" },
  { name: "PostgreSQL", category: "Database" },
  { name: "MongoDB", category: "Database" },
  { name: "Redis", category: "Cache" },
  { name: "Docker", category: "DevOps" },
  { name: "Kubernetes", category: "DevOps" },
  { name: "AWS", category: "Cloud Platform" },
  { name: "Node.js", category: "Runtime" },
  { name: "Python", category: "Language" },
  { name: "OpenAI", category: "AI Platform" },
  { name: "Tailwind CSS", category: "UI" },
  { name: "GraphQL", category: "API" },
  { name: "CI / CD", category: "Delivery" },
];

const Home = () => {
  const { theme } = useTheme();
  const isDark = theme === "dark";

  return (
    <div data-testid="home-page">
      {/* ─── HERO ─── */}
      <section className="relative min-h-[100vh] flex items-center overflow-hidden pt-28 pb-16">
        <div className="absolute inset-0">
          <div
            className={`absolute inset-0 ${
              isDark
                ? "bg-[radial-gradient(ellipse_at_70%_55%,_#0a2244_0%,_#050a14_58%)]"
                : "bg-[radial-gradient(ellipse_at_70%_55%,_#dbeafe_0%,_#f8fafc_58%)]"
            }`}
          />
          {/* Soft mountain wash — matches artwork horizon */}
          <div
            className={`absolute inset-x-0 bottom-0 h-[42%] ${
              isDark
                ? "bg-gradient-to-t from-[#061018] via-[#0a1a2e]/50 to-transparent"
                : "bg-gradient-to-t from-slate-200/80 via-slate-100/40 to-transparent"
            }`}
          />
          <div
            className={`absolute inset-0 ${
              isDark ? "hero-mesh opacity-70" : "hero-mesh-light"
            }`}
          />
          <div
            className={`absolute inset-0 ${
              isDark
                ? "bg-gradient-to-r from-[#050a14] via-[#050a14]/75 to-transparent"
                : "bg-gradient-to-r from-white via-white/80 to-transparent"
            }`}
          />
          {isDark && <ParticleBackground />}
        </div>

        <div className="relative z-10 max-w-7xl mx-auto px-6 sm:px-10 w-full">
          <div className="grid lg:grid-cols-2 gap-10 lg:gap-6 items-center">
            <div className="relative z-10">
              <motion.div
                initial={{ opacity: 0, y: 14 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5 }}
                className={`inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full border text-[11px] font-semibold tracking-wide uppercase ${
                  isDark
                    ? "border-[#007AFF]/40 bg-[#007AFF]/10 text-slate-200"
                    : "border-[#007AFF]/30 bg-white text-slate-700 shadow-sm"
                }`}
                data-testid="hero-pill"
              >
                <Lightbulb className="w-3.5 h-3.5 text-[#007AFF]" />
                AI Powered Solutions for the Future
              </motion.div>

              <motion.h1
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.7, delay: 0.1 }}
                className="mt-6 text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tighter leading-[1.08]"
              >
                We Build Intelligent Software for an{" "}
                <span className="text-[#007AFF]">AI-Powered World</span>
              </motion.h1>

              <motion.p
                initial={{ opacity: 0, y: 16 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.2 }}
                className={`mt-6 max-w-xl text-base sm:text-lg leading-relaxed ${
                  isDark ? "text-slate-300" : "text-slate-600"
                }`}
              >
                LogicLabz is a software development company in Kottayam,
                Kerala — ERP providers building custom software, accounting
                platforms, and intelligent products for teams across India.
              </motion.p>

              <motion.div
                initial={{ opacity: 0, y: 16 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.3 }}
                className="mt-9 flex flex-wrap items-center gap-3"
              >
                <Link
                  to="/services"
                  data-testid="hero-cta-primary"
                  className="group inline-flex items-center gap-2 px-6 py-3.5 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white font-semibold brand-glow transition-all"
                >
                  Explore Services
                  <ArrowRight className="w-4 h-4 group-hover:translate-x-0.5 transition-transform" />
                </Link>
                <Link
                  to="/portfolio"
                  data-testid="hero-cta-secondary"
                  className={`inline-flex items-center gap-2 px-6 py-3.5 rounded-full border font-semibold transition-all ${
                    isDark
                      ? "border-[#007AFF]/50 text-[#007AFF] hover:bg-[#007AFF]/10"
                      : "border-[#007AFF]/40 text-[#007AFF] hover:bg-[#007AFF]/5"
                  }`}
                >
                  View Our Work
                  <ArrowRight className="w-4 h-4" />
                </Link>
              </motion.div>
            </div>

            <motion.div
              initial={{ opacity: 0, scale: 0.96 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.8, delay: 0.2 }}
              className="relative lg:-mr-4"
            >
              <HeroVisual theme={theme} />
            </motion.div>
          </div>
        </div>
      </section>

      {/* ─── TRUSTED BY ─── */}
      <section
        className={`relative py-10 border-y ${
          isDark
            ? "border-white/5 bg-[#071018]"
            : "border-black/5 bg-[#f1f5f9]"
        }`}
        data-testid="trusted-section"
      >
        <div className="max-w-7xl mx-auto px-6 sm:px-10">
          <p className="text-center text-[11px] font-semibold tracking-[0.25em] uppercase text-[#007AFF] mb-7">
            Trusted by Innovative Brands
          </p>
          <div className="flex flex-wrap items-center justify-center gap-x-0 gap-y-6">
            {TRUSTED.map((brand, i) => (
              <div key={brand.name} className="flex items-center">
                <div
                  className={`flex items-center gap-2.5 px-5 sm:px-7 ${
                    isDark ? "text-slate-300" : "text-slate-600"
                  }`}
                >
                  <span className="text-[#007AFF] text-lg font-bold leading-none">
                    {brand.mark}
                  </span>
                  <span className="text-sm font-semibold tracking-tight whitespace-nowrap">
                    {brand.name}
                  </span>
                </div>
                {i < TRUSTED.length - 1 && (
                  <div
                    className={`hidden sm:block w-px h-8 ${
                      isDark ? "bg-white/10" : "bg-black/10"
                    }`}
                  />
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ─── TECH STACK ─── */}
      <section
        className={`relative py-20 sm:py-28 overflow-hidden ${
          isDark ? "bg-[#05080f]" : "bg-[#0b1220]"
        }`}
        data-testid="tech-stack-section"
      >
        {/* Blueprint grid */}
        <div
          className="absolute inset-0 opacity-[0.35] pointer-events-none"
          style={{
            backgroundImage:
              "linear-gradient(rgba(255,255,255,0.04) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.04) 1px, transparent 1px)",
            backgroundSize: "48px 48px",
          }}
        />
        {/* Top accent line */}
        <div className="absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-[#007AFF] to-transparent opacity-70" />
        {/* Floating glow points */}
        <div className="absolute inset-0 pointer-events-none overflow-hidden">
          {[
            { l: "8%", t: "18%", s: 8, d: "0s" },
            { l: "22%", t: "72%", s: 6, d: "0.6s" },
            { l: "48%", t: "28%", s: 10, d: "1.1s" },
            { l: "68%", t: "64%", s: 7, d: "0.3s" },
            { l: "86%", t: "22%", s: 9, d: "1.5s" },
            { l: "78%", t: "48%", s: 5, d: "0.9s" },
            { l: "14%", t: "48%", s: 6, d: "1.8s" },
            { l: "56%", t: "78%", s: 8, d: "0.4s" },
          ].map((p, i) => (
            <span
              key={i}
              className="absolute rounded-full tech-glow-dot"
              style={{
                left: p.l,
                top: p.t,
                width: p.s,
                height: p.s,
                animationDelay: p.d,
              }}
            />
          ))}
        </div>

        <div className="relative max-w-7xl mx-auto px-6 sm:px-10">
          <motion.div {...fadeUp} className="text-center max-w-3xl mx-auto">
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tighter text-white">
              Powered by{" "}
              <span className="tech-gradient-text">cutting-edge tech.</span>
            </h2>
            <p className="mt-4 text-base sm:text-lg text-slate-400">
              We use modern, proven technologies to build software that scales —
              from ERP cores to AI-ready product layers.
            </p>
          </motion.div>

          <div className="mt-14 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 sm:gap-4">
            {TECH_STACK.map((tech, i) => (
              <motion.div
                key={tech.name}
                initial={{ opacity: 0, y: 16 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true, margin: "-40px" }}
                transition={{ duration: 0.4, delay: (i % 6) * 0.04 }}
                data-testid={`tech-card-${i}`}
                className="group relative rounded-2xl border border-white/10 bg-white/[0.03] px-3 py-5 sm:py-6 text-center backdrop-blur-[2px] transition-all duration-300 hover:border-[#007AFF]/45 hover:bg-[#007AFF]/8"
              >
                <div className="absolute inset-0 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity bg-gradient-to-b from-[#007AFF]/10 to-transparent pointer-events-none" />
                <div className="relative">
                  <div className="text-sm sm:text-base font-bold tracking-tight text-white">
                    {tech.name}
                  </div>
                  <div className="mt-1.5 text-[10px] sm:text-[11px] uppercase tracking-[0.14em] text-slate-500 font-medium">
                    {tech.category}
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* ─── JOURNEY STATS ─── */}
      <section
        className={`relative py-20 sm:py-28 ${
          isDark ? "" : "bg-[#f8fafc]"
        }`}
        data-testid="journey-section"
      >
        <div className="max-w-7xl mx-auto px-6 sm:px-10">
          <motion.div {...fadeUp} className="text-center max-w-2xl mx-auto">
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tighter">
              Our Journey So Far
            </h2>
            <p
              className={`mt-4 text-base sm:text-lg ${
                isDark ? "text-slate-400" : "text-slate-600"
              }`}
            >
              Sixteen years of shipping ERP, accounting software, and custom
              platforms — measured by uptime, delivery, and lasting client
              partnerships.
            </p>
          </motion.div>

          <div className="mt-14 grid grid-cols-2 lg:grid-cols-4 gap-6 lg:gap-0">
            {JOURNEY.map((stat, i) => (
              <motion.div
                key={stat.label}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.08 }}
                data-testid={`journey-stat-${i}`}
                className={`relative text-center px-4 py-6 ${
                  i < JOURNEY.length - 1
                    ? `lg:border-r ${
                        isDark ? "lg:border-white/10" : "lg:border-black/10"
                      }`
                    : ""
                }`}
              >
                <div
                  className={`mx-auto w-14 h-14 rounded-full grid place-items-center ${stat.bg}`}
                >
                  <stat.icon className="w-6 h-6" style={{ color: stat.color }} />
                </div>
                <div className="mt-4 text-3xl sm:text-4xl font-bold tracking-tight">
                  {stat.value}
                </div>
                <div
                  className={`mt-1.5 text-sm ${
                    isDark ? "text-slate-400" : "text-slate-600"
                  }`}
                >
                  {stat.label}
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* ─── SERVICES ─── */}
      <section className="relative py-20 sm:py-28" data-testid="services-teaser">
        <div className="max-w-7xl mx-auto px-6 sm:px-10">
          <motion.div {...fadeUp} className="max-w-2xl">
            <span className="text-xs uppercase tracking-[0.25em] text-[#007AFF] font-semibold">
              Our Services
            </span>
            <h2 className="mt-3 text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tighter">
              Smart Solutions.{" "}
              <span className="text-[#007AFF]">Real Impact.</span>
            </h2>
          </motion.div>

          <div className="mt-12 grid lg:grid-cols-2 gap-5">
            {/* Large photo card */}
            <motion.div
              {...fadeUp}
              className="relative overflow-hidden rounded-3xl min-h-[420px] group"
              data-testid="services-featured"
            >
              <img
                src={TEAM_IMG}
                alt="LogicLabz team collaborating on software products"
                className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-[#050a14] via-[#050a14]/40 to-transparent" />
              <div className="absolute bottom-0 inset-x-0 p-6 sm:p-8">
                <div className="flex flex-wrap gap-6 sm:gap-10">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-[#007AFF]/20 grid place-items-center">
                      <Trophy className="w-5 h-5 text-[#007AFF]" />
                    </div>
                    <div>
                      <div className="text-xl font-bold text-white">200+</div>
                      <div className="text-xs text-slate-300">
                        Projects Delivered
                      </div>
                    </div>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-[#007AFF]/20 grid place-items-center">
                      <Users className="w-5 h-5 text-[#007AFF]" />
                    </div>
                    <div>
                      <div className="text-xl font-bold text-white">150+</div>
                      <div className="text-xs text-slate-300">Happy Clients</div>
                    </div>
                  </div>
                </div>
              </div>
            </motion.div>

            {/* Stacked service cards */}
            <div className="flex flex-col gap-5">
              <motion.div
                {...fadeUp}
                transition={{ ...fadeUp.transition, delay: 0.08 }}
                className={`group relative overflow-hidden rounded-3xl border p-6 sm:p-7 flex gap-5 ${
                  isDark
                    ? "border-white/10 bg-[#0a1628]/80"
                    : "border-black/8 bg-white shadow-sm"
                }`}
                data-testid="service-card-web"
              >
                <div className="flex-1 min-w-0">
                  <div className="w-11 h-11 rounded-xl bg-[#007AFF]/15 grid place-items-center">
                    <Smartphone className="w-5 h-5 text-[#007AFF]" />
                  </div>
                  <h3 className="mt-4 text-xl font-bold tracking-tight">
                    Web & Mobile Applications
                  </h3>
                  <p
                    className={`mt-2 text-sm leading-relaxed ${
                      isDark ? "text-slate-400" : "text-slate-600"
                    }`}
                  >
                    Cross-platform products with Laravel APIs, Next.js frontends,
                    and Flutter apps — built for performance and longevity.
                  </p>
                  <Link
                    to="/services"
                    className="mt-4 inline-flex items-center gap-1.5 text-sm font-semibold text-[#007AFF] hover:gap-2.5 transition-all"
                  >
                    Learn More <ArrowRight className="w-4 h-4" />
                  </Link>
                </div>
                <div className="hidden sm:block w-36 shrink-0 rounded-2xl overflow-hidden self-stretch">
                  <img
                    src={PHONE_IMG}
                    alt=""
                    aria-hidden
                    className="w-full h-full object-cover"
                  />
                </div>
              </motion.div>

              <motion.div
                {...fadeUp}
                transition={{ ...fadeUp.transition, delay: 0.12 }}
                className={`group relative overflow-hidden rounded-3xl border p-6 sm:p-7 flex gap-5 ${
                  isDark
                    ? "border-white/10 bg-[#0a1628]/80"
                    : "border-black/8 bg-white shadow-sm"
                }`}
                data-testid="service-card-cloud"
              >
                <div className="flex-1 min-w-0">
                  <div className="w-11 h-11 rounded-xl bg-emerald-500/15 grid place-items-center">
                    <Cloud className="w-5 h-5 text-emerald-400" />
                  </div>
                  <h3 className="mt-4 text-xl font-bold tracking-tight">
                    Cloud & DevOps Services
                  </h3>
                  <p
                    className={`mt-2 text-sm leading-relaxed ${
                      isDark ? "text-slate-400" : "text-slate-600"
                    }`}
                  >
                    Docker-based architectures, CI/CD pipelines, and cloud
                    infrastructure that keeps releases calm and predictable.
                  </p>
                  <Link
                    to="/services"
                    className="mt-4 inline-flex items-center gap-1.5 text-sm font-semibold text-[#007AFF] hover:gap-2.5 transition-all"
                  >
                    Learn More <ArrowRight className="w-4 h-4" />
                  </Link>
                </div>
                <div className="hidden sm:block w-36 shrink-0 rounded-2xl overflow-hidden self-stretch">
                  <img
                    src={SERVER_IMG}
                    alt=""
                    aria-hidden
                    className="w-full h-full object-cover"
                  />
                </div>
              </motion.div>
            </div>
          </div>
        </div>
      </section>

      {/* ─── ABOUT TEASER ─── */}
      <section
        className={`relative py-20 sm:py-28 ${
          isDark ? "bg-[#071018]" : "bg-[#f1f5f9]"
        }`}
        data-testid="about-teaser"
      >
        <div className="max-w-7xl mx-auto px-6 sm:px-10">
          <div
            className={`rounded-[1.75rem] p-8 sm:p-12 lg:p-14 ${
              isDark
                ? "bg-[#0a1628]/60 border border-white/5"
                : "bg-white border border-black/5 shadow-sm"
            }`}
          >
            <div className="grid lg:grid-cols-2 gap-10 lg:gap-14 items-center">
              <motion.div {...fadeUp}>
                <span
                  className={`inline-flex px-3.5 py-1.5 rounded-full border text-[11px] font-semibold tracking-wide uppercase text-[#007AFF] ${
                    isDark
                      ? "border-[#007AFF]/40 bg-[#007AFF]/10"
                      : "border-[#007AFF]/30 bg-[#007AFF]/5"
                  }`}
                >
                  About Us
                </span>
                <h2 className="mt-5 text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tighter leading-[1.1]">
                  Innovative Minds.{" "}
                  <span className="text-[#007AFF]">Intelligent Solutions.</span>
                </h2>
                <p
                  className={`mt-5 text-base sm:text-lg leading-relaxed ${
                    isDark ? "text-slate-300" : "text-slate-600"
                  }`}
                >
                  At LogicLabz, we don&apos;t just write code—we build digital
                  products that empower businesses, simplify operations, and
                  create lasting competitive advantage.
                </p>
                <Link
                  to="/about"
                  className="mt-6 inline-flex items-center gap-2 text-sm font-semibold text-[#007AFF] hover:gap-3 transition-all"
                >
                  Know More About Us <ArrowRight className="w-4 h-4" />
                </Link>
              </motion.div>

              <motion.div
                {...fadeUp}
                transition={{ ...fadeUp.transition, delay: 0.1 }}
                className="relative rounded-2xl overflow-hidden aspect-[4/3]"
              >
                <img
                  src={OFFICE_IMG}
                  alt="Modern LogicLabz workspace in Kottayam"
                  className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-tr from-[#007AFF]/20 via-transparent to-transparent" />
              </motion.div>
            </div>
          </div>
        </div>
      </section>

      {/* ─── PROCESS ─── */}
      <section
        className="relative py-20 sm:py-28"
        data-testid="process-section"
      >
        <div className="max-w-7xl mx-auto px-6 sm:px-10">
          <motion.div {...fadeUp} className="text-center max-w-2xl mx-auto">
            <span className="text-xs uppercase tracking-[0.25em] text-[#007AFF] font-semibold">
              The LogicLabz Process
            </span>
            <h2 className="mt-3 text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tighter">
              How great software{" "}
              <span className="text-[#007AFF]">gets shipped.</span>
            </h2>
          </motion.div>

          <div className="mt-14 flex flex-col md:flex-row items-stretch gap-4 md:gap-3">
            {PROCESS.map((step, i) => (
              <div key={step.id} className="contents md:contents">
                <motion.div
                  initial={{ opacity: 0, y: 24 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.5, delay: i * 0.1 }}
                  data-testid={`process-step-${step.id}`}
                  className={`flex-1 rounded-2xl border p-6 ${
                    isDark
                      ? "border-white/10 bg-[#0a1628]/70"
                      : "border-[#007AFF]/15 bg-white shadow-sm"
                  }`}
                >
                  <div className="w-12 h-12 rounded-full bg-[#007AFF]/15 grid place-items-center">
                    <step.icon className="w-5 h-5 text-[#007AFF]" />
                  </div>
                  <div className="mt-5 text-xs font-semibold uppercase tracking-widest text-[#007AFF]">
                    Step 0{step.id}:
                  </div>
                  <h3 className="mt-1.5 text-lg font-bold tracking-tight">
                    {step.label}
                  </h3>
                  <div className="mt-3 w-8 h-0.5 bg-[#007AFF] rounded-full" />
                  <p
                    className={`mt-3 text-sm leading-relaxed ${
                      isDark ? "text-slate-400" : "text-slate-600"
                    }`}
                  >
                    {step.desc}
                  </p>
                </motion.div>
                {i < PROCESS.length - 1 && (
                  <div className="hidden md:flex items-center shrink-0 text-slate-400">
                    <ArrowRight className="w-5 h-5" />
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ─── CTA ─── */}
      <section className="relative pb-24">
        <div className="max-w-5xl mx-auto px-6 sm:px-10">
          <motion.div
            {...fadeUp}
            className={`relative overflow-hidden rounded-3xl p-10 sm:p-16 border ${
              isDark
                ? "border-white/10 bg-gradient-to-br from-[#007AFF]/15 via-[#0a1628]/60 to-transparent"
                : "border-black/8 bg-gradient-to-br from-[#007AFF]/8 via-white to-slate-50"
            }`}
            data-testid="home-cta-section"
          >
            <div className="absolute -top-20 -right-20 w-80 h-80 bg-[#007AFF]/20 blur-3xl rounded-full" />
            <div className="relative">
              <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tighter max-w-2xl">
                Have an idea worth engineering well?
              </h2>
              <p
                className={`mt-5 text-lg max-w-xl ${
                  isDark ? "text-slate-300" : "text-slate-600"
                }`}
              >
                Book a focused technical consult. We&apos;ll sketch the
                architecture, identify risks, and outline a clear path forward.
              </p>
              <Link
                to="/contact"
                data-testid="home-bottom-cta"
                className="mt-8 inline-flex items-center gap-2 px-7 py-4 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white font-semibold brand-glow transition-all"
              >
                Get in Touch <ArrowUpRight className="w-4 h-4" />
              </Link>
            </div>
          </motion.div>
        </div>
      </section>
    </div>
  );
};

export default Home;
