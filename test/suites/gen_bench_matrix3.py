#!/usr/bin/env python3
"""Build a complete, fresh benchmark matrix — every bench (including the seven
added in August) x every CPU x 80cc-fp / 80cc-sp, with sccz80 and sdcc as z80-only
reference columns.

It measures every benchmark in BENCHES and does not reuse a table skeleton.
Each cell is `bytes / ticks(millions)`; a bench that will not build or run
on a CPU is recorded rather than skipped, so gaps stay visible.

Output goes to stdout as the box-drawn table for BENCH_MATRIX.txt.
"""
import os, re, subprocess, sys

SUITES = os.path.dirname(os.path.realpath(__file__))
ROOT   = os.path.abspath(os.path.join(SUITES, "../.."))
ENV    = dict(os.environ, ZCCCFG=os.path.join(ROOT, "lib/config"),
              PATH=os.path.join(ROOT, "bin") + ":" + os.environ["PATH"])

BENCHES = ("charbench crcbench intbench ptrbench sieve rle sortbench queenbench "
           "searchbench switchbench structbench vecbench recordbench maskbench "
           "strbench listbench interpbench matrixbench hashbench fixedbench "
           "histbench lexbench bitfieldbench widthbench predbench shiftbench "
           "localbench divbench callbench md5 charmulbench").split()

# cpu -> (make target, zcc clib flag, ticks machine flag)
CPUS = [
    ("z80",   "test.bin",          "",              "-b msx"),
    ("z80n",  "test_z80n.bin",     "-clib=z80n",    "-mz80n"),
    ("z180",  "test_z180.bin",     "-clib=z180",    "-mz180"),
    ("ez80",  "test_ez80_z80.bin", "-clib=ez80_z80","-mez80_z80"),
    ("r2ka",  "test_r2ka.bin",     "-clib=rabbit",  "-mr2ka"),
    ("r4k",   "test_r4k.bin",      "-clib=rabbit4k","-mr4k"),
    ("r6k",   "test_r6k.bin",      "-clib=rabbit6k","-mr6k"),
    ("kc160", "test_kc160.bin",    "-clib=kc160",   "-mkc160"),
    # No separate clib (see src/80cc/R800_TARGET_PLAN.md): the object stays
    # z80-stamped and links the plain z80/test clib unmodified.
    ("r800",  "test.bin",          "-mr800",        "-mr800"),
    ("8080",  "test_8080.bin",     "-clib=8080",    "-m8080"),
    ("8085",  "test_8085.bin",     "-clib=8085",    "-m8085"),
    ("gbz80", "test_gbz80.bin",    "-clib=gbz80",   "-mgbz80"),
    ("vm1",   "test_vm1.bin",      "-clib=vm1",     "-mvm1"),
]
# no index registers, so -fframe-pointer is a no-op and fp == sp. vm1 is an
# 8080-class core (its index home is the RS-prefixed h'l', not IX/IY).
NO_IX = {"gbz80", "8080", "8085", "vm1"}

# sdcc only has ports for these. r2ka needs the sdcc_opt.1 section rules
# (_XABS/_IIVT/.equ) plus the ioi/ioe prefix rule to get through z80asm;
# without them every Rabbit cell is a BUILD. r4k/r6k are not sdcc ports at all.
SDCC_CPUS = {"z80", "z80n", "z180", "ez80", "r2ka", "gbz80", "r800"}

TMP = os.environ.get("MX_TMP", "/tmp/80cc_mx")
os.makedirs(TMP, exist_ok=True)


