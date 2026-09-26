#!/usr/bin/env python3
"""Render nextreg.txt as markdown, annotated with the z88dk constant names.

Reads the ZX Spectrum Next register reference (nextreg.txt from the FPGA repo)
and the zxn target config sources, and writes a markdown document that pairs
each register and each documented bit value with the z88dk constant for it.

Usage:
    curl -O https://gitlab.com/SpectrumNext/ZX_Spectrum_Next_FPGA/-/raw/master/cores/zxnext/nextreg.txt
    python3 gen_nextreg_md.py nextreg.txt > nextreg.md

nextreg.txt belongs to the ZX Spectrum Next FPGA project and is not kept in
this repository; fetch it with the command above before regenerating.
"""
import re, os, sys, datetime

def val(s):
    s = s.strip().rstrip(')').strip()
    try:
        if s.lower().startswith('0x'): return int(s, 16)
        if s.lower().startswith('0b'): return int(s, 2)
        return int(s)
    except ValueError:
        return None

def load_z88dk(cfgdir):
    """name -> value, for every active constant in the zxn config sources."""
    consts = {}
    for fn in sorted(os.listdir(cfgdir)):
        path = os.path.join(cfgdir, fn)
        if fn.endswith('.m4'):
            pat = re.compile(r"define\(`__([A-Z0-9_]+)',\s*([^)]*)\)")
            comment = lambda l: l.lstrip().startswith('#')
        elif fn.endswith('.h'):
            pat = re.compile(r"^\s*#define\s+([A-Z0-9_]+)\s+(\S+)")
            comment = lambda l: l.lstrip().startswith('//')
        else:
            continue
        for line in open(path, encoding='utf-8', errors='replace'):
            if comment(line): continue
            m = pat.search(line)
            if not m: continue
            v = val(m.group(2))
            if v is not None:
                consts.setdefault(m.group(1), v)
    return consts

def parse_nextreg(path):
    """[([numbers], title, [body lines])] in file order.

    Multi-byte registers share one entry, e.g. "0x85,0x84,0x83,0x82 (133-130)";
    their numbers are returned in ascending order."""
    lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
    heads = []
    for i, l in enumerate(lines):
        m = re.match(r"^((?:0x[0-9A-Fa-f]{2}\s*,\s*)*0x[0-9A-Fa-f]{2})\s*\([\d-]+\)\s*=>\s*(.+?)\s*$", l)
        if m:
            nums = sorted(int(x, 16) for x in re.findall(r"0x[0-9A-Fa-f]{2}", m.group(1)))
            heads.append((i, nums, m.group(2)))
    out = []
    for idx, (i, nums, title) in enumerate(heads):
        end = heads[idx+1][0] if idx+1 < len(heads) else len(lines)
        body = lines[i+1:end]
        while body and not body[-1].strip(): body.pop()
        out.append((nums, title, body))
    return out

def reg_label(nums):
    """`0x82`-`0x85` (130-133) for a multi-byte register, `0x0B` (11) otherwise."""
    if len(nums) == 1:
        return "`0x%02X` (%d)" % (nums[0], nums[0])
    return "`0x%02X`–`0x%02X` (%d–%d)" % (nums[0], nums[-1], nums[0], nums[-1])

def prefixes_for(regname):
    """Flag prefixes z88dk would derive from a REG_ constant name."""
    words = regname[len('REG_'):].split('_')
    out = set()
    out.add('R' + ''.join(w[0] for w in words if w))
    out.add('R' + ''.join(w[0] for w in words if w) + words[-1][1:] if words and words[-1][1:].isdigit() else '')
    # trailing digits ride along with their word: LAYER_2 -> L2
    out.add('R' + ''.join((w[0] + w[1:]) if w.isdigit() else w[0] for w in words if w))
    return {p for p in out if p}

# Prefixes whose register cannot be derived from the constant name, or that are
# deliberately shared by several registers.
PREFIX_REGISTERS = {
    'RSA2': [0x37],
    'RSA3': [0x38],
    'RSA4': [0x39],
    'RI0':  [0xC4, 0xC8, 0xCC],
    'RI1':  [0xC5, 0xC9, 0xCD],
    'RI2':  [0xC6, 0xCA, 0xCE],
    'RTBA': [0x6E],
    'RTDBA':[0x6F],
    'RPD0': [0x82, 0x86],
    'RPD1': [0x83, 0x87],
    'RPD2': [0x84, 0x88],
    'RPD3': [0x85, 0x89],
    'RSM':  [0x8E],
    'RESPG':[0xA8, 0xA9],
    'RDEP0':[0xB8, 0xB9, 0xBA],
}

