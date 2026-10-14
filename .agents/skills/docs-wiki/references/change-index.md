# Wiki change index

Read this file at the start of a page edit. Add rows when new commits or pull requests land. Do not rescan history for a page that already has a row.

The subject line is a filter. Each "Parsed patch" row below was taken from the diff (`git show` or the pull-request files), not from the commit comment. Procedure: skill `docs-wiki`, heading "Change index".

Index built **2026-10-04**. Added **2026-10-14** through product `origin/master` `49678ddd96` and wiki `origin/master` `d9ebfaf`. Wiki clone: `/tmp/z88dk.wiki`, pushed. Printf pages: `6a20572`. #3040 page split and `draft:imported` removal: `eaa1cb0`. `draft:verified` removal: `811d405`. That clone is shallow. `2137fdf` ("Add some more details.") has no parent here, so its patch was not parsed. Do not treat that subject as a list of facts.

#3187 merged as `49678ddd96`. #3186 is still open. Both are on the wiki as `d9ebfaf`.

## Parsed patch — classic sdcc printf scan

| Source | What the patch says | Page |
|--------|---------------------|------|
| `5215f2081f` (merge `2afaa14410`, PR #3171). Subject: "(zpragma): Re-implement the format string scanning" | `zcc` passes `-autoformat` to zpragma for sdcc only (not ez80clang). zpragma scans printf and scanf string literals and ORs `CRT_printf_format` / `CRT_scanf_format` in that zcc run. Classic CRT uses the mask when `CLIB_OPT_PRINTF` is not set, so a literal `%f`, `%e`, or `%g` links that converter. An explicit `#pragma printf` or `-pragma-define:CLIB_OPT_PRINTF` replaces the scan. A non-literal format is not scanned. `zcc_opt.def` is new for each zcc run, so `zcc -c` then a later link drops the scan. Newlib does not read `CRT_printf_format`. | Corrected in `Math32`, `Classic--Maths-Libraries` (math32 and am9511), `Classic--Pragmas`, `Math16`, `NewLib--Platform--Embedded`. Product readmes: math32, math16, am9511, math48. The newlib clause is replaced by `731173ca7f`. |

The printf rows are on the wiki (`6a20572`). The #3040 rows at the bottom are on the wiki (`eaa1cb0`).

## Rules already decided (#3040)

Read from the issue comments, not from a commit subject.

| Topic | Decision | Checked |
|-------|----------|---------|
| Classic vs newlib on one target page | Separate pages. One comment link only. First pages: `Platform---CPM`, `Platform---Sinclair-ZX-Spectrum` | `eaa1cb0` |
| Reference cards | Not for the wiki. Cfg detail stays in the target skill | `eaa1cb0` on the #3040 pages below |
| "Not the other target" tables | Not for the wiki. One sentence and a link | `eaa1cb0` on those pages |
| Draft HTML comments | Not for the wiki | `draft:imported` removed in `eaa1cb0`. `draft:verified` removed in `811d405` |
| Human sections already on the page | Keep them. Correct stale facts in place | — |

## Skipped (subject and paths are not a target page)

| Source | Why it was left closed |
|--------|------------------------|
| z88dk#3048 | `test/suites/recordbench/recordbench.c` only. Signed/unsigned compare. No platform page |
| z88dk#2155 | `src/ticks/debugger_mi2.c`, `src/ticks/syms.c`. Host debugger. No platform page |
| product `origin/master` `c076f150d2`..`49678ddd96`, except the rows below | 80cc, sccz80, copt, ticks, tests, temporary-path fixes, and merges #3174, #3177, #3178, #3180, #3181, #3182, #3183, #3184. No CLIB default, target cfg, or wiki sentence. |

## Parsed patches — wiki commits already applied

These commits **are** the wiki text. Do not add a second sentence from the subject. A later product commit must be parsed the same way before you change the sentence. Where the subject names one machine, the diff edits others. The hunk wins.

| Source | What the patch says | Page |
|--------|---------------------|------|
| `7f97a28` | v2.5 `-lm` is math32 on the overview pages, with `-lmz` and target exceptions named in `Classic--Maths-Libraries`, `Newlib-Overview`, `Tool---zcc`, `Math32`, `Math16`, `maths` | those pages, not a new target paragraph |
| `242620c` | `+zx`: `-lm` is math32. ROM calculator is `-lmz` → `mzx` (same as `-lmzx`). `-lmzx_tiny` stays the small ROM library. 6-byte is `--genmath` or `--math48` | `Platform---Sinclair-ZX-Spectrum` floating-point sentences. Already on the page |
| `242620c` | `+zx81`: `-lm` is `genmath_zx81`, not math32. The ROM interrupt does not save AF'. `-lmz` is ROM `m81` (same as `-lm81`). The examples were swapped to match | `Platform---Sinclair-ZX81`. Do not "correct" this to math32 from the 8080-family subject |
| `242620c` | `+lambda`: `-lm` is `genmath_zx81` for the same AF' reason. The old `-lmlambda` example is now `-lmz` (`mlambda_tiny`). `-lmlambda` remains the larger ROM name | `Platform---Lambda` |
| `242620c` | `+cpm -clib=8080` and `-clib=8085`: `-lm` is `math32_8080` / `math32_8085`. `--math-mbf32` is `mbf32_*`. The smoke table row changed from `--math32` to `-lm` | `Platform---CPM` Quick Start and the smoke table. Keep the fact. The smoke table itself is still agent scaffolding (#3040) |
| `242620c` | Same `-lm` / `--math-mbf32` sentence for 8080 or 8085 on Altair 8800, Alphatronic P2, Corvette, DAI (`--math-dai32` and `--math-am9511` stay), Krokha, Lviv, Mikro-80, PMD-85, Radio-86, Sol-20, Specialist, Vector-06C, M100 (`math32_8085`), Micro8085, Game Boy (`math32_gbz80`), Sanyo `mbc2000` (`-clib=8080`, not 8085) | that machine's page. One sentence. Already inserted |
| `242620c` | `+cpc` and `+z88`: `-lm` is math32. `-lmz` is `cpc_math` or `z88_math`. `+ts2068`: `-lmz` is `m2068` | `Platform---Amstrad-CPC`, `Platform---Cambridge-z88`, `Platform---Timex-TS2068` |
| `916f24a` | Replaces "newlib `-lm` is math48" on bare `+z180`. Both newlib and classic `-clib=default` `-lm` are `math32_z180`. `--math48` is `m_z180` (newlib) or `math48_z180` (classic). No Z180 genmath. Do not link plain Z80 `math32` / `math48` into `-mz180` | `Platform---Z180` |
| `916f24a` | Same `math32_z180` sentence on `+scz180` and `+yaz180` | `Platform---SCZ180`, `Platform---YAZ180` |
| `916f24a` | `+cpm -subtype` TIM-011 is classic `-clib=z180`. The old "do not use `-lm`" lines were removed. `-lm` is `math32_z180` | `Platform---TIM011` |
| `916f24a` | `+cpm -clib=z180 -lm` is `math32_z180`. `--math48` is `math48_z180`. One smoke-table row | `Platform---CPM` |
| `916f24a` | `+rcmx000 -lm` and `+z80 -clib=r2ka -lm` are `math32_r2ka`. `r4k` is `math32_r4k`. `r6k` is classic and its suffix is `_r4k`, so `-lm` is `math32_r4k`, not `math32_r6k`. Before v2.5, Rabbit `-lm` was math48 | `Platform---Rabbit`, and the matching sentence on `Platform---Z80-Embedded` |
| `916f24a` | `+z80 -clib=vm1` and `+test -clib=vm1`: `-lm` is `math32_vm1`. No `math16_vm1`. `--math-mbf32` stays `mbf32_vm1` | `kr580vm1`, `Platform---Z80-Embedded` |
| `b7635e8` | `+zxn` `-lm` / `--math32` is `math32_z80n` on newlib (`sdcc_iy`, `sdcc_ix`, `new`) and on `-clib=classic`. `--genmath` is `genmath_z80n` on classic and `genmath` (no suffix) on newlib. `--math48` is `math48_z80n` on classic and `m` on newlib. `-lmz` is `mzx` with classic | `Platform---ZX-Spectrum-Next-zxn` and `Platform---Sinclair-ZX-Spectrum-Next` |
| `b7635e8` then `28e401e` then `791be74` | RC2014 external page. The later diff wins. `791be74` keeps the v2.5 facts inside the older float prose: Z80 `-lm` is math32. 8085 subtypes `basic85`, `acia85`, `uart85` `-lm` is `math32_8085`. `--math-mbf32` is `mbf32_8085`. `--am9511` is `am9511_8085`. `--math48` is `m` on newlib and `math48` on classic. math16 pairs with `-lm` for printf | `RC2014-Using-Z88DK`. Do not restore the `28e401e` shortening |
| `28e401e` | Also corrects `-lm` wording on `Assembly-Language`, `CallingConventions`, `Classic-8080` (`printf %f` with `-lm`), `NewLib--Platform--Embedded`, `Platform--Laser-350-500-700` (`-lm` is math32; `--math-mbf32` is the ROM stubs, sccz80 only), `Tool---z80asm---directives` (`FLOAT` ieee32 column is `-lm` / `--math32`). Benchmarks: unlabelled Z88DK/SDCC rows are pre-v2.5 math48, not a new number | those pages. Number paste stays with `methodology-measure` |
| `242620c` | `Platform.md` capability rows: 8085 `-lm` is `math32_8085`. 8080, gbz80, and vm1 `-lm` are `math32_8080` / `math32_gbz80` / `math32_vm1`. The old "default float stays MBF32" cell was removed | `Platform` |
| `60a6b63` | Wiki commit. The diff edits `Platform---PMD85.md` only | That page. Do not add a sentence from the subject "Colour output etc." |
| `e98df63` | Wiki commit. The diff edits `Home.md` by one line | `Home` |
| `d9ebfaf` | Wiki commit for the 2026-10-14 page edit | `Configuration`, `NewLib--Platform--Embedded`, `Classic--Pragmas`, `Math32`, `Tool---80cc` |

## Parsed patches — product commits since 2026-10-04

| Source | What the patch says | Page |
|--------|---------------------|------|
| `49678ddd96` merge of #3187, head `882356991b` | `__CLIB_OPT_MALLOC` is `0` in the generated headers. `0` walks the address chain. `1` searches spare tails. The value is fixed when that target's library is assembled. It does not set the heap size. Targets: sms, z180, z80, zx, zxn, cpm, hbios, rc2014, scz180, yaz180. `rc2014-8085` and the math configs do not define it. The PR title names the spare-tail search. The merged value is `0`. | `Configuration` `clib_cfg.asm`, after `CLIB_OPT_SORT`. `NewLib--Platform--Embedded` beside `CLIB_MALLOC_HEAP_SIZE` and `CRT_STACK_SIZE`. Checked `d9ebfaf`. |
| `731173ca7f` "newlib - honor scanned float printf converters" | `lib/crt/newlib/clib_stubs.inc` reads `CRT_printf_format` and `CRT_scanf_format`. When the scan names a float converter the library mask omits, the CRT sets `CLIB_OPT_PRINTF` to the library mask OR the scan and rebuilds `vfprintf`. An explicit `CLIB_OPT_PRINTF` still replaces both. Width bits alone do not rebuild. | `Classic--Pragmas`, `Math32`, `NewLib--Platform--Embedded`. Checked `d9ebfaf`. |
| `9f7f69c885` "math32 - move N-R inverse into the archive of history" | Public `inv` stays on disk as restoring `1/x`. The Newton-Raphson bodies move to `hist/` and leave the build. | No wiki sentence names the Newton-Raphson body as the public inverse. No edit. |
| `8bff7a7265` "rc2014 - sio tx to 32 bytes" | `__IO_SIO_TX_SIZE` changes from `0x10` to `0x20`. Rx size stays `0x80`. | No page states this size. Left off the wiki. |
| `bc5970c045`, `09825638aa` | Intel and gbz80 `strnlen`, `stpncpy`, `strxfrm`, `memccpy`, and `strlcat` bugfixes. The C results match the existing contracts. | `string` does not state the old bug. No edit. |
| `b98c7d57dc` | gbz80 `strlen` stays the C function. `strlen_fastcall` is not the gbz80 alias. | `string` does not name `strlen_fastcall`. No edit. |
| `62bec728f9` | `intrinsic_label` for llvmz80 and clang is `__asm__(#name ":")`. | `intrinsic` already says the call inlines a label for the map file. No edit. |
| `48804b0ec6`, `245c7b9874` | llvmz80 no longer passes `-fdefault-calling-conv=sdcccall0`. The test note says classic only. | `Clang-support` is ez80-clang, not this driver. No edit. |
| `9138a24f32` | Agent skill text for `ei`. | No wiki page. |

## Parsed patches — open pull requests (not shipped)

Do not write these onto the wiki until they merge. The title is not the change. #3186 is the exception below: the size sentence is on the wiki while the PR is open.

| Source | What the patch says | Page when it merges |
|--------|---------------------|---------------------|
| z88dk#2850 "Vz200 new asm files" | `include/arch/vz.h` and `libsrc/target/vz/vz200.lst`. Drops `vz_bgrd`, `vz_brick`, `vz_clrscr`, `vz_color` from the header and the list. Adds coarse scroll, smooth scroll, sprite draw, text, paper, irq on/off, `vz_waitvb`, and the matching callees. Comments inside the new asm disagree (1 pixel vs 4 pixels; `vz_coursescroll` comments say smooth scroll). Document only symbols that agree in the header and the `.lst` | `Platform---VZ200` |
| z88dk#2162 "Add filesystem API and improve console output" | The file list is `libsrc/target/ticalc/fcntl/` plus TI-83 Plus and TI-86 `.def` files. It adds AppVar `open` / `read` / `write` / `close` / `lseek` / `remove` / `rename`. There is no console-output diff in the file list. Do not add a "small text" claim from the title | `Platform---TI-Calculators` or `ti_calculators` |
| z88dk#3186 head `6bcd17c2` "80cc: Floating point optimisations". Still open. | `zcc --opt-code-size` passes `--opt-code-size` to 80cc. 80cc then uses a helper call when that call is shorter than the inline code. `OPTIONS.md` adds opt-out names. Those names stay off the wiki. | `Tool---80cc`, one sentence. Checked `d9ebfaf` while the PR is open. |

## Page rows from #3040

The `-lm` sentences above stay. These rows are the page split, on the wiki as `eaa1cb0`.

| Page | Source | What changed | Checked |
|------|--------|----------------|---------|
| `Platform---CPM` | #3040 | Classic page. Newlib card, comparison table, and smoke matrix removed. Newlib line is one link to `Newlib-Overview`. Quick Start, disc, console, file, and pragmas stay. Parsed `-lm` sentences stay | `eaa1cb0` |
| `Platform---Sinclair-ZX-Spectrum` | #3040 | Classic page. Newlib recipe and "Not the Spectrum Next" table removed. Next and newlib are one link each. `-lm` / `-lmz` stay. The `zx.cfg` name was dropped from the ROM-maths sentence | `eaa1cb0` |
| `Platform---SMS` | #3040 | Classic page. Reference card, comparison table, and smoke table removed. Newlib link only. The `_stdout` printf note moved to `Newlib-Overview` | `eaa1cb0` |
| `Platform---ZX-Spectrum-Next-zxn` | #3040 | Newlib page. Classic float and classic NEX/DOT recipes stay on `Platform---Sinclair-ZX-Spectrum-Next`. `b7635e8` newlib float sentences stay | `eaa1cb0` |
| `Platform---Sinclair-ZX-Spectrum-Next` | #3040 | Classic page. Draft banner, comparison table, and newlib example removed. Classic `-lm` sentences stay. Subtype list no longer cites `zxn.cfg` | `eaa1cb0` |
| `Platform---RC2014` | #3040 | Newlib page. Classic is one `-clib=default` sentence. 8085 subtype `-lm` sentence from `791be74` stays | `eaa1cb0` |
| `Platform---HBIOS` | #3040 | Newlib page. Classic is one `-clib=default` sentence. Reference card removed | `eaa1cb0` |
| `Platform---Z180` | #3040, `916f24a` | Newlib page. `math32_z180` / `--math48` sentences stay. Reference card removed | `eaa1cb0` |
| `Platform---YAZ180` | #3040, `916f24a` | Same float sentences. Human subtype table. Reference card removed | `eaa1cb0` |
| `Platform---SCZ180` | #3040, `916f24a` | Same float sentences. Human subtype table. Reference card removed | `eaa1cb0` |
| `Platform---Z80-Embedded` | #3040, `916f24a` | `+z80` is newlib by default. `+embedded` is classic by default. One sentence each for the other library. CPU `-lm` names stay | `eaa1cb0` |
| `Newlib-Overview` | #3040 | Human target table. CP/M, ZX, and SMS newlib lines live here. Maths paragraph from `7f97a28` stays. Cfg search-path sentence removed | `eaa1cb0` |
| `Platform` | #3040 | Machine table names classic or newlib. `+cpm`, `+zx`, and `+sms` newlib rows point at `Newlib-Overview`. Capability rows from `242620c` stay | `eaa1cb0` |
