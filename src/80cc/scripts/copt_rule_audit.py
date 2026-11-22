#!/usr/bin/env python3
"""copt rule audit: simulate each rule's pattern and replacement on an abstract
Z80 state (registers, flags, stack, memory writes) and report what differs at
the end of the match.

  EQUAL   the replacement leaves exactly the original's state: sound anywhere.
  DIFF x  the replacement leaves x different, so the rule assumes x is dead
          after the match. copt cannot know that, and the lowerer's register
          cache may read x next (copt #DE7 left DE stale; an f32->int result
          squared went to l_mult with the wrong DE). Each DIFF needs a reason:
          x is junk in the original too (a clobbered A, flags), or the pattern
          itself overwrites it, or the simulator cannot model it (%eval
          offsets, ex (sp),hl, inc sp).
  MANUAL  an instruction the simulator does not model.

Wildcards are instantiated over registers, an immediate, a symbol and (hl) /
(ix+d); %not and %is constraints are honoured. -v names an instantiation that
shows each difference.

Usage: copt_rule_audit.py lib/80cc_rules.1 [-v]
"""
import re, sys

R8 = ["a", "b", "c", "d", "e", "h", "l", "ixh", "ixl", "iyh", "iyl"]
PAIRS = {"bc": ("b", "c"), "de": ("d", "e"), "hl": ("h", "l"),
         "ix": ("ixh", "ixl"), "iy": ("iyh", "iyl"), "af": ("a", "f")}


class Unknown(Exception):
    pass


class St:
    def __init__(self):
        self.r = {x: "r_" + x for x in R8 + ["f"]}
        self.stack = []          # pushed values (pairs of tokens), top last
        self.popped = 0          # pops below the initial stack
        self.sp = 0              # net sp delta (bytes)
        self.mem = []            # (addr-expr, value) writes, in order
        self.n = 0
        self.ctl = []            # control-flow ops, in order

    def fresh(self, tag):
        self.n += 1
        return f"{tag}#{self.n}"

    def get16(self, rp):
        h, l = PAIRS[rp]
        return (self.r[h], self.r[l])

    def set16(self, rp, v):
        h, l = PAIRS[rp]
        self.r[h], self.r[l] = v


def norm(ins):
    ins = ins.split(";")[0].strip()
    ins = re.sub(r"\s+", " ", ins)
    ins = ins.replace(", ", ",")
    return ins


def val16(st, x):
    x = x.strip()
    if x in PAIRS and x != "af":
        return st.get16(x)
    if x == "sp":
        return (f"sph{st.sp}", f"spl{st.sp}")
    return (f"hi({x})", f"lo({x})")


def mem_read(st, addr):
    for a, v in reversed(st.mem):
        if a == addr:
            return v
    return f"mem[{addr}]"


def addr_expr(st, inner):
    inner = inner.strip()
    m = re.fullmatch(r"(hl|de|bc)", inner)
    if m:
        h, l = PAIRS[inner]
        return f"[{st.r[h]}:{st.r[l]}]"
    m = re.fullmatch(r"(ix|iy)([+-].*)?", inner)
    if m:
        h, l = PAIRS[m.group(1)]
        return f"[{st.r[h]}:{st.r[l]}{m.group(2) or ''}]"
    m = re.fullmatch(r"sp\+?(.*)", inner)
    if m:
        return f"[sp{st.sp}+{m.group(1) or 0}]"
    return f"[{inner}]"