def sh(cmd, cwd=SUITES, timeout=400):
    try:
        return subprocess.run(cmd, cwd=cwd, env=ENV, shell=True,
                              capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None


def cell(bench, cpu_flag, mach, compiler, fp):
    """Build and run one cell; return 'NNNNB / N.NNM', or a marker."""
    # most benches are <dir>/<dir>.c but not all (rle/rle_encode.c) — glob
    import glob as _g
    cands = sorted(_g.glob(os.path.join(SUITES, bench, "*.c")))
    src = next((c for c in cands if os.path.basename(c) == bench + ".c"), None) or cands[0]
    out = os.path.join(TMP, f"{bench}_{compiler}_{'fp' if fp else 'sp'}.bin")
    fpflag = "-Cc-fframe-pointer" if fp else ""
    cmd = (f"zcc +test -vn {cpu_flag} -compiler={compiler} {fpflag} "
           f"-DNO_LOG_RUNNING -DNO_LOG_PASSED -I{SUITES}/../framework "
           f"-I{SUITES}/{bench} {SUITES}/../framework/test.c {src} "
           f"-o {out} -create-app")
    r = sh(cmd)
    if r is None or r.returncode != 0 or not os.path.exists(out):
        return "BUILD"
    size = os.path.getsize(out)
    # Run FROM THE BENCH DIRECTORY. md5sum.c does MDFile("md5test.bin"), an
    # open() relative to the CWD, so a run from test/suites mismatches the digest
    # and reports a false `WRONG` on every md5 cell.
    r = sh(f"z88dk-ticks -w 300 {mach} {out}", cwd=os.path.join(SUITES, bench))
    if r is None:
        return f"{size}B / HANG"
    m = re.search(r"Ticks:\s*(\d+)", r.stdout + r.stderr)
    if not m:
        return f"{size}B / RUN"
    # the framework always prints "N run, N passed, M failed" — read M, do not
    # just look for the word
    fail = re.search(r"(\d+)\s+failed", r.stdout + r.stderr)
    if fail and int(fail.group(1)) > 0:
        return f"{size}B / WRONG"
    return f"{size}B / {int(m.group(1))/1e6:.2f}M"


def xcc_cell(bench, profile):
    """xcc is a separate toolchain outside the zcc bench harness and is z80-only.
    Its own failures (BUILD/HANG/WRONG) are its results, not ours."""
    import glob as _g
    d = os.path.join(SUITES, bench)
    srcs = sorted(os.path.basename(f) for f in _g.glob(os.path.join(d, "*.c")))
    if not srcs:
        return "—"
    out = os.path.join(TMP, f"{bench}_xcc{profile}.bin")
    if os.path.exists(out):
        os.remove(out)
    r = sh(f"zcc +test -vn -Cx{profile} -compiler=xcc -I../../framework "
           f"-DNO_LOG_RUNNING -DNO_LOG_PASSED ../../framework/test.c "
           f"{' '.join(srcs)} -o {out} -create-app", cwd=d)
    if r is None or not os.path.exists(out):
        return "BUILD"
    size = os.path.getsize(out)
    r = sh(f"z88dk-ticks -w 300 -b msx {out}", cwd=d)
    if r is None:
        return f"{size}B / HANG"
    m = re.search(r"Ticks:\s*(\d+)", r.stdout + r.stderr)
    if not m:
        return f"{size}B / RUN"
    fail = re.search(r"(\d+)\s+failed", r.stdout + r.stderr)
    if fail and int(fail.group(1)) > 0:
        return f"{size}B / WRONG"
    return f"{size}B / {int(m.group(1))/1e6:.2f}M"


def main():
    only = sys.argv[1:]
    benches = [b for b in BENCHES if not only or b in only]
    rows = []
    for b in benches:
        for cpu, _tgt, cflag, mach in CPUS:
            sccz80 = cell(b, cflag, mach, "sccz80", False)
            xos    = xcc_cell(b, "-Os") if cpu == "z80" else "—"
            xof    = xcc_cell(b, "-Of") if cpu == "z80" else "—"
            sdcc   = cell(b, cflag, mach, "sdcc",   False) if cpu in SDCC_CPUS else "—"
            sp     = cell(b, cflag, mach, "80cc", False)
            fp     = "= sp (no IX)" if cpu in NO_IX else cell(b, cflag, mach, "80cc", True)
            rows.append((b, cpu, sccz80, xos, xof, sdcc, fp, sp))
            print(f"  {b:<13} {cpu:<6} {fp:<20} {sp}", file=sys.stderr, flush=True)

    hdr = ("benchmark", "cpu", "sccz80", "xcc -Os", "xcc -Of", "sdcc",
           "80cc-fp", "80cc-sp")
    w = [max(len(str(r[i])) for r in rows + [hdr]) for i in range(8)]
    def line(l, m, rr): return l + m.join("─" * (x + 2) for x in w) + rr
    def row(c):  return "│ " + " │ ".join(str(c[i]).ljust(w[i]) for i in range(8)) + " │"
    print(line("┌", "┬", "┐"))
    print(row(hdr))
    print(line("├", "┼", "┤"))
    for i, r in enumerate(rows):
        print(row(r))
        if i != len(rows) - 1:
            print(line("├", "┼", "┤"))
    print(line("└", "┴", "┘"))


if __name__ == "__main__":
    main()
