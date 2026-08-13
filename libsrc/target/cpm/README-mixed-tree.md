# `libsrc/target/cpm` — mixed classic + newlib tree

This directory holds **two products** that must not cross-link.

| Product | Contents | CPUs | Select with |
|---------|----------|------|-------------|
| **Classic** | `fcntl/`, `stdio/`, `graphics/`, `gsx/`, `time/`, `cpm/`, classic `*.lst` | Z80, IXIY, Z180, 8080, 8085, … | `+cpm` default / `-clib=8080` / `8085` / … |
| **Newlib** | `config/`, `startup/`, `driver/`, `library/`, `cpm_crt.asm.m4`, `crt_config.inc` | **Z80-class only** | `+cpm -clib=new` / `sdcc_ix` / `sdcc_iy` |

**Isolation:** classic `*.lst` never list newlib objects; newlib `library/cpm_*.lst` never list classic fcntl/gfx. Machine **SUBTYPE**s (~138 in `cpm.cfg`) stay classic-owned.

**Disk (newlib):** `driver/file/cpm_01_file` — BDOS FCB via `asm_target_open_p1/p2`. No FatFs on plain `+cpm`. See `driver/file/README.md`.

**Serial (newlib):** CON / RDR / PUN / LST character drivers; optional logical names / IOBYTE helpers in `include/_DEVELOPMENT` (arch).

**Do not** mix classic `fcntl` and newlib `cpm_01_file` in one link (two `open` owners).
