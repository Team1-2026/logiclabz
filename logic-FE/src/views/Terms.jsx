import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import { FileText, ShieldAlert, Key, CreditCard, Calendar, Gavel, ArrowUpRight } from "lucide-react";
import { useTheme } from "@/context/ThemeContext";

const fadeUp = {
  initial: { opacity: 0, y: 20 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-60px" },
  transition: { duration: 0.55 },
};

const Terms = () => {
  const { theme } = useTheme();

  const sections = [
    {
      icon: FileText,
      title: "1. Agreement to Terms",
      content: "By accessing our website or engaging LogicLabz for custom software engineering, ERP installation, or web/mobile development, you agree to be bound by these Terms and Conditions. If you do not agree, you must cease use of our assets and services immediately.",
    },
    {
      icon: Key,
      title: "2. Intellectual Property Rights",
      content: "All source code, designs, documentation, and database schemas created by LogicLabz remain our intellectual property until all contractually agreed milestones and invoices are paid in full. Upon final payment, full ownership and licensing of the customized deliverables transition completely to the client.",
    },
    {
      icon: CreditCard,
      title: "3. Billing, Fees & Milestones",
      content: "Project work is executed in structured sprints based on custom proposals. Invoices are dispatched upon the completion of agreed milestones and are payable within 14 calendar days. Late payments may result in a temporary suspension of development sprints or deployment operations.",
    },
    {
      icon: Calendar,
      title: "4. Support & Maintenance SLA",
      content: "LogicLabz provides a complimentary 30-day post-launch warranty cover for critical bugs and deployment fixes. Ongoing support, maintenance SLAs, and cloud infrastructure management are governed by independent Service Level Agreements tailored to each client.",
    },
    {
      icon: ShieldAlert,
      title: "5. Limitation of Liability",
      content: "To the maximum extent permitted by applicable law, LogicLabz shall not be liable for any indirect, incidental, or consequential damages (including loss of profits, data, or business interruption) arising from the use or inability to use our custom platforms or custom software.",
    },
    {
      icon: Gavel,
      title: "6. Governing Law & Jurisdiction",
      content: "These Terms & Conditions are governed by and construed in accordance with the laws of India. Any legal actions or proceedings arising out of these terms shall be subject to the exclusive jurisdiction of the courts of Kottayam, Kerala, India.",
    },
  ];

  const isDark = theme === "dark";

  return (
    <div data-testid="terms-page" className="pt-28 pb-24">
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
            Legal Agreement
          </span>
          <h1 className="mt-5 text-4xl sm:text-5xl font-bold tracking-tighter">
            Terms & <span className="text-[#007AFF]">Conditions</span>
          </h1>
          <p className={`mt-4 text-sm ${isDark ? "text-slate-400" : "text-slate-600"}`}>
            Last updated: May 2026 · Standard terms of engagement for clients and users of LogicLabz.
          </p>
        </motion.div>

        <div className="space-y-5">
          {sections.map((sec, i) => (
            <motion.div
              key={i}
              {...fadeUp}
              transition={{ ...fadeUp.transition, delay: i * 0.05 }}
              data-testid={`terms-section-${i}`}
              className={`rounded-3xl p-7 sm:p-8 border ${
                isDark
                  ? "border-white/10 bg-[#0a1628]/70"
                  : "border-black/8 bg-white shadow-sm"
              } hover:border-[#007AFF]/40 transition-all`}
            >
              <div className="flex gap-4 items-start">
                <div className="shrink-0 w-11 h-11 rounded-full bg-[#007AFF]/15 grid place-items-center mt-0.5">
                  <sec.icon className="w-5 h-5 text-[#007AFF]" />
                </div>
                <div>
                  <h3 className="text-lg font-bold tracking-tight">{sec.title}</h3>
                  <div className="mt-2 w-8 h-0.5 bg-[#007AFF] rounded-full" />
                  <p className={`mt-3 text-sm leading-relaxed ${isDark ? "text-slate-300" : "text-slate-600"}`}>
                    {sec.content}
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
            Have any questions about our legal agreements?
          </h4>
          <p className={`text-xs mt-2 ${isDark ? "text-slate-400" : "text-slate-600"}`}>
            We value transparency. Feel free to contact our legal operations team.
          </p>
          <div className="mt-5 flex justify-center gap-3">
            <Link
              to="/contact"
              className="inline-flex items-center gap-1.5 text-sm font-semibold text-[#007AFF] hover:gap-2.5 transition-all"
            >
              Write to us <ArrowUpRight className="w-4 h-4" />
            </Link>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default Terms;
