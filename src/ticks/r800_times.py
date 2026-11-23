#!/usr/bin/env python3
# Builds the R800 timing tables from the instruction table at
# https://map.grauw.nl/resources/z80instr.php (its "R800" column, save the page as HTML first).
#
#   r800_times.py ticks z80instr.html > r800_times.h      the opcode table z88dk-ticks uses
#   r800_times.py model z80instr.html                     the rows of r800_tab in src/common/ticks_model.c
import html, itertools, re, sys

REGSET = [0, 1, 2, 3, 4, 5, 7]          # B C D E H L A, or B C D E IXh IXl A
CC = {'C', 'NC', 'Z', 'NZ', 'PO', 'PE', 'P', 'M'}


def load(path):
    s = open(path, encoding='utf-8', errors='replace').read()
    rows = []
    for m in re.finditer(r'<tr>\s*((?:<td>.*?</td>\s*)+)</tr>', s, re.S):
        c = [html.unescape(re.sub(r'<[^>]+>', '', x)).strip() for x in re.findall(r'<td>(.*?)</td>', m.group(1), re.S)]
        if len(c) == 7:                  # instruction, Z80, Z80+M1, R800, R800+wait, opcode, size
            rows.append(c)
    return rows


def times(cell):
    c = cell.replace('²', '').replace('³', '')
    if c == '?':
        return None
    p = [int(x) for x in c.split('/')]
    return p[0], (p[1] if len(p) > 1 else p[0])


def expand(tok):
    m = re.fullmatch(r'([0-9A-F]{2})((?:\+(?:8\*[bpqr]|[rpq]))*)', tok)
    if not m:
        sys.exit("bad opcode token " + tok)
    base = int(m.group(1), 16)
    sets = []
    for t in re.findall(r'\+(8\*[bpqr]|[rpq])', m.group(2)):
        sets.append([(8 if t.startswith('8*') else 1) * x for x in (range(8) if t[-1] == 'b' else REGSET)])
    return sorted({base + sum(c) for c in (itertools.product(*sets) if sets else [()])})


def ticks_table(rows):
    tab = {}
    for r in rows:
        t = times(r[3])
        if not t:
            continue
        tk = r[5].split()
        if tk[0] in ('DD', 'FD'):
            cls, ops = (4, expand(tk[3])) if tk[1] == 'CB' else (1, expand(tk[1]))
        elif tk[0] == 'ED':
            cls, ops = 2, expand(tk[1])
        elif tk[0] == 'CB':
            cls, ops = 3, expand(tk[1])
        else:
            cls, ops = 0, expand(tk[0])
        for op in ops:
            v = (t[0], t[1], int(r[6]))
            if tab.get((cls, op), v) != v:
                sys.exit("conflict at %d %02x: %s" % (cls, op, r[0]))
            tab[(cls, op)] = v
    print("/* Generated from the R800 column of https://map.grauw.nl/resources/z80instr.php by r800_times.py.")
    print("   [class][opcode] = { taken, not taken, length }; a length of 0 means no entry.")
    print("   Classes: 0 plain, 1 DD or FD prefix, 2 ED, 3 CB, 4 DD/FD CB (the opcode is the byte after the offset). */")
    print("static const unsigned char r800_times[5][256][3] = {")
    for cls in range(5):
        print("  {")
        for op in range(256):
            if (cls, op) in tab:
                print("    [0x%02x] = { %d, %d, %d }," % ((op,) + tab[(cls, op)]))
        print("  },")
    print("};")


def sig_token(mn, i, n, t):
    if t in ("(IX+o)", "(IY+o)"): return "(ix+o)"
    if t in ("(IX)", "(IY)"): return "(ix)"
    if t in ("IX", "IY"): return "ix"
    if t in ("IXp", "IYq", "IXh", "IXl", "IYh", "IYl", "p", "q"): return "p"
    if mn in ("jp", "call", "jr") and i == 0 and n == 2 and t in CC: return "cc"
    if mn == "ret" and n == 1 and t in CC: return "cc"
    if t == "r" or t in ("A", "B", "C", "D", "E", "H", "L", "F"): return "r"
    if t in ("I", "R"): return "ir"
    return t.lower()


def model_table(rows):
    out = {}
    for r in rows:
        t = times(r[3])
        if not t:
            continue
        m = re.match(r'(\S+)\s*(.*)', r[0])
        mn = m.group(1).lower()
        ops = [o.strip() for o in m.group(2).split(',')] if m.group(2) else []
        toks = []
        for i, o in enumerate(ops):
            if mn in ("bit", "res", "set") and i == 0: toks.append("b")
            elif mn in ("rst", "im"): toks.append("n")
            else: toks.append(sig_token(mn, i, len(ops), o))
        sig = mn + (" " + ",".join(toks) if toks else "")
        if out.get(sig, t) != t:
            sys.exit("conflict at " + sig)
        out[sig] = t
    for k in sorted(out):
        print('    { "%s", %d, %d },' % (k, out[k][0], out[k][1]))


if __name__ == '__main__':
    if len(sys.argv) != 3 or sys.argv[1] not in ('ticks', 'model'):
        sys.exit("usage: r800_times.py ticks|model z80instr.html")
    (ticks_table if sys.argv[1] == 'ticks' else model_table)(load(sys.argv[2]))
