#!/usr/bin/env python3
"""Fast BENCH_MATRIX.txt refresh: re-measure ONLY the 80cc-fp/80cc-sp
columns, reusing sccz80/xcc/sdcc from the last committed snapshot untouched.

Use this after an 80cc-only codegen change (the common case this session --
sccz80/xcc/sdcc are separate toolchains this repo does not touch day to day,
so re-running them on every refresh is wasted time). Run
gen_bench_matrix3.py itself instead when those reference compilers, or the
BENCHES/CPUS list, might actually have moved.

Usage: refresh_80cc_matrix.py <old-matrix-file> > new_table.txt
       (old-matrix-file: e.g. `git show HEAD:test/suites/BENCH_MATRIX.txt`
        piped to a temp file, or the current BENCH_MATRIX.txt itself)
"""
import sys, re
sys.path.insert(0, __import__('os').path.dirname(__import__('os').path.realpath(__file__)))
import gen_bench_matrix3 as gm


def parse_old(path):
    """bench,cpu -> (sccz80, xos, xof, sdcc) from an existing matrix file."""
    rows = {}
    order = []
    for line in open(path):
        if not line.startswith('│'):
            continue
        cells = [c.strip() for c in line.strip('│\n').split('│')]
        if len(cells) != 8 or cells[0] == 'benchmark':
            continue
        bench, cpu, sccz80, xos, xof, sdcc, _fp, _sp = cells
        rows[(bench, cpu)] = (sccz80, xos, xof, sdcc)
        order.append((bench, cpu))
    return rows, order


def main():
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        sys.exit(1)
    old, order = parse_old(sys.argv[1])
    only = sys.argv[2:] if len(sys.argv) > 2 else []

    rows = []
    for bench, cpu in order:
        if only and bench not in only:
            continue
        key = (bench, cpu)
        if key not in old:
            continue
        sccz80, xos, xof, sdcc = old[key]
        cflag = mach = None
        for c, _tgt, cf, m in gm.CPUS:
            if c == cpu:
                cflag, mach = cf, m
                break
        if cflag is None:
            continue
        sp = gm.cell(bench, cflag, mach, "80cc", False)
        fp = ("= sp (no IX)" if cpu in gm.NO_IX
              else gm.cell(bench, cflag, mach, "80cc", True))
        rows.append((bench, cpu, sccz80, xos, xof, sdcc, fp, sp))
        print(f"  {bench:<13} {cpu:<6} {fp:<20} {sp}", file=sys.stderr, flush=True)

    hdr = ("benchmark", "cpu", "sccz80", "xcc -Os", "xcc -Of", "sdcc",
           "80cc-fp", "80cc-sp")
    w = [max(len(str(r[i])) for r in rows + [hdr]) for i in range(8)]
    def line(l, m, rr): return l + m.join("─" * (x + 2) for x in w) + rr
    def row(c): return "│ " + " │ ".join(str(c[i]).ljust(w[i]) for i in range(8)) + " │"
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
