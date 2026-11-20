import { useState } from "react";
import { motion } from "framer-motion";
import { Mail, Phone, MapPin, ArrowRight, ArrowUpRight, CheckCircle2 } from "lucide-react";
import { useTheme } from "@/context/ThemeContext";
import { Toaster, toast } from "sonner";

const fadeUp = {
  initial: { opacity: 0, y: 20 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-60px" },
  transition: { duration: 0.55 },
};

const SCOPE_OPTIONS = [
  "Enterprise Web",
  "Mobile App",
  "ERP / Modules",
  "AI Integration",
  "Team Augmentation",
  "Other",
];

const Contact = () => {
  const { theme } = useTheme();
  const isDark = theme === "dark";
  const [submitted, setSubmitted] = useState(false);
  const [form, setForm] = useState({
    name: "",
    email: "",
    company: "",
    scope: SCOPE_OPTIONS[0],
    message: "",
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!form.name || !form.email || !form.message) {
      toast.error("Please fill in name, email and message.");
      return;
    }
    setSubmitted(true);
    toast.success("Thanks — we'll be in touch within one business day.");
  };

  const inputCls = `w-full rounded-xl border px-4 py-3 text-base outline-none transition-colors ${
    isDark
      ? "border-white/10 bg-white/5 focus:border-[#007AFF] placeholder:text-slate-500 text-slate-100"
      : "border-black/10 bg-white focus:border-[#007AFF] placeholder:text-slate-400 text-slate-900"
  }`;

  return (
    <div data-testid="contact-page" className="pt-28 pb-24">
      <Toaster
        position="top-right"
        theme={isDark ? "dark" : "light"}
      />

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
              Talk to Us
            </span>
            <h1 className="mt-5 text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tighter leading-[1.08]">
              Tell us about your{" "}
              <span className="text-[#007AFF]">build.</span>
            </h1>
            <p
              className={`mt-6 text-lg leading-relaxed ${
                isDark ? "text-slate-300" : "text-slate-600"
              }`}
            >
              Drop us a brief — we&apos;ll respond within one business day with
              a 30-minute technical consult booked in.
            </p>
          </motion.div>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-6 sm:px-10">
        <div className="grid lg:grid-cols-12 gap-8">
          <motion.div {...fadeUp} className="lg:col-span-7">
            <div
              className={`rounded-3xl border p-8 sm:p-10 ${
                isDark
                  ? "border-white/10 bg-[#0a1628]/70"
                  : "border-black/8 bg-white shadow-sm"
              }`}
            >
              {submitted ? (
                <div className="text-center py-16" data-testid="contact-success">
                  <div className="w-16 h-16 mx-auto rounded-full bg-[#007AFF]/15 grid place-items-center">
                    <CheckCircle2 className="w-8 h-8 text-[#007AFF]" />
                  </div>
                  <h3 className="mt-6 text-3xl font-bold tracking-tighter">
                    Message received.
                  </h3>
                  <p
                    className={`mt-3 max-w-md mx-auto ${
                      isDark ? "text-slate-300" : "text-slate-600"
                    }`}
                  >
                    Thanks {form.name || "there"} — we&apos;ll get back to you
                    at{" "}
                    <span className="text-[#007AFF]">{form.email}</span> within
                    one business day.
                  </p>
                  <button
                    onClick={() => {
                      setSubmitted(false);
                      setForm({
                        name: "",
                        email: "",
                        company: "",
                        scope: SCOPE_OPTIONS[0],
                        message: "",
                      });
                    }}
                    data-testid="contact-reset-btn"
                    className="mt-8 inline-flex items-center gap-2 text-sm font-semibold text-[#007AFF] hover:gap-3 transition-all"
                  >
                    Send another <ArrowUpRight className="w-4 h-4" />
                  </button>
                </div>
              ) : (
                <form
                  onSubmit={handleSubmit}
                  data-testid="contact-form"
                  className="space-y-5"
                >
                  <div className="grid sm:grid-cols-2 gap-5">
                    <div>
                      <label
                        className={`text-xs uppercase tracking-widest font-semibold ${
                          isDark ? "text-slate-400" : "text-slate-500"
                        }`}
                      >
                        Full name
                      </label>
                      <input
                        type="text"
                        value={form.name}
                        onChange={(e) =>
                          setForm({ ...form, name: e.target.value })
                        }
                        placeholder="Ada Lovelace"
                        className={`${inputCls} mt-2`}
                        data-testid="contact-input-name"
                      />
                    </div>
                    <div>
                      <label
                        className={`text-xs uppercase tracking-widest font-semibold ${
                          isDark ? "text-slate-400" : "text-slate-500"
                        }`}
                      >
                        Work email
                      </label>
                      <input
                        type="email"
                        value={form.email}
                        onChange={(e) =>
                          setForm({ ...form, email: e.target.value })
                        }
                        placeholder="ada@company.com"
                        className={`${inputCls} mt-2`}
                        data-testid="contact-input-email"
                      />
                    </div>
                  </div>

                  <div className="grid sm:grid-cols-2 gap-5">
                    <div>
                      <label
                        className={`text-xs uppercase tracking-widest font-semibold ${
                          isDark ? "text-slate-400" : "text-slate-500"
                        }`}
                      >
                        Company
                      </label>
                      <input
                        type="text"
                        value={form.company}
                        onChange={(e) =>
                          setForm({ ...form, company: e.target.value })
                        }
                        placeholder="Babbage Industries"
                        className={`${inputCls} mt-2`}
                        data-testid="contact-input-company"
                      />
                    </div>
                    <div>
                      <label
                        className={`text-xs uppercase tracking-widest font-semibold ${
                          isDark ? "text-slate-400" : "text-slate-500"
                        }`}
                      >
                        Scope
                      </label>
                      <select
                        value={form.scope}
                        onChange={(e) =>
                          setForm({ ...form, scope: e.target.value })
                        }
                        className={`${inputCls} mt-2 ${
                          isDark ? "bg-[#0a1628]" : "bg-white"
                        }`}
                        data-testid="contact-input-scope"
                      >
                        {SCOPE_OPTIONS.map((o) => (
                          <option key={o} value={o}>
                            {o}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  <div>
                    <label
                      className={`text-xs uppercase tracking-widest font-semibold ${
                        isDark ? "text-slate-400" : "text-slate-500"
                      }`}
                    >
                      Tell us about the build
                    </label>
                    <textarea
                      rows={5}
                      value={form.message}
                      onChange={(e) =>
                        setForm({ ...form, message: e.target.value })
                      }
                      placeholder="A few sentences about your product, stage and goals…"
                      className={`${inputCls} mt-2 resize-none`}
                      data-testid="contact-input-message"
                    />
                  </div>

                  <button
                    type="submit"
                    data-testid="contact-submit-btn"
                    className="inline-flex items-center gap-2 px-7 py-4 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white font-semibold brand-glow transition-all"
                  >
                    Send brief <ArrowRight className="w-4 h-4" />
                  </button>
                </form>
              )}
            </div>
          </motion.div>

          <motion.div {...fadeUp} className="lg:col-span-5 space-y-4">
            {[
              {
                icon: Mail,
                title: "Email",
                value: "hello@logiclabz.co.in",
                href: "mailto:hello@logiclabz.co.in",
              },
              { icon: Phone, title: "Phone", value: "+91 9061033764" },
              {
                icon: MapPin,
                title: "Location",
                value: "Kottayam, Kerala, India",
              },
            ].map((c, i) => (
              <div
                key={i}
                data-testid={`contact-info-${i}`}
                className={`rounded-2xl border p-6 flex items-start gap-4 ${
                  isDark
                    ? "border-white/10 bg-[#0a1628]/70"
                    : "border-black/8 bg-white shadow-sm"
                }`}
              >
                <div className="w-11 h-11 rounded-full bg-[#007AFF]/15 grid place-items-center shrink-0">
                  <c.icon className="w-5 h-5 text-[#007AFF]" />
                </div>
                <div>
                  <div
                    className={`text-xs uppercase tracking-widest ${
                      isDark ? "text-slate-500" : "text-slate-500"
                    }`}
                  >
                    {c.title}
                  </div>
                  {c.href ? (
                    <a
                      href={c.href}
                      className="mt-1 block text-base font-medium hover:text-[#007AFF]"
                    >
                      {c.value}
                    </a>
                  ) : (
                    <p className="mt-1 text-base font-medium">{c.value}</p>
                  )}
                </div>
              </div>
            ))}

            <div
              className={`rounded-2xl border p-6 ${
                isDark
                  ? "border-[#007AFF]/30 bg-gradient-to-br from-[#007AFF]/15 to-transparent"
                  : "border-[#007AFF]/30 bg-gradient-to-br from-[#007AFF]/10 to-white"
              }`}
            >
              <div className="text-xs uppercase tracking-widest text-[#007AFF] font-semibold">
                Response time
              </div>
              <p className="mt-2 font-medium">Within 1 business day.</p>
              <p
                className={`mt-1 text-sm ${
                  isDark ? "text-slate-400" : "text-slate-600"
                }`}
              >
                We respond personally, no bots. Briefs become a free 30-min
                consult.
              </p>
            </div>
          </motion.div>
        </div>
      </div>
    </div>
  );
};

export default Contact;
