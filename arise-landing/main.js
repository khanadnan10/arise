(() => {
  const bgCanvas = document.getElementById("bg-canvas");
  const menuToggle = document.getElementById("menu-toggle");
  const mobileBackdrop = document.getElementById("mobile-menu-backdrop");
  const mobileMenu = document.getElementById("mobile-menu");
  const navLinks = document.querySelectorAll("[data-nav]");

  const sheets = {
    features: document.getElementById("features-backdrop"),
    docs: document.getElementById("docs-backdrop"),
    installation: document.getElementById("install-backdrop"),
  };

  const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  requestAnimationFrame(() => {
    document.body.classList.add("is-ready");
  });

  // Bluish undulating stippled wave + Flutter/ARISE CLI command matrix
  if (bgCanvas) {
    const ctx = bgCanvas.getContext("2d");
    const commandLines = [
      "arise create my_app --arch clean --state riverpod --route go_router   ",
      "flutter pub get && dart run build_runner build --delete-conflicting-outputs   ",
      "arise gen feature auth -t full && flutter test test/features/auth/   ",
      "arise add dio --di get_it --storage shared_preferences --lint very_good_analysis   ",
      "dart pub global activate arise && arise doctor   ",
      "arise info --config .arise.yaml && flutter analyze   ",
    ];
    let width = 0;
    let height = 0;
    let dpr = 1;
    let time = 0;
    let rafId = 0;

    // Pre-generate fine stipple grain tile for the 3D dune texture
    const grainCanvas = document.createElement("canvas");
    grainCanvas.width = 160;
    grainCanvas.height = 160;
    const gCtx = grainCanvas.getContext("2d");
    const gData = gCtx.createImageData(160, 160);
    for (let i = 0; i < gData.data.length; i += 4) {
      const v = Math.random() * 255;
      gData.data[i] = 170;
      gData.data[i + 1] = 210;
      gData.data[i + 2] = 255;
      gData.data[i + 3] = v > 150 ? Math.floor((v - 150) * 0.45) : 0;
    }
    gCtx.putImageData(gData, 0, 0);
    const grainPattern = ctx.createPattern(grainCanvas, "repeat");

    function resize() {
      dpr = Math.min(window.devicePixelRatio || 1, 2);
      width = window.innerWidth;
      height = window.innerHeight;
      bgCanvas.width = Math.floor(width * dpr);
      bgCanvas.height = Math.floor(height * dpr);
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    }

    function backWaveY(x, t) {
      const nx = x / width;
      return (
        height * 0.42 +
        Math.sin(nx * 4.2 + t * 0.45) * (height * 0.085) +
        Math.cos(nx * 2.1 - t * 0.25) * (height * 0.045)
      );
    }

    function frontWaveY(x, t) {
      const nx = x / width;
      return (
        height * 0.64 +
        Math.sin(nx * 3.4 - t * 0.38 + 1.2) * (height * 0.095) +
        Math.cos(nx * 6.0 + t * 0.22) * (height * 0.025)
      );
    }

    function drawWave(yFn, t, rimColor, midColor, rimWidth) {
      ctx.save();
      ctx.beginPath();
      ctx.moveTo(0, height);
      const step = Math.max(8, Math.floor(width / 120));
      for (let x = 0; x <= width + step; x += step) {
        ctx.lineTo(x, yFn(x, t));
      }
      ctx.lineTo(width, height);
      ctx.closePath();

      const grad = ctx.createLinearGradient(0, height * 0.3, 0, height);
      grad.addColorStop(0, rimColor);
      grad.addColorStop(0.32, midColor);
      grad.addColorStop(0.72, "rgba(6, 12, 28, 0.94)");
      grad.addColorStop(1, "#03050A");
      ctx.fillStyle = grad;
      ctx.fill();

      // Stippled grain inside wave slope
      if (grainPattern) {
        ctx.clip();
        ctx.globalAlpha = 0.42;
        ctx.fillStyle = grainPattern;
        ctx.fillRect(0, height * 0.25, width, height * 0.75);
      }
      ctx.restore();

      // Crisp luminous rim highlight along the crest
      ctx.save();
      ctx.beginPath();
      for (let x = 0; x <= width + step; x += step) {
        const y = yFn(x, t);
        if (x === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
      }
      ctx.strokeStyle = rimColor;
      ctx.lineWidth = rimWidth;
      ctx.shadowColor = "rgba(96, 165, 250, 0.85)";
      ctx.shadowBlur = 18;
      ctx.stroke();
      ctx.restore();
    }

    function drawCommandSky(t) {
      const charW = width < 640 ? 9.5 : 8.5;
      const rowH = width < 640 ? 18 : 16;
      const cols = Math.ceil(width / charW);
      const rows = Math.ceil((height * 0.56) / rowH);

      ctx.save();
      ctx.font = `500 ${width < 640 ? 10 : 11}px "JetBrains Mono", monospace`;
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";

      for (let r = 0; r < rows; r++) {
        const y = r * rowH + rowH * 0.5;
        const ny = y / (height * 0.56);
        const line = commandLines[r % commandLines.length];
        const rowShift = Math.floor(t * (r % 2 === 0 ? 1.8 : -1.4)) + r * 11;

        for (let c = 0; c < cols; c++) {
          const x = c * charW + charW * 0.5;
          const crest = backWaveY(x, t);
          if (y > crest + 8) continue;

          const chIdx = (((c + rowShift) % line.length) + line.length) % line.length;
          const ch = line[chIdx];
          if (ch === " ") continue;

          // Glow intensity peaks near the horizon crest
          const distToCrest = Math.max(0, crest - y);
          const horizonFade = Math.exp(-distToCrest / (height * 0.22));
          const edgeFade = 1 - Math.pow(Math.abs((x / width) - 0.5) * 2, 2.2) * 0.55;
          const shimmer = 0.5 + 0.5 * Math.sin(t * 1.1 + c * 0.16 + r * 0.9);
          const alpha = horizonFade * edgeFade * (0.08 + shimmer * 0.34) * (1 - ny * 0.15);

          if (alpha < 0.035) continue;

          ctx.fillStyle = alpha > 0.24
            ? `rgba(185, 227, 255, ${alpha.toFixed(3)})`
            : `rgba(96, 165, 250, ${alpha.toFixed(3)})`;
          ctx.fillText(ch, x, y);
        }
      }
      ctx.restore();
    }

    function render() {
      ctx.fillStyle = "#03050A";
      ctx.fillRect(0, 0, width, height);

      // Atmospheric blue horizon bloom behind the crest
      const bloom = ctx.createRadialGradient(
        width * 0.5,
        height * 0.36,
        10,
        width * 0.5,
        height * 0.4,
        Math.max(width, height) * 0.52
      );
      bloom.addColorStop(0, "rgba(147, 197, 253, 0.36)");
      bloom.addColorStop(0.32, "rgba(37, 99, 235, 0.24)");
      bloom.addColorStop(0.7, "rgba(15, 35, 90, 0.08)");
      bloom.addColorStop(1, "rgba(3, 5, 10, 0)");
      ctx.fillStyle = bloom;
      ctx.fillRect(0, 0, width, height);

      drawCommandSky(time);
      drawWave(
        backWaveY,
        time,
        "rgba(147, 197, 253, 0.72)",
        "rgba(37, 99, 235, 0.34)",
        2
      );
      drawWave(
        frontWaveY,
        time,
        "rgba(96, 165, 250, 0.52)",
        "rgba(29, 78, 216, 0.22)",
        1.5
      );

      if (!prefersReducedMotion) {
        time += 0.012;
        rafId = window.requestAnimationFrame(render);
      }
    }

    resize();
    render();
    window.addEventListener("resize", () => {
      resize();
      if (prefersReducedMotion) render();
    });

    document.addEventListener("visibilitychange", () => {
      if (prefersReducedMotion) return;
      if (document.hidden && rafId) {
        window.cancelAnimationFrame(rafId);
        rafId = 0;
      } else if (!document.hidden && !rafId) {
        rafId = window.requestAnimationFrame(render);
      }
    });
  }

  // Active nav indicator
  function setActiveNav(key) {
    navLinks.forEach((link) => {
      link.classList.toggle("is-active", link.dataset.nav === key);
    });
  }

  // Mobile menu controls
  function openMobileMenu() {
    if (!mobileBackdrop || !menuToggle) return;
    mobileBackdrop.hidden = false;
    menuToggle.setAttribute("aria-expanded", "true");
    menuToggle.setAttribute("aria-label", "Close navigation menu");
  }

  function closeMobileMenu() {
    if (!mobileBackdrop || !menuToggle) return;
    mobileBackdrop.hidden = true;
    menuToggle.setAttribute("aria-expanded", "false");
    menuToggle.setAttribute("aria-label", "Open navigation menu");
  }

  if (menuToggle && mobileBackdrop) {
    menuToggle.addEventListener("click", () => {
      if (mobileBackdrop.hidden) {
        openMobileMenu();
      } else {
        closeMobileMenu();
      }
    });

    mobileBackdrop.addEventListener("click", (event) => {
      if (mobileMenu && !mobileMenu.contains(event.target)) {
        closeMobileMenu();
      }
    });
  }

  // Sheet controls (Features, Docs, Installation)
  function closeAllSheets(resetNav = true) {
    Object.values(sheets).forEach((sheet) => {
      if (sheet) sheet.hidden = true;
    });
    if (resetNav) {
      setActiveNav("home");
    }
  }

  function openSheet(name) {
    closeAllSheets(false);
    const target = sheets[name];
    if (target) {
      target.hidden = false;
      setActiveNav(name);
    }
  }

  Object.values(sheets).forEach((backdrop) => {
    if (!backdrop) return;
    backdrop.addEventListener("click", (event) => {
      if (event.target === backdrop) {
        closeAllSheets(true);
      }
    });
  });

  document.querySelectorAll("[data-close-sheet]").forEach((btn) => {
    btn.addEventListener("click", () => closeAllSheets(true));
  });

  // Open Features sheet if arriving via index.html#features
  if (window.location.hash === "#features") {
    openSheet("features");
  }

  // Docs inner tabs
  const docTabs = document.querySelectorAll("[data-doc-tab]");
  const docPanels = document.querySelectorAll("[data-doc-panel]");

  docTabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      const target = tab.dataset.docTab;
      docTabs.forEach((t) => {
        const active = t.dataset.docTab === target;
        t.classList.toggle("is-active", active);
        t.setAttribute("aria-selected", String(active));
      });
      docPanels.forEach((panel) => {
        const active = panel.dataset.docPanel === target;
        panel.hidden = !active;
        panel.classList.toggle("is-active", active);
      });
    });
  });

  // Command copy buttons
  document.querySelectorAll("[data-copy]").forEach((btn) => {
    btn.addEventListener("click", async () => {
      const text = btn.dataset.copy;
      if (!text) return;
      try {
        await navigator.clipboard.writeText(text);
        btn.textContent = "Copied";
        window.setTimeout(() => {
          btn.textContent = "Copy";
        }, 1600);
      } catch {
        btn.textContent = "Select & Copy";
      }
    });
  });

  // Navigation link behavior
  navLinks.forEach((link) => {
    link.addEventListener("click", (event) => {
      const target = link.dataset.nav;
      if (target === "home") {
        event.preventDefault();
        closeMobileMenu();
        closeAllSheets(true);
      } else if (target === "features" || target === "docs" || target === "installation") {
        event.preventDefault();
        closeMobileMenu();
        openSheet(target);
      } else {
        closeMobileMenu();
      }
    });
  });

  // Global Escape key handler
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
      closeMobileMenu();
      closeAllSheets(true);
    }
  });
})();
