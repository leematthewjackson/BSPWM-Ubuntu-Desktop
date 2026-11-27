# Optional applications

None of these scripts is invoked by install.sh. Run from the repository as your normal user, only if wanted.

- `./extras/artcraft.sh`: adds ArtCraft APT repository, verifies the signing fingerprint inherited from My-Mint-Setup, installs AniCraft, DeckCraft, EffectCraft, FigCraft, FilmCraft, GridCraft, PDFCraft, PhotoCraft, SoundCraft, VectorCraft and WordCraft. Verify current vendor instructions before running. MCP configuration is not included.
- `./extras/brave.sh`: installs Brave from its official APT repository. Independently verify all primary signing fingerprints using official vendor information before entering them.
- `./extras/sublime-text.sh`: installs Sublime Text from its official APT repository, with the same independent fingerprint verification.
- `./extras/claude-code.sh`: downloads the official vendor installer, displays it and asks before execution. No sudo required. Sign in separately. Vendor updater is independent of APT.

Desktop+ is intentionally excluded. The desktop must work without any extra. ArtCraft, Brave and Sublime Text update via APT; Claude Code uses its own updater.

The Claude bootstrap downloads a binary; displaying the shell script is not an audit of that binary.
