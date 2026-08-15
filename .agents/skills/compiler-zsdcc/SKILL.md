---
name: compiler-zsdcc
description: >
  zsdcc (SDCC-based) compiler path in z88dk: -clib=sdcc_ix / sdcc_iy, newlib
  integration, and regenerating src/zsdcc/sdcc-z88dk.patch for SDCC upgrades
  (ABI 0, version string, ChangeLog revision, peep specials, c1-mode adb).
  Use when building with SDCC, debugging sdcc calling conventions, or
  upgrading the zsdcc pin / patch / tarball.
---

# Compiler — zsdcc

Binary: `z88dk-zsdcc` (via `zcc -compiler=sdcc` or target `-clib=sdcc_*`).  
Sources / patches: `src/zsdcc/`. Pin: root `Makefile` `SDCC_VERSION`.

## Agent facts

| Topic | Detail |
|-------|--------|
| Common clibs | `sdcc_ix`, `sdcc_iy` (IY reserved in many newlib configs) |
| World | Prefer **newlib** (`-clib=new` / sdcc clibs), not classic 8085 |
| Calling | Do not mix sccz80 and sdcc objects carelessly |
| Opts | SDCC-specific peephole rules under `lib/sdcc/` |
| Preprocessor | **ucpp** (not stock sdcpp) |

## Version (this tree)

| Item | Value |
|------|--------|
| SDCC baseline | **4.6.0 r16639** (final release tag; `changelog.txt` v2.5) |
| Current patch | `src/zsdcc/sdcc-z88dk.patch` |
| Snapshot name | `src/zsdcc/sdcc-16639-z88dk.patch` |
| Makefile pin | `SDCC_VERSION=16639` |
| CI / HTTP tarball | `zsdcc_r16639_src.tar.gz` (nightly `http://nightly.z88dk.org/zsdcc/`) |

Historical snapshots stay under `src/zsdcc/sdcc-*-z88dk.patch` for rebuild of older pins. Human notes: `src/zsdcc/readme.md`.

## Select via zcc

| Flag | Meaning |
|------|---------|
| `-clib=sdcc_iy` | Preferred on many targets; adds `--reserve-regs-iy` |
| `-clib=sdcc_ix` | SDCC with IX frame conventions as defined by cfg |

```text
zcc +cpm -clib=sdcc_iy -vn hi.c -o hi
```

## Limits

- Intended for **Z80-class** work in this toolchain.
- For **8080 / 8085 / gbz80** classic products, prefer **sccz80** (or 80cc), not zsdcc.
- Library directory is often still `lib/clibs/sdcc_ix` even for `sdcc_iy`. Read `lib/config/<target>.cfg`.

---

## Generating / upgrading the zsdcc patch

Use this when SDCC releases (or z88dk moves pin). Product docs: issue #2974 / PR class “prepare patch and tarball”.

### Layout

| Path | Role |
|------|------|
| `Makefile` `SDCC_VERSION` | svn revision checked out or tarball name |
| `src/zsdcc/sdcc-z88dk.patch` | **Default** patch applied by `make` (non-HTTP build) |
| `src/zsdcc/sdcc-<rev>-z88dk.patch` | Frozen copy for that rev (keep previous revs) |
| `src/sdcc-build/` | Working tree (gitignored); svn checkout or tarball extract |
| `zsdcc_r<rev>_src.tar.gz` | Pre-patched sources for CI (`BUILD_SDCC_HTTP=1`); gitignored unless force-added for upload |

Build without HTTP: `svn checkout -r $(SDCC_VERSION) …/trunk/sdcc` then `patch -p0 < sdcc-z88dk.patch`.  
HTTP: extract tarball (already patched).

### Required patch components (keep all of these)

These are z88dk-specific; they do **not** belong upstream as a unit.

#### 1. ABI revision = **0** (`src/z80/main.c`)

Every Z80-family port descriptor must use:

```c
0,                            /* ABI revision */   /* was 1 */
```

