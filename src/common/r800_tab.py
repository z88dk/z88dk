#!/usr/bin/env python3
# Prints the rows of r800_tab in ticks_model.c from the instruction table at
# https://map.grauw.nl/resources/z80instr.php (its "R800" column; save the page as HTML first).
#
#   r800_tab.py z80instr.html
#
# Each row is { signature, time taken, time not taken }. A signature is the mnemonic and the classes
# of its operands: r (a-l), p (an index half), ix (ix or iy), (ix+o), n and nn (an 8 and a 16-bit
# immediate), o (a jump offset), b (a bit number), cc (a condition), (n) and (nn) (a port or an
# address), ir (i or r).
import html, re, sys

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


def operand_class(mn, i, n, t):
    if t in ("(IX+o)", "(IY+o)"): return "(ix+o)"
    if t in ("(IX)", "(IY)"): return "(ix)"
    if t in ("IX", "IY"): return "ix"
    if t in ("IXp", "IYq", "IXh", "IXl", "IYh", "IYl", "p", "q"): return "p"
    if mn in ("jp", "call", "jr") and i == 0 and n == 2 and t in CC: return "cc"
    if mn == "ret" and n == 1 and t in CC: return "cc"
    if t == "r" or t in ("A", "B", "C", "D", "E", "H", "L", "F"): return "r"
    if t in ("I", "R"): return "ir"
    return t.lower()


def main(path):
    out = {}
    for r in load(path):
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
            else: toks.append(operand_class(mn, i, len(ops), o))
        sig = mn + (" " + ",".join(toks) if toks else "")
        if out.get(sig, t) != t:
            sys.exit("conflict at " + sig)
        out[sig] = t
    for k in sorted(out):
        print('    { "%s", %d, %d },' % (k, out[k][0], out[k][1]))


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.exit("usage: r800_tab.py z80instr.html")
    main(sys.argv[1])