# Prefixes that are not nextreg bit values at all.
NON_REGISTER_PREFIXES = {'ROM3'}


def main():
    S = os.path.dirname(os.path.abspath(__file__))
    cfg = os.path.join(S, "../../../libsrc/newlib/target/zxn/config")
    consts = load_z88dk(cfg)
    src = sys.argv[1] if len(sys.argv) > 1 else os.path.join(S, 'nextreg.txt')
    if not os.path.exists(src):
        sys.exit("nextreg.txt not found: %s\nSee the usage note at the top of this script." % src)
    regs = parse_nextreg(src)

    # register number -> z88dk REG_ names
    bynum = {}
    for n, v in consts.items():
        if n.startswith('REG_'): bynum.setdefault(v, []).append(n)
    for v in bynum: bynum[v].sort()

    # prefix -> [(name, value)] for the non-register constants
    byprefix = {}
    for n, v in sorted(consts.items()):
        if n.startswith('REG_') or n.startswith('IO_'): continue
        m = re.match(r"^(R[A-Z0-9]*?)_", n)
        if m: byprefix.setdefault(m.group(1), []).append((n, v))

    used_prefixes = set()
    out = []
    W = out.append
    today = datetime.date.today().isoformat()
    W("# ZX Spectrum Next registers and their z88dk constants\n")
    W("Generated from the ZX Spectrum Next FPGA register reference, annotated with")
    W("the constant names z88dk defines for the `zxn` target.\n")
    W("- Register reference: <https://gitlab.com/SpectrumNext/ZX_Spectrum_Next_FPGA/-/blob/master/cores/zxnext/nextreg.txt>")
    W("- z88dk constants: `libsrc/newlib/target/zxn/config/`, reachable from C and assembler through `<arch/zxn.h>`")
    W(f"- Generated: {today}\n")
    W("In C the constants are used as written here. In assembler the same names carry a")
    W("`__` prefix, so `REG_TILEMAP_CONTROL` is `__REG_TILEMAP_CONTROL`.\n")
    W("Registers with no constant are marked _(none)_ — they are described by the")
    W("hardware reference but z88dk has no name for them yet.\n")

    # ---- summary table
    W("## Register summary\n")
    W("| Register | Name | z88dk constant |")
    W("| --- | --- | --- |")
    for nums, title, body in regs:
        names = [n for num in nums for n in bynum.get(num, [])]
        cell = '<br>'.join('`%s`' % n for n in names) if names else '_(none)_'
        W("| %s | %s | %s |" % (reg_label(nums), title, cell))
    W("")

    # ---- per register detail
    W("## Registers in detail\n")
    for nums, title, body in regs:
        names = [n for num in nums for n in bynum.get(num, [])]
        W("### %s — %s\n" % (reg_label(nums), title))
        if names:
            for n in names: W("**`%s`**\n" % n)
        else:
            W("_No z88dk constant._\n")
        if body:
            W("```")
            for l in body: W(l.rstrip())
            W("```\n")
        # flags belonging to this register
        flags = []
        for p, pnums in PREFIX_REGISTERS.items():
            if set(nums) & set(pnums) and p in byprefix:
                used_prefixes.add(p)
                flags.extend(byprefix[p])
        for rn in names:
            for p in prefixes_for(rn):
                if p in byprefix and p not in used_prefixes and p not in PREFIX_REGISTERS:
                    used_prefixes.add(p)
                    flags.extend(byprefix[p])
        flags = sorted(set(flags))
        if flags:
            W("Value constants:\n")
            W("| Constant | Value |")
            W("| --- | --- |")
            for n, v in flags:
                W("| `%s` | `0x%02X` |" % (n, v))
            W("")

    # ---- anything whose register we could not infer
    leftover = {p: f for p, f in byprefix.items() if p not in used_prefixes}
    if leftover:
        W("## Other value constants\n")
        W("Constants that are not nextreg bit values or whose register could not be")
        W("inferred from the name prefix.\n")
        W("| Constant | Value |")
        W("| --- | --- |")
        for p in sorted(leftover):
            for n, v in leftover[p]:
                W("| `%s` | `0x%02X` |" % (n, v))
        W("")

    sys.stdout.write('\n'.join(out) + '\n')

main()