def step(st, ins):
    if not ins:
        return
    if ins.endswith(":"):
        st.ctl.append(("label", ins))
        return
    m = re.match(r"(\S+)\s*(.*)", ins)
    op, args = m.group(1).lower(), m.group(2)
    a = [x.strip() for x in args.split(",")] if args else []
    al = [x.lower() for x in a]
    F = lambda tag: st.fresh("f:" + tag)
    if op in ("jp", "jr", "call", "ret", "djnz", "rst", "reti", "halt"):
        # control flow: the state at this point is observable
        st.ctl.append((op, args, dict(st.r), tuple(st.stack), st.sp, tuple(st.mem)))
        if op == "call" or op == "rst":
            raise Unknown("call")
        if op == "djnz":
            st.r["b"] = st.fresh("b")
        return
    if op == "nop":
        return
    if op == "ld":
        d, s = al[0], al[1]
        # 16-bit register moves (incl. synthetic ld rr,rr)
        if d in PAIRS and d != "af":
            if s in PAIRS and s != "af":
                st.set16(d, st.get16(s)); return
            if s.startswith("(") and s.endswith(")"):
                ad = addr_expr(st, s[1:-1])
                st.set16(d, (mem_read(st, ad + "+1"), mem_read(st, ad))); return
            if s == "sp" or s.startswith("sp+"):
                st.set16(d, (st.fresh("sph"), st.fresh("spl"))); return
            st.set16(d, val16(st, s)); return
        if d == "sp":
            st.sp = st.fresh("sp"); return
        if d.startswith("(") and d.endswith(")"):
            ad = addr_expr(st, d[1:-1])
            if s in PAIRS:
                h, l = st.get16(s)
                st.mem.append((ad, l)); st.mem.append((ad + "+1", h)); return
            if s in st.r:
                st.mem.append((ad, st.r[s])); return
            st.mem.append((ad, f"imm({s})")); return
        if d in st.r:
            if s in st.r:
                st.r[d] = st.r[s]; return
            if s.startswith("(") and s.endswith(")"):
                inner = s[1:-1]
                post = inner.endswith("+") or inner.endswith("-")
                if post:
                    base = inner[:-1]
                    ad = addr_expr(st, base)
                    st.r[d] = mem_read(st, ad)
                    st.set16("hl", (st.fresh("h"), st.fresh("l")))
                    return
                st.r[d] = mem_read(st, addr_expr(st, inner)); return
            st.r[d] = f"imm({s})"; return
        raise Unknown(ins)
    if op == "ex":
        if set(al) == {"de", "hl"}:
            de, hl = st.get16("de"), st.get16("hl")
            st.set16("de", hl); st.set16("hl", de); return
        if al[0] == "(sp)":
            raise Unknown(ins)
        raise Unknown(ins)
    if op == "push":
        st.stack.append(st.get16(al[0]) if al[0] != "af" else (st.r["a"], st.r["f"]))
        st.sp = st.sp - 2 if isinstance(st.sp, int) else st.sp
        return
    if op == "pop":
        if st.stack:
            v = st.stack.pop()
        else:
            st.popped += 1
            v = (f"stk{st.popped}h", f"stk{st.popped}l")
        if al[0] == "af":
            st.r["a"], st.r["f"] = v
        else:
            st.set16(al[0], v)
        st.sp = st.sp + 2 if isinstance(st.sp, int) else st.sp
        return
    if op in ("inc", "dec") and al and al[0] == "sp":
        if st.stack:
            # discarding half a pushed word: model as an opaque stack change
            v = st.stack.pop()
            st.stack.append((v[0], st.fresh("half")) if op == "inc" else v)
        st.sp = st.sp + (1 if op == "inc" else -1) if isinstance(st.sp, int) else st.sp
        if op == "inc":
            st.halfpop = getattr(st, "halfpop", 0) + 1
        return
    if op in ("inc", "dec"):
        x = al[0]
        if x in PAIRS:
            h, l = st.get16(x)
            st.set16(x, (f"{op}16h({h}:{l})", f"{op}16l({h}:{l})")); return
        if x in st.r:
            st.r[x] = f"{op}({st.r[x]})"; st.r["f"] = F(op); return
        if x.startswith("("):
            ad = addr_expr(st, x[1:-1]); st.mem.append((ad, f"{op}({mem_read(st, ad)})")); st.r["f"] = F(op); return
        raise Unknown(ins)
    if op in ("add", "adc", "sbc", "sub") and al and al[0] in ("hl", "ix", "iy"):
        h, l = st.get16(al[0]); s = val16(st, al[1])
        st.set16(al[0], (f"{op}h({h}{l},{s})", f"{op}l({h}{l},{s})")); st.r["f"] = F(op); return
    if op in ("add", "adc", "sub", "sbc", "and", "or", "xor", "cp"):
        src = al[-1]
        if src in st.r: v = st.r[src]
        elif src.startswith("("): v = mem_read(st, addr_expr(st, src[1:-1]))
        else: v = f"imm({src})"
        if op == "xor" and src == "a": st.r["a"] = "imm(0)"
        elif op in ("and", "or") and src == "a": pass
        elif op != "cp": st.r["a"] = f"{op}({st.r['a']},{v})"
        st.r["f"] = F(f"{op}:{st.r['a']}:{v}"); return
    if op in ("rla", "rra", "rlca", "rrca", "cpl", "neg", "scf", "ccf", "daa"):
        if op not in ("scf", "ccf"):
            st.r["a"] = f"{op}({st.r['a']})"
        st.r["f"] = F(op); return
    if op in ("rl", "rr", "rlc", "rrc", "sla", "sra", "srl", "sli", "swap"):
        x = al[0]
        if x in st.r: st.r[x] = f"{op}({st.r[x]})"; st.r["f"] = F(op); return
        raise Unknown(ins)
    if op in ("bit",):
        st.r["f"] = F(f"bit:{args}"); return
    if op in ("set", "res"):
        x = al[1]
        if x in st.r: st.r[x] = f"{op}{al[0]}({st.r[x]})"; return
        raise Unknown(ins)
    raise Unknown(ins)


