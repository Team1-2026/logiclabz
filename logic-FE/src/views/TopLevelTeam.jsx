import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import {
  ArrowRight,
  Briefcase,
  Cpu,
  Globe2,
  MapPin,
  Megaphone,
  Users,
} from "lucide-react";
import { useTheme } from "@/context/ThemeContext";

const fadeUp = {
  initial: { opacity: 0, y: 22 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-60px" },
  transition: { duration: 0.55 },
};

const TEAM = [
  {
    name: "Jesvin Mathew",
    role: "Chief Technology Officer",
    shortRole: "CTO",
    region: "Global",
    focus: "Architecture · Engineering · Product delivery",
    bio: "Leads technology strategy and engineering excellence across LogicLabz — from ERP platforms to cloud architectures and AI-ready product systems.",
    icon: Cpu,
    accent: "#007AFF",
    accentBg: "bg-[#007AFF]/15",
    initials: "JM",
  },
  {
    name: "Tojo",
    role: "Marketing Head — India",
    shortRole: "Marketing Head",
    region: "India",
    focus: "Brand · Growth · Go-to-market",
    bio: "Owns marketing strategy across India — brand positioning, demand generation, and campaigns that connect LogicLabz with founders and enterprises nationwide.",
    icon: Megaphone,
    accent: "#10b981",
    accentBg: "bg-emerald-500/15",
    initials: "TJ",
  },
  {
    name: "Nikhil",
    role: "Marketing Head — UK & Europe",
    shortRole: "Marketing Head",
    region: "UK & Europe",
    focus: "International markets · Partnerships",
    bio: "Drives marketing and market expansion across the UK and Europe — building presence, partnerships, and pipeline in international markets.",
    icon: Globe2,
    accent: "#a78bfa",
    accentBg: "bg-violet-500/15",
    initials: "NK",
  },
  {
    name: "Soger",
    role: "Business Analyst",
    shortRole: "Business Analyst",
    region: "Operations",
    focus: "Requirements · Process · Delivery clarity",
    bio: "Bridges business goals and engineering delivery — clarifying requirements, mapping processes, and keeping projects aligned to measurable outcomes.",
    icon: Briefcase,
    accent: "#f97316",
    accentBg: "bg-orange-500/15",
    initials: "SG",
  },
];

const TopLevelTeam = () => {
  const { theme } = useTheme();
  const isDark = theme === "dark";

  return (
    <div data-testid="team-page" className="pt-28 pb-24">
      {/* Hero */}
      <section className="relative overflow-hidden pb-14">
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
              className={`inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full border text-[11px] font-semibold tracking-wide uppercase text-[#007AFF] ${
                isDark
                  ? "border-[#007AFF]/40 bg-[#007AFF]/10"
                  : "border-[#007AFF]/30 bg-[#007AFF]/5"
              }`}
            >
              <Users className="w-3.5 h-3.5" />
              Top Level Team
            </span>
            <h1 className="mt-5 text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tighter leading-[1.08]">
              Leadership that{" "}
              <span className="text-[#007AFF]">ships with clarity.</span>
            </h1>
            <p
              className={`mt-6 text-lg leading-relaxed ${
                isDark ? "text-slate-300" : "text-slate-600"
              }`}
            >
              Meet the people steering technology, marketing, and business
              analysis at LogicLabz — aligned across India, the UK, and Europe.
            </p>
          </motion.div>
        </div>
      </section>

      {/* Team grid */}
      <section className="max-w-7xl mx-auto px-6 sm:px-10">
        <div className="grid sm:grid-cols-2 gap-6 lg:gap-7">
          {TEAM.map((member, i) => (
            <motion.article
              key={member.name}
              {...fadeUp}
              transition={{ ...fadeUp.transition, delay: (i % 2) * 0.08 }}
              data-testid={`team-member-${i}`}
              className={`group relative overflow-hidden rounded-3xl border p-7 sm:p-8 transition-all ${
                isDark
                  ? "border-white/10 bg-[#0a1628]/70 hover:border-white/20"
                  : "border-black/8 bg-white shadow-sm hover:shadow-md hover:border-[#007AFF]/25"
              }`}
            >
              {/* Accent glow */}
              <div
                className="absolute -top-16 -right-16 w-40 h-40 rounded-full blur-3xl opacity-40 pointer-events-none transition-opacity group-hover:opacity-70"
                style={{ backgroundColor: member.accent }}
              />

              <div className="relative flex items-start gap-5">
                {/* Avatar */}
                <div
                  className={`shrink-0 w-16 h-16 sm:w-20 sm:h-20 rounded-2xl grid place-items-center text-xl sm:text-2xl font-bold tracking-tight text-white shadow-lg`}
                  style={{
                    background: `linear-gradient(145deg, ${member.accent}, ${member.accent}99)`,
                    boxShadow: `0 12px 28px -10px ${member.accent}88`,
                  }}
                >
                  {member.initials}
                </div>

                <div className="min-w-0 flex-1">
                  <div className="flex flex-wrap items-center gap-2">
                    <span
                      className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-semibold uppercase tracking-wider ${member.accentBg}`}
                      style={{ color: member.accent }}
                    >
                      <member.icon className="w-3 h-3" />
                      {member.shortRole}
                    </span>
                    <span
                      className={`inline-flex items-center gap-1 text-[11px] ${
                        isDark ? "text-slate-400" : "text-slate-500"
                      }`}
                    >
                      <MapPin className="w-3 h-3" />
                      {member.region}
                    </span>
                  </div>

                  <h2 className="mt-3 text-2xl sm:text-3xl font-bold tracking-tight">
                    {member.name}
                  </h2>
                  <p
                    className="mt-1 text-sm font-semibold"
                    style={{ color: member.accent }}
                  >
                    {member.role}
                  </p>
                  <div
                    className="mt-3 w-10 h-0.5 rounded-full"
                    style={{ backgroundColor: member.accent }}
                  />
                  <p
                    className={`mt-4 text-sm leading-relaxed ${
                      isDark ? "text-slate-400" : "text-slate-600"
                    }`}
                  >
                    {member.bio}
                  </p>
                  <p
                    className={`mt-4 text-xs font-medium uppercase tracking-wider ${
                      isDark ? "text-slate-500" : "text-slate-500"
                    }`}
                  >
                    {member.focus}
                  </p>
                </div>
              </div>
            </motion.article>
          ))}
        </div>

        {/* Org strip */}
        <motion.div
          {...fadeUp}
          className={`mt-14 rounded-3xl border overflow-hidden ${
            isDark
              ? "border-white/10 bg-[#071018]"
              : "border-black/8 bg-[#f1f5f9]"
          }`}
        >
          <div className="px-6 sm:px-10 py-8 sm:py-10">
            <p className="text-center text-[11px] font-semibold tracking-[0.25em] uppercase text-[#007AFF] mb-8">
              Leadership Structure
            </p>
            <div className="flex flex-col lg:flex-row items-stretch justify-center gap-4 lg:gap-3">
              {TEAM.map((member, i) => (
                <div key={member.name} className="contents lg:contents">
                  <div
                    className={`flex-1 rounded-2xl border p-5 text-center ${
                      isDark
                        ? "border-white/10 bg-[#0a1628]/80"
                        : "border-black/8 bg-white"
                    }`}
                  >
                    <div
                      className="mx-auto w-12 h-12 rounded-full grid place-items-center text-sm font-bold text-white"
                      style={{ backgroundColor: member.accent }}
                    >
                      {member.initials}
                    </div>
                    <div className="mt-3 text-sm font-bold tracking-tight">
                      {member.name}
                    </div>
                    <div
                      className="mt-1 text-xs font-medium"
                      style={{ color: member.accent }}
                    >
                      {member.role}
                    </div>
                  </div>
                  {i < TEAM.length - 1 && (
                    <div className="hidden lg:flex items-center text-slate-400 shrink-0">
                      <ArrowRight className="w-4 h-4" />
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        </motion.div>

        {/* CTA */}
        <motion.div
          {...fadeUp}
          className={`mt-14 relative overflow-hidden rounded-3xl p-10 sm:p-14 border ${
            isDark
              ? "border-white/10 bg-gradient-to-br from-[#007AFF]/15 via-[#0a1628]/60 to-transparent"
              : "border-black/8 bg-gradient-to-br from-[#007AFF]/8 via-white to-slate-50"
          }`}
        >
          <div className="absolute -top-20 -right-20 w-80 h-80 bg-[#007AFF]/20 blur-3xl rounded-full" />
          <div className="relative flex flex-col md:flex-row md:items-center justify-between gap-8">
            <div className="max-w-xl">
              <h2 className="text-3xl sm:text-4xl font-bold tracking-tighter">
                Want to work with our leadership team?
              </h2>
              <p
                className={`mt-4 ${
                  isDark ? "text-slate-300" : "text-slate-600"
                }`}
              >
                Reach out for a technical consult, marketing partnership, or
                project discovery with LogicLabz.
              </p>
            </div>
            <Link
              to="/contact"
              data-testid="team-cta"
              className="inline-flex items-center gap-2 px-7 py-4 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white font-semibold brand-glow transition-all shrink-0"
            >
              Get in Touch <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        </motion.div>
      </section>
    </div>
  );
};

export default TopLevelTeam;
