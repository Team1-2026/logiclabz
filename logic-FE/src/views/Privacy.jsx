import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import { ShieldCheck, Eye, Settings, Lock, UserCheck, Cookie, ArrowUpRight } from "lucide-react";
import { useTheme } from "@/context/ThemeContext";

const fadeUp = {
  initial: { opacity: 0, y: 20 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-60px" },
  transition: { duration: 0.55 },
};

const Privacy = () => {
  const { theme } = useTheme();

  const rules = [
    {
      icon: Eye,
      title: "1. Information Collection",
      content: "We collect personal identifiers such as your name, corporate email address, and phone number when you request a technical consultation, along with technical usage logs (IP addresses, user agents, and routing details) generated during your site visits.",
    },
    {
      icon: Settings,
      title: "2. How We Use Data",
      content: "Your data is strictly utilized to prepare custom ERP engineering proposals, deliver software consultation findings, optimize page load metrics, respond to communication requests, and fulfill SLA support tasks.",
    },
    {
      icon: Lock,
      title: "3. Data Security & Storage",
      content: "LogicLabz stores data on isolated, encrypted database systems protected by strict firewall layers. We strictly enforce SOC2-compliant protocols and encrypt all transit payloads. We never sell, lease, or distribute customer details to third parties.",
    },
    {
      icon: Cookie,
      title: "4. Cookies & Trackers",
      content: "We utilize standard cookies to manage user active session states and evaluate page engagement using anonymized analytics utilities. You can modify your browser settings to reject cookies if preferred.",
    },
    {
      icon: UserCheck,
      title: "5. Your Control & Access",
      content: "You retain full rights to request access to your collected personal records, demand corrective updates, or request complete erasure of your data from our active storage databases. Reach out to hello@logiclabz.co.in to execute these rights.",
    },
    {
      icon: ShieldCheck,
      title: "6. Data Compliance Standards",
      content: "Our operational standards align with the Information Technology Act of India and follow international data privacy standards (such as GDPR baselines), ensuring complete protection for global clients.",
    },
  ];

  const isDark = theme === "dark";

  return (
    <div data-testid="privacy-page" className="pt-28 pb-24">
      <div className="max-w-4xl mx-auto px-6 sm:px-10">
        <motion.div
          initial={{ opacity: 0, y: 14 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="text-center max-w-2xl mx-auto mb-14"
        >
          <span
            className={`inline-flex px-3.5 py-1.5 rounded-full border text-[11px] font-semibold tracking-wide uppercase text-[#007AFF] ${
              isDark
                ? "border-[#007AFF]/40 bg-[#007AFF]/10"
                : "border-[#007AFF]/30 bg-[#007AFF]/5"
            }`}
          >
            Data Protection
          </span>
          <h1 className="mt-5 text-4xl sm:text-5xl font-bold tracking-tighter">
            Privacy <span className="text-[#007AFF]">Policy</span>
          </h1>
          <p className={`mt-4 text-sm ${isDark ? "text-slate-400" : "text-slate-600"}`}>
            Last updated: May 2026 · Discover how we process and secure your corporate information.
          </p>
        </motion.div>

        <div className="space-y-5">
          {rules.map((rule, i) => (
            <motion.div
              key={i}
              {...fadeUp}
              transition={{ ...fadeUp.transition, delay: i * 0.05 }}
              data-testid={`privacy-section-${i}`}
              className={`rounded-3xl p-7 sm:p-8 border ${
                isDark
                  ? "border-white/10 bg-[#0a1628]/70"
                  : "border-black/8 bg-white shadow-sm"
              } hover:border-[#007AFF]/40 transition-all`}
            >
              <div className="flex gap-4 items-start">
                <div className="shrink-0 w-11 h-11 rounded-full bg-[#007AFF]/15 grid place-items-center mt-0.5">
                  <rule.icon className="w-5 h-5 text-[#007AFF]" />
                </div>
                <div>
                  <h3 className="text-lg font-bold tracking-tight">{rule.title}</h3>
                  <div className="mt-2 w-8 h-0.5 bg-[#007AFF] rounded-full" />
                  <p className={`mt-3 text-sm leading-relaxed ${isDark ? "text-slate-300" : "text-slate-600"}`}>
                    {rule.content}
                  </p>
                </div>
              </div>
            </motion.div>
          ))}
        </div>

        <motion.div
          {...fadeUp}
          className={`mt-14 rounded-3xl p-8 border text-center ${
            isDark
              ? "border-white/10 bg-gradient-to-br from-[#007AFF]/10 via-[#0a1628]/50 to-transparent"
              : "border-black/8 bg-gradient-to-br from-[#007AFF]/5 to-white"
          }`}
        >
          <h4 className="text-base font-bold tracking-tight">
            Need assistance regarding privacy settings?
          </h4>
          <p className={`text-xs mt-2 ${isDark ? "text-slate-400" : "text-slate-600"}`}>
            Our Data Privacy Officer is available to resolve any compliance inquiries.
          </p>
          <div className="mt-5 flex justify-center gap-3">
            <Link
              to="/contact"
              className="inline-flex items-center gap-1.5 text-sm font-semibold text-[#007AFF] hover:gap-2.5 transition-all"
            >
              Contact Privacy Officer <ArrowUpRight className="w-4 h-4" />
            </Link>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default Privacy;
