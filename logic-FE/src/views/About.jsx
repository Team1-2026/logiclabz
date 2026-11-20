import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import {
  ArrowRight,
  Compass,
  Users,
  Target,
  Heart,
  CheckCircle2,
  Terminal,
  Code2,
} from "lucide-react";
import { useTheme } from "@/context/ThemeContext";

const fadeUp = {
  initial: { opacity: 0, y: 20 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-60px" },
  transition: { duration: 0.55 },
};

const OFFICE_IMG =
  "https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1200&q=80";

const values = [
  {
    icon: Compass,
    title: "Architecture-first",
    desc: "We design before we code. Every line of code is a tax on the future.",
  },
  {
    icon: Target,
    title: "Outcomes > tickets",
    desc: "We measure success by metrics moved, not stories closed.",
  },
  {
    icon: Users,
    title: "Embedded partners",
    desc: "We integrate into your team — async standups, transparent boards, no theatrics.",
  },
  {
    icon: Heart,
    title: "Craft as a habit",
    desc: "Type-safety, tests, observability — applied as defaults, not afterthoughts.",
  },
];

const About = () => {
  const { theme } = useTheme();
  const isDark = theme === "dark";

  return (
    <div data-testid="about-page" className="pt-28 pb-24">
      {/* Hero — matches home About teaser */}
      <section className="relative overflow-hidden pb-8">
        <div
          className={`absolute inset-0 ${
            isDark ? "hero-mesh opacity-50" : "hero-mesh-light"
          }`}
        />
        <div className="relative max-w-7xl mx-auto px-6 sm:px-10">
          <div
            className={`rounded-[1.75rem] p-8 sm:p-12 lg:p-14 ${
              isDark
                ? "bg-[#0a1628]/60 border border-white/5"
                : "bg-[#f1f5f9] border border-black/5"
            }`}
          >
            <div className="grid lg:grid-cols-2 gap-10 lg:gap-14 items-center">
              <motion.div
                initial={{ opacity: 0, y: 14 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5 }}
              >
                <span
                  className={`inline-flex px-3.5 py-1.5 rounded-full border text-[11px] font-semibold tracking-wide uppercase text-[#007AFF] ${
                    isDark
                      ? "border-[#007AFF]/40 bg-[#007AFF]/10"
                      : "border-[#007AFF]/30 bg-[#007AFF]/5"
                  }`}
                >
                  About Us
                </span>
                <h1 className="mt-5 text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tighter leading-[1.08]">
                  Innovative Minds.{" "}
                  <span className="text-[#007AFF]">Intelligent Solutions.</span>
                </h1>
                <p
                  className={`mt-5 text-base sm:text-lg leading-relaxed ${
                    isDark ? "text-slate-300" : "text-slate-600"
                  }`}
                >
                  At LogicLabz, we don&apos;t just write code—we build digital
                  products that empower businesses, simplify operations, and
                  create lasting competitive advantage. 16+ years. 500+
                  projects. Based in Kottayam, Kerala.
                </p>
              </motion.div>

              <motion.div
                initial={{ opacity: 0, scale: 0.97 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ duration: 0.6, delay: 0.1 }}
                className="relative rounded-2xl overflow-hidden aspect-[4/3]"
              >
                <img
                  src={OFFICE_IMG}
                  alt="LogicLabz workspace in Kottayam"
                  className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-tr from-[#007AFF]/20 via-transparent to-transparent" />
              </motion.div>
            </div>
          </div>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-6 sm:px-10">
        {/* Story + stats */}
        <div className="mt-16 grid lg:grid-cols-12 gap-10">
          <motion.div {...fadeUp} className="lg:col-span-7 space-y-5">
            <h2 className="text-3xl sm:text-4xl font-bold tracking-tighter">
              A studio built around one belief.
            </h2>
            <p className={isDark ? "text-slate-300" : "text-slate-600"}>
              That software should be simple to operate, joyful to extend and
              ruthless about the fundamentals. We started LogicLabz because we
              kept seeing the same pattern: ambitious products held back by
              accidental complexity.
            </p>
            <p className={isDark ? "text-slate-300" : "text-slate-600"}>
              We pair Laravel&apos;s productivity with React&apos;s
              expressiveness, anchor everything in Docker, and ship in sprints
              that respect both engineering and the business clock.
            </p>
          </motion.div>

          <motion.div {...fadeUp} className="lg:col-span-5">
            <div
              className={`rounded-3xl border p-8 ${
                isDark
                  ? "border-white/10 bg-[#0a1628]/70"
                  : "border-black/8 bg-white shadow-sm"
              }`}
            >
              <div className="grid grid-cols-2 gap-6">
                {[
                  { k: "Founded", v: "2010" },
                  { k: "Engineers", v: "32" },
                  { k: "Projects", v: "500+" },
                  { k: "Clients", v: "150+" },
                ].map((s, i) => (
                  <div key={i} data-testid={`about-stat-${i}`}>
                    <div className="text-4xl font-bold tracking-tight text-[#007AFF]">
                      {s.v}
                    </div>
                    <div
                      className={`text-xs uppercase tracking-widest mt-2 ${
                        isDark ? "text-slate-400" : "text-slate-500"
                      }`}
                    >
                      {s.k}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </motion.div>
        </div>

        {/* Expertise grid */}
        <div className="mt-20 grid lg:grid-cols-12 gap-5">
          <motion.div
            {...fadeUp}
            className={`lg:col-span-12 rounded-3xl border p-8 sm:p-10 relative overflow-hidden ${
              isDark
                ? "border-white/10 bg-gradient-to-br from-[#007AFF]/15 via-[#0a1628]/40 to-transparent"
                : "border-black/8 bg-gradient-to-br from-[#007AFF]/8 via-slate-50 to-white"
            }`}
          >
            <div className="absolute -right-10 -top-10 w-48 h-48 bg-[#007AFF]/10 rounded-full blur-2xl" />
            <div className="relative flex flex-col md:flex-row md:items-center gap-6 justify-between">
              <div className="max-w-2xl">
                <span className="text-xs uppercase tracking-widest text-[#007AFF] font-semibold flex items-center gap-1.5 mb-3">
                  <Terminal className="w-4 h-4" /> Core Competency
                </span>
                <h3 className="text-3xl font-bold tracking-tight">
                  Our PHP & Laravel Expertise
                </h3>
                <p
                  className={`mt-4 text-base leading-relaxed ${
                    isDark ? "text-slate-300" : "text-slate-600"
                  }`}
                >
                  Laravel is at the core of our backend services. We build
                  custom CMS, enterprise platforms, RESTful APIs, and SaaS
                  products with performance, security, and scalability as
                  defaults.
                </p>
              </div>
              <div
                className={`shrink-0 p-5 rounded-2xl border font-mono text-[11px] ${
                  isDark
                    ? "border-white/10 bg-black/40 text-slate-300"
                    : "border-black/10 bg-white text-slate-700"
                }`}
              >
                <span className="text-[#007AFF]">const</span> tech ={" "}
                <span className="text-[#F9C80E]">&apos;Laravel&apos;</span>;
                <br />
                <span className="text-[#007AFF]">const</span> core ={" "}
                <span className="text-[#007AFF]">true</span>;
                <br />
                <span className="text-[#007AFF]">if</span> (core){" "}
                <span className="text-emerald-500">deliverScale()</span>;
              </div>
            </div>
          </motion.div>

          <motion.div
            {...fadeUp}
            transition={{ ...fadeUp.transition, delay: 0.05 }}
            className={`lg:col-span-7 rounded-3xl border p-8 ${
              isDark
                ? "border-white/10 bg-[#0a1628]/70"
                : "border-black/8 bg-white shadow-sm"
            }`}
          >
            <h3 className="text-2xl font-bold tracking-tight flex items-center gap-2 mb-6">
              <Code2 className="w-5 h-5 text-[#007AFF]" /> Technologies We Work
              With
            </h3>
            <div className="space-y-4">
              {[
                { cat: "Backend", tech: ["Laravel (PHP)", "Node.js"] },
                {
                  cat: "Frontend",
                  tech: ["React.js", "AngularJS", "Next.js", "Flutter"],
                },
                { cat: "Mobile", tech: ["Flutter", "React Native"] },
                { cat: "CMS & eCommerce", tech: ["WordPress"] },
                {
                  cat: "AI & Data",
                  tech: ["Python", "TensorFlow", "OpenAI APIs"],
                },
              ].map((item, idx) => (
                <div
                  key={idx}
                  className={`flex flex-col sm:flex-row sm:items-center justify-between gap-2 py-3 border-b last:border-0 ${
                    isDark ? "border-white/5" : "border-black/5"
                  }`}
                >
                  <span
                    className={`text-sm font-semibold tracking-wide ${
                      isDark ? "text-slate-300" : "text-slate-700"
                    }`}
                  >
                    {item.cat}
                  </span>
                  <div className="flex flex-wrap gap-1.5">
                    {item.tech.map((t) => (
                      <span
                        key={t}
                        className={`text-xs px-2.5 py-1 rounded-full border ${
                          isDark
                            ? "border-white/10 bg-white/5 text-slate-300"
                            : "border-black/10 bg-black/5 text-slate-700"
                        }`}
                      >
                        {t}
                      </span>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </motion.div>

          <motion.div
            {...fadeUp}
            transition={{ ...fadeUp.transition, delay: 0.1 }}
            className={`lg:col-span-5 rounded-3xl border p-8 ${
              isDark
                ? "border-white/10 bg-[#0a1628]/70"
                : "border-black/8 bg-white shadow-sm"
            }`}
          >
            <h3 className="text-2xl font-bold tracking-tight flex items-center gap-2 mb-6">
              <CheckCircle2 className="w-5 h-5 text-[#007AFF]" /> Why Work With
              LogicLabz
            </h3>
            <ul className="space-y-4">
              {[
                {
                  title: "Proven results & satisfied clients",
                  desc: "500+ successful projects globally",
                },
                {
                  title: "Agile development & clear communication",
                  desc: "Bi-weekly sprint demos and direct access",
                },
                {
                  title: "Long-term support & post-launch care",
                  desc: "We maintain and scale what we build",
                },
                {
                  title: "Reliable, on-time, and quality-driven",
                  desc: "Rigorous testing and on-time delivery",
                },
              ].map((item, idx) => (
                <li key={idx} className="flex gap-3 items-start">
                  <div className="shrink-0 w-5 h-5 rounded-full bg-emerald-500/10 grid place-items-center mt-0.5">
                    <CheckCircle2 className="w-3.5 h-3.5 text-emerald-500" />
                  </div>
                  <div>
                    <h4 className="text-sm font-bold tracking-tight">
                      {item.title}
                    </h4>
                    <p
                      className={`text-xs mt-1 ${
                        isDark ? "text-slate-400" : "text-slate-500"
                      }`}
                    >
                      {item.desc}
                    </p>
                  </div>
                </li>
              ))}
            </ul>
          </motion.div>
        </div>

        {/* Values */}
        <div className="mt-20">
          <motion.div {...fadeUp} className="text-center max-w-2xl mx-auto">
            <span className="text-xs uppercase tracking-[0.25em] text-[#007AFF] font-semibold">
              Our Values
            </span>
            <h2 className="mt-3 text-3xl sm:text-4xl font-bold tracking-tighter">
              What we operate by.
            </h2>
          </motion.div>
          <div className="mt-10 grid sm:grid-cols-2 lg:grid-cols-4 gap-5">
            {values.map((v, i) => (
              <motion.div
                key={v.title}
                {...fadeUp}
                transition={{ ...fadeUp.transition, delay: i * 0.06 }}
                data-testid={`about-value-${i}`}
                className={`rounded-3xl p-7 border ${
                  isDark
                    ? "border-white/10 bg-[#0a1628]/70"
                    : "border-black/8 bg-white shadow-sm"
                } hover:border-[#007AFF]/50 transition-all`}
              >
                <div className="w-11 h-11 rounded-full bg-[#007AFF]/15 grid place-items-center mb-5">
                  <v.icon className="w-5 h-5 text-[#007AFF]" />
                </div>
                <h3 className="text-lg font-bold tracking-tight">{v.title}</h3>
                <div className="mt-3 w-8 h-0.5 bg-[#007AFF] rounded-full" />
                <p
                  className={`mt-3 text-sm ${
                    isDark ? "text-slate-400" : "text-slate-600"
                  }`}
                >
                  {v.desc}
                </p>
              </motion.div>
            ))}
          </div>
        </div>

        {/* Comparison */}
        <div className="mt-20">
          <motion.h2
            {...fadeUp}
            className="text-3xl sm:text-4xl font-bold tracking-tighter"
          >
            Why teams move to LogicLabz.
          </motion.h2>
          <motion.div
            {...fadeUp}
            className={`mt-8 overflow-hidden rounded-3xl border ${
              isDark ? "border-white/10" : "border-black/8 shadow-sm"
            }`}
          >
            <table
              className="w-full text-left text-sm"
              data-testid="comparison-table"
            >
              <thead className={isDark ? "bg-[#0a1628]/80" : "bg-slate-100"}>
                <tr>
                  <th className="px-6 py-4 text-xs uppercase tracking-widest text-[#007AFF]">
                    Aspect
                  </th>
                  <th
                    className={`px-6 py-4 text-xs uppercase tracking-widest ${
                      isDark ? "text-slate-400" : "text-slate-500"
                    }`}
                  >
                    Traditional vendor
                  </th>
                  <th className="px-6 py-4 text-xs uppercase tracking-widest text-[#007AFF]">
                    LogicLabz
                  </th>
                </tr>
              </thead>
              <tbody>
                {[
                  [
                    "Style",
                    "Classic white/boxed CMS feel",
                    "Modern dark/fluid headless",
                  ],
                  [
                    "Layout",
                    "Standard vertical stack",
                    "Interactive bento grids",
                  ],
                  [
                    "Visuals",
                    "Stock photography",
                    "3D renders & custom mockups",
                  ],
                  [
                    "Performance",
                    "Traditional CMS load times",
                    "Ultra-fast headless architecture",
                  ],
                  [
                    "Navigation",
                    "Plain text links",
                    "Icons + micro-interactions",
                  ],
                ].map((row, i) => (
                  <tr
                    key={i}
                    className={`border-t ${
                      isDark ? "border-white/5" : "border-black/5"
                    }`}
                  >
                    <td className="px-6 py-4 font-medium">{row[0]}</td>
                    <td
                      className={`px-6 py-4 ${
                        isDark ? "text-slate-400" : "text-slate-600"
                      }`}
                    >
                      {row[1]}
                    </td>
                    <td className="px-6 py-4 text-[#007AFF] font-medium">
                      {row[2]}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </motion.div>
        </div>

        <motion.div
          {...fadeUp}
          className={`mt-20 relative overflow-hidden rounded-3xl p-10 sm:p-14 border ${
            isDark
              ? "border-white/10 bg-gradient-to-br from-[#007AFF]/15 via-[#0a1628]/60 to-transparent"
              : "border-black/8 bg-gradient-to-br from-[#007AFF]/8 via-white to-slate-50"
          }`}
        >
          <h2 className="text-3xl sm:text-4xl font-bold tracking-tighter max-w-xl">
            Ready to engineer for the long game?
          </h2>
          <Link
            to="/contact"
            data-testid="about-cta"
            className="mt-8 inline-flex items-center gap-2 px-7 py-4 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white font-semibold brand-glow transition-all"
          >
            Get in Touch <ArrowRight className="w-4 h-4" />
          </Link>
        </motion.div>
      </div>
    </div>
  );
};

export default About;
