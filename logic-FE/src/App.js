import "@/styles/App.css";
import { BrowserRouter, Routes, Route, useLocation } from "react-router-dom";
import { useEffect } from "react";
import { ThemeProvider } from "@/context/ThemeContext";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import Seo from "@/components/Seo";
import Home from "@/views/Home";
import Services from "@/views/Services";
import Products from "@/views/Products";
import Certifications from "@/views/Certifications";
import CertificationDetail from "@/views/CertificationDetail";
import Portfolio from "@/views/Portfolio";
import About from "@/views/About";
import Contact from "@/views/Contact";
import TopLevelTeam from "@/views/TopLevelTeam";
import Terms from "@/views/Terms";
import Privacy from "@/views/Privacy";

const ScrollToTop = () => {
  const { pathname } = useLocation();
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: "instant" });
  }, [pathname]);
  return null;
};

function App() {
  return (
    <ThemeProvider>
      <div className="App relative min-h-screen bg-background text-foreground">
        <BrowserRouter>
          <Seo />
          <ScrollToTop />
          <Navbar />
          <main>
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/services" element={<Services />} />
              <Route path="/products" element={<Products />} />
              <Route path="/certifications" element={<Certifications />} />
              <Route path="/certifications/:slug" element={<CertificationDetail />} />
              <Route path="/portfolio" element={<Portfolio />} />
              <Route path="/about" element={<About />} />
              <Route path="/top-level-team" element={<TopLevelTeam />} />
              <Route path="/marketing-team" element={<TopLevelTeam />} />
              <Route path="/contact" element={<Contact />} />
              <Route path="/terms" element={<Terms />} />
              <Route path="/privacy" element={<Privacy />} />
              <Route path="*" element={<Home />} />
            </Routes>
          </main>
          <Footer />
        </BrowserRouter>
      </div>
    </ThemeProvider>
  );
}

export default App;