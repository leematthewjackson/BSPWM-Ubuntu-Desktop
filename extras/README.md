# Optional applications

Neither script is invoked by install.sh. Run from the repository as your normal user, only if wanted.

- `./extras/artcraft.sh`: adds ArtCraft APT repository, verifies the signing fingerprint inherited from My-Mint-Setup, installs AniCraft, DeckCraft, EffectCraft, FigCraft, FilmCraft, GridCraft, PDFCraft, PhotoCraft, SoundCraft, VectorCraft and WordCraft. Verify current vendor instructions before running. MCP configuration is not included.
- `./extras/claude-code.sh`: downloads the official vendor installer, displays it and asks before execution. No sudo required. Sign in separately. Vendor updater is independent of APT.

Desktop+ is intentionally excluded. The desktop must work without either extra. ArtCraft updates via APT; Claude Code uses its own updater.