def final(seq):
    st = St()
    for ins in seq:
        step(st, norm(ins))
    return st


def diff(s1, s2):
    out = []
    for k in R8 + ["f"]:
        if s1.r[k] != s2.r[k]:
            out.append(k)
    if s1.stack != s2.stack or s1.sp != s2.sp or s1.popped != s2.popped \
            or getattr(s1, "halfpop", 0) != getattr(s2, "halfpop", 0):
        out.append("stack")
    if [m for m in s1.mem] != [m for m in s2.mem]:
        if sorted(s1.mem) != sorted(s2.mem):
            out.append("memory")
    return out


def parse(path):
    rules, cur, part = [], None, None
    for raw in open(path):
        line = raw.rstrip("\n")
        if line.startswith("%title"):
            cur = {"title": line[7:].strip(), "pat": [], "rep": [], "dir": []}
            rules.append(cur); part = "pat"; continue
        if cur is None:
            continue
        if line.startswith(";;"):
            continue
        if line.startswith("%"):
            cur["dir"].append(line); continue
        if line.strip() == "=":
            part = "rep"; continue
        if not line.strip():
            if part == "rep":
                cur = None
            continue
        cur[part].append(line.strip())
    return rules


def mask_dead_in_pattern(diffs, pat):
    """A register the replacement leaves different is harmless only if it is
    dead: we cannot see past the pattern, so report it unless the pattern's
    last instructions overwrite it (then both sides agree anyway)."""
    return diffs


import itertools
CAND = ["hl", "de", "bc", "ix", "a", "b", "c", "d", "e", "h", "l", "7", "_sym", "ix+4", "(hl)"]

def expand_alts(lines):
    """%"x|y"N alternation -> list of (lines, binding) variants."""
    alts = {}
    for l in lines:
        for m in re.finditer(r'%"([^"]*)"(\d+)', l):
            alts[m.group(2)] = m.group(1).split("|")
    return alts

def instantiate(r):
    text = r["pat"] + r["rep"]
    alts = expand_alts(text)
    wild = sorted(set(re.findall(r"%(\d+)", " ".join(re.sub(r'%"[^"]*"\d+', "", l) for l in text))) - set(alts))
    choices = [alts[k] for k in sorted(alts)] + [CAND for _ in wild]
    keys = sorted(alts) + wild
    n = 1
    for c in choices: n *= len(c)
    combos = itertools.product(*choices) if n <= 4000 else itertools.islice(itertools.product(*choices), 4000)
    cons = []
    for d in r["dir"]:
        t = d.split()
        if t[0] in ("%not", "%is") and len(t) > 2 and t[1].startswith("%"):
            vals = [x.strip('"') for x in re.findall(r'"[^"]*"|\S+', " ".join(t[2:]))]
            cons.append((t[0], t[1][1:], vals))
    def allowed(b):
        for kind, k, vals in cons:
            v = b.get(k)
            if v is None: continue
            hit = any(v == x or re.fullmatch(x, v) for x in vals)
            if kind == "%not" and hit: return False
            if kind == "%is" and not hit: return False
        return True
    for combo in combos:
        b = dict(zip(keys, combo))
        if not allowed(b): continue
        def sub(l):
            l = re.sub(r'%"[^"]*"(\d+)', lambda m: b[m.group(1)], l)
            return re.sub(r"%(\d+)", lambda m: b.get(m.group(1), "_x" + m.group(1)), l)
        yield b, [sub(l) for l in r["pat"]], [sub(l) for l in r["rep"]]

if __name__ == "__main__":
    rules = parse(sys.argv[1])
    for i, r in enumerate(rules):
        diffs, ok, manual, ctl, examples = set(), 0, set(), False, {}
        for b, pat, rep in instantiate(r):
            try:
                a, c = final(pat), final(rep)
            except (Unknown, KeyError, ValueError, IndexError, TypeError) as e:
                manual.add(str(e)[:30]); continue
            ok += 1
            d = diff(a, c)
            for x in d:
                if x not in examples: examples[x] = b
            diffs |= set(d)
            if [q[0] for q in a.ctl] != [q[0] for q in c.ctl]: ctl = True
        cons = " +constraints" if any(x.split()[0] in ("%check", "%eval", "%is", "%not") for x in r["dir"]) else ""
        if ok == 0:
            verdict = "MANUAL (" + ",".join(sorted(manual))[:40] + ")"
        elif diffs or ctl:
            verdict = "DIFF " + ",".join(sorted(diffs)) + (" CTL" if ctl else "")
        else:
            verdict = "EQUAL"
        print(f"{i+1:3d} {verdict:44s}{cons:13s} {r['title'][:80]}")
        if diffs and "-v" in sys.argv:
            for x, b in examples.items(): print(f"        {x}: e.g. {b}")
