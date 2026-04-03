# External Integrations

**Analysis Date:** 2026-04-03

## APIs & External Services

**Print Host APIs:**
- OctoPrint - Printer upload and remote control support via `src/slic3r/Utils/OctoPrint.hpp` and `src/slic3r/Utils/PrintHost.cpp`
  - SDK/Client: Custom C++ client built on `Http` and libcurl
  - Auth: API key stored in print-host config; optional CA-file handling in the host classes
  - Endpoints used: Host-dependent HTTP routes for testing, upload, and start-print flows
- PrusaLink - Printer upload and remote control support via the `PrusaLink` subclass in `src/slic3r/Utils/OctoPrint.hpp`
  - SDK/Client: Same HTTP client layer as OctoPrint
  - Auth: Username/password and authorization mode in config
  - Endpoints used: Host upload, version checks, and storage discovery
- PrusaConnect - Cloud-connected print host support via `PrusaConnect` and `PrusaConnectNew`
  - SDK/Client: Custom HTTP client and service config helpers in `src/slic3r/Utils/PrusaConnect.hpp`
  - Auth: UUID/team-id and service configuration; exact auth flow is partly encapsulated in code
  - Endpoints used: Upload, queue/start-print actions, printer discovery, and notification host resolution
- Moonraker - Klipper/Moonraker integration via `src/slic3r/Utils/Moonraker.hpp`
  - SDK/Client: Custom HTTP client on top of libcurl
  - Auth: API key and CA file config
  - Endpoints used: Moonraker web API routes for test and upload flows
- Other print hosts - Duet, FlashAir, AstroBox, Repetier, MKS, and SL1 are selected in `src/slic3r/Utils/PrintHost.cpp`
  - SDK/Client: Same internal print-host abstraction
  - Auth: Host-specific, not fully visible from the top-level mapping pass

**Network Transport:**
- Generic HTTP/HTTPS requests - Shared across uploads, downloads, and host checks in `src/slic3r/Utils/Http.cpp`
  - SDK/Client: libcurl
  - Auth: Per-host headers, API keys, digest/basic auth, and CA bundle handling
  - Endpoints used: File transfer, status queries, form uploads, and URL downloads

## Data Storage

**Databases:**
- None observed

**File Storage:**
- Local filesystem - Used for models, generated G-code, downloads, and temporary upload artifacts
  - SDK/Client: Boost.Filesystem and standard library file I/O
  - Auth: Not applicable
  - Buckets: Not applicable

**Caching:**
- None observed

## Authentication & Identity

**Auth Provider:**
- No centralized auth system observed
- Authentication is implemented per integration, mostly through API keys or host credentials

**OAuth Integrations:**
- None observed in the mapped source files

## Monitoring & Observability

**Error Tracking:**
- None observed

**Analytics:**
- None observed

**Logs:**
- Application logging is local, using Boost.Log and file/stdout targets depending on build flags

## CI/CD & Deployment

**Hosting:**
- Desktop binaries are published externally, but the repository itself does not show a deployment platform integration in this pass

**CI Pipeline:**
- GitHub is used as the source host for releases and issue tracking, but CI workflow wiring was not part of this mapping pass

## Environment Configuration

**Development:**
- Print-host integrations depend on configuration values supplied by the app UI or profile settings, not on a centralized `.env`
- `SLIC3R_STATIC` affects how curl and certificate handling are wired on some platforms

**Staging:**
- None observed

**Production:**
- Network features rely on system or bundled CA certificates; `src/slic3r/Utils/Http.cpp` contains fallback detection for certificate stores
- Some host integrations expose different behavior on Windows/macOS versus Linux because of native networking and device APIs

## Webhooks & Callbacks

**Incoming:**
- None observed

**Outgoing:**
- Print-host upload progress callbacks are used internally by the job queue in `src/slic3r/Utils/PrintHost.cpp`
- File-transfer and download callbacks are routed through `Http` progress/error hooks

---

*Integration audit: 2026-04-03*
*Update when adding/removing external services*