Stock SDCC defaults to ABI **1** (`__sdcccall(1)`). z88dk libraries and classic/newlib bridges expect **ABI 0** (traditional stack / `__z88dk_callee` / `__z88dk_fastcall` world with `__sdcccall(0)`).  
**Do not** “fix” PORT stack vectors when regenerating — only the ABI field is intentional. Context lines around `{ -1, 0, 0, 4, 0, 3, 0 }` etc. may move between SDCC revs; they are not z88dk edits.

Optional parity with older patches: first vector may keep `// Stack options` comment.

#### 2. User-facing version string (`src/SDCCmain.c` `printVersionInfo`)

Replace stock “SDCC : port/port …” banner with z88dk identity, for example:

```text
ZSDCC IS A MODIFICATION OF SDCC FOR Z88DK
Build: <SDCC_VERSION_STR> #<build> (env) <date>
sdcc website: https://sourceforge.net/projects/sdcc/
patch details: https://github.com/z88dk/z88dk/blob/master/src/zsdcc/sdcc-z88dk.patch
```

`#<build>` comes from SDCC’s build-number machinery (see ChangeLog below).

#### 3. ChangeLog **`$Revision$`** — fix the reported build number

**Important:** SDCC’s svn tree does **not** update `ChangeLog`’s `$Revision: … $` keyword on every commit. The tag/checkout revision (e.g. **16639**) often disagrees with the string at the end of `ChangeLog` (e.g. **16608**).

`version.awk` / `getBuildNumber()` read that keyword → **`z88dk-zsdcc --version` shows the wrong `#NNNN`** unless the patch forces it.

Always add a ChangeLog hunk that sets:

```text
$Revision: <SDCC_VERSION> $
```

to the **same** revision as `Makefile` `SDCC_VERSION` (the pin you actually build).  
Historical example: `sdcc-14648-z88dk.patch` header. If `svn diff` ignores the keyword edit, hand-write the unified hunk (keyword expansion can hide the change from `svn status`).

#### 4. z88dk intrinsic / special call awareness (`src/z80/peep.c`)

Stock peep does not know z88dk helper register contracts. The patch inserts `special_funcs[][3]`:

| Column | Meaning |
|--------|---------|
| `[0]` | Exact asm call text, e.g. `"call\t____sdcc_ll_…"` |
| `[1]` | Input regs used as parms (`dehl`, `bcdehl`, …) |
| `[2]` | Regs preserved across the call |

Hooks in `z80MightBeParmInCallFromCurrentFunction` / destroy/preserve helpers so peep does not break around:

- `____sdcc_ll_*` — long long load/store/shift/add/sub helpers  
- `____sdcc_4_*` / `____sdcc_2_*` — 32/16-bit mem helpers  
- `____sdcc_ldi*`, `____sdcc_outi*` — block move / I/O  
- `____sdcc_cpu_push_di` / `____sdcc_cpu_pop_ei`  
- `____sdcc_lib_setmem_hl`, `____sdcc_load_*`, `____sdcc_store_*`

When regenerating: re-apply the whole table; only extend it when new z88dk runtime helpers appear. Upstream may rename `ISINST` → `lineIsInst` — attach hooks to the **current** API, do not resurrect old macro names blindly.

#### 5. Other required hunks (carry forward)

| File | Change |
|------|--------|
| `src/SDCCasm.c` | Temp labels `l%N_%05d$`; `extern` → `.globl` |
| `src/SDCCglue.c` | Emit/track externs; skip `!ds` for pure externs |
| `src/SDCCopt.c` | Builtin memcpy name `_memcpy` (not `___memcpy`) — both call sites |
| `src/z80/main.c` | **legacyBanking**: `port->stack.banked_overhead = 0` in `_finaliseOptions` |
| `src/SDCCmain.c` | **c1-mode adb**: `if (options.debug && (fullSrcFileName \|\| options.c1mode))` so `--c1mode` + debug still writes `.adb` |

#### 6. Optional / historical

| Item | Note |
|------|------|
| `sdas/linksrc/aslink.h` `elf(int i)` | Fedora / GCC C23 fix (#2717). **Already fixed in SDCC 4.6.0** (`void elf(int i)`). Re-check on new revs; only re-add if upstream regresses. Prefer this tiny prototype fix over forcing `-std=c17` on the whole build. |

### Procedure (new pin)

```bash
# 1. Pin
#    Edit Makefile SDCC_VERSION=<rev>   # e.g. 16639

# 2. Clean tree
rm -rf src/sdcc-build
svn checkout -r <rev> https://svn.code.sf.net/p/sdcc/code/trunk/sdcc -q src/sdcc-build

# 3. Apply previous patch (may need fuzz/offsets)
patch -d src/sdcc-build -p0 < src/zsdcc/sdcc-z88dk.patch
# Fix rejects; ensure every component above is present.

# 4. Force ChangeLog revision string to <rev>
#    Edit last $Revision: … $ line → $Revision: <rev> $

# 5. Regenerate unified patch from clean base
cd src/sdcc-build
svn revert -R .   # if regenerating from edits; or diff working tree vs pristine
# Prefer: start from pristine checkout, re-apply all edits, then:
svn diff src/SDCCasm.c src/SDCCglue.c src/SDCCmain.c src/SDCCopt.c \
         src/z80/main.c src/z80/peep.c > /tmp/zsdcc-body.patch
# Hand-prepend ChangeLog hunk if svn omits keyword-only ChangeLog.
# Install:
cp /tmp/zsdcc-full.patch ../../src/zsdcc/sdcc-z88dk.patch
cp /tmp/zsdcc-full.patch ../../src/zsdcc/sdcc-<rev>-z88dk.patch

# 6. Round-trip
svn revert -R .
patch -p0 --dry-run < ../../src/zsdcc/sdcc-z88dk.patch   # must be clean
patch -p0 < ../../src/zsdcc/sdcc-z88dk.patch

# 7. Tarball for nightly / CI (from z88dk root; no .o/.a)
cd ../..
tar --exclude=.svn --exclude='*.o' --exclude='*.a' \
  -czf zsdcc_r<rev>_src.tar.gz src/sdcc-build
# Upload to nightly server; force-add only if packaging in git: git add -f zsdcc_r<rev>_src.tar.gz

# 8. Smoke
#    configure (same flags as Makefile BUILD_SDCC), make -j2
#    ./src/sdcc-build/src/sdcc --version   # expect #=<rev>
#    cp to bin/z88dk-zsdcc
```

### Checklist before calling the upgrade done

- [ ] `SDCC_VERSION` == snapshot filename rev == ChangeLog `$Revision$` == `--version` `#NNNN`
- [ ] All Z80-family ports: ABI field **0**
- [ ] `printVersionInfo` z88dk banner + patch URL
- [ ] `special_funcs` table present; peep hooks compile
- [ ] legacyBanking overhead fix present
- [ ] c1-mode adb condition present
- [ ] SDCCasm / glue / opt memcpy hunks present
- [ ] `patch -p0` clean on pristine checkout
- [ ] Tarball extracts to `src/sdcc-build/` and configures
- [ ] `changelog.txt` + `src/zsdcc/readme.md` version lines updated

### Pitfalls

1. **Diff of old patch vs new patch** looks like PORT vectors “changed” — usually context only; only ABI `1`→`0` is required.  
2. **Skipping ChangeLog** → wrong `#NNNN` in CI reports and support mail.  
3. **Tarball full of `.o`** after a local build → run `make distclean` / delete objects before packing.  
4. **Dropping legacyBanking or peep table** when “regenerating from RC” — re-diff against last good `sdcc-*-z88dk.patch` net adds.  
5. **Untracked local `.agents/`** can block `git merge master` (master owns `.agents/`). Move or remove incomplete local trees first.

## Related

- `src/zsdcc/readme.md`, root `Makefile` (`BUILD_SDCC`, `BUILD_SDCC_HTTP`)
- `tool/zcc`, `library/newlib`, `lib/sdcc/`
- Wiki: `wiki/tools/Tool---zsdcc.md` (keep baseline in sync)
- `library-newlib`, `tool-zcc`, wiki `learning/Compilers.md`
