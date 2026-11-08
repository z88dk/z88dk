#!/usr/bin/env python3
"""Minimal uPD7801 assembler (the FP-1100's sub-CPU), enough for sub.s.

The encodings are not typed in: they are read back from MAME's unidasm
(env UNIDASM, default ~/emu/mame0283-arm64/unidasm) once; tools/asm7801_ops.json is that table, so
the assembler needs nothing else.  Use unidasm -arch upd7801 to check a result.

Source lines:  [label:] MNEMONIC OPERANDS   ; comment
  numbers: $hex or decimal; a label as an operand is its address
  JR label / JRE label are resolved here (JR: -32..+31 short form).
  ORG n, DB n,..., DW n,...
"""
import json, os, re, subprocess, sys, tempfile

UNIDASM = os.environ.get('UNIDASM', os.path.expanduser('~/emu/mame0283-arm64/unidasm'))
PREFIX = [0x48, 0x4c, 0x4d, 0x60, 0x64, 0x70, 0x74]

def build_table(cache):
    if os.path.exists(cache):
        raw = json.load(open(cache))
        return {eval(k): v for k, v in raw.items()}
    res = {}
    with tempfile.TemporaryDirectory() as d:
        f = os.path.join(d, 't.bin')
        def one(bs):
            open(f, 'wb').write(bytes(bs) + bytes([0x11, 0x22, 0x33]))
            out = subprocess.run([UNIDASM, f, '-arch', 'upd7801', '-basepc', '0x100',
                                  '-norawbytes', '-count', '1'], capture_output=True, text=True).stdout
            return out.strip().splitlines()[0]
        for op in range(256):
            if op in PREFIX:
                for b in range(256):
                    res[(op, b)] = one([op, b])
            else:
                res[(op,)] = one([op])
    json.dump({str(k): v for k, v in res.items()}, open(cache, 'w'))
    return res

def norm(s):
    s = s.split(':', 1)[1].strip() if re.match(r'^[0-9a-f]+:', s) else s
    return re.sub(r'\s+', ' ', s.strip().upper())

class Asm:
    def __init__(self, cache):
        t = build_table(cache)
        self.enc = {}   # (text pattern) -> (bytes, kind)
        for k, v in t.items():
            s = norm(v)
            if 'ILLEGAL' in s or s.startswith(('JR ', 'JRE ', 'CALF', 'CALT', 'JMP', 'CALL')) and False:
                continue
            if 'ILLEGAL' in s:
                continue
            kind = 'none'
            if '$2211' in s:
                kind = 'i16'
            elif '$11' in s:
                kind = 'i8'
            s = s.replace('$2211', '#').replace('$11', '#')
            self.enc.setdefault(s, (bytes(k), kind))

    def assemble(self, src, org=0):
        lines = []
        for ln in src.splitlines():
            ln = ln.split(';', 1)[0].rstrip()
            if not ln.strip():
                continue
            lab = None
            m = re.match(r'^(\w+):\s*(.*)$', ln)
            if m:
                lab, ln = m.group(1), m.group(2)
            lines.append((lab, ln.strip()))
        labels = {}
        for pass_ in (0, 1):
            out = bytearray()
            pc = org
            for lab, ln in lines:
                if lab and pass_ == 0:
                    labels[lab] = pc
                if not ln:
                    continue
                b = self.one(ln, pc, labels, pass_)
                out += b
                pc += len(b)
        return bytes(out), labels

    def val(self, tok, labels, pass_):
        tok = tok.strip()
        m = re.match(r'^(.*?)([+-])(\w+|\$[0-9A-Fa-f]+)$', tok)
        if m and not tok.startswith('$') and not tok.isdigit():
            a = self.val(m.group(1), labels, pass_)
            b = self.val(m.group(3), labels, pass_)
            return a + b if m.group(2) == '+' else a - b
        if tok.startswith('$'):
            return int(tok[1:], 16)
        if re.match(r'^\d+$', tok):
            return int(tok)
        if tok in labels:
            return labels[tok]
        if pass_ == 0:
            return 0
        raise SystemExit('undefined: ' + tok)

    def one(self, ln, pc, labels, pass_):
        parts = ln.split(None, 1)
        mn = parts[0].upper()
        ops = parts[1] if len(parts) > 1 else ''
        if mn == 'ORG':
            target = self.val(ops, labels, pass_)
            return bytes(max(0, target - pc))
        if mn == 'DB':
            return bytes(self.val(x, labels, pass_) & 255 for x in ops.split(','))
        if mn == 'DW':
            r = bytearray()
            for x in ops.split(','):
                v = self.val(x, labels, pass_)
                r += bytes([v & 255, v >> 8 & 255])
            return bytes(r)
        if mn == 'JR':
            t = self.val(ops, labels, pass_)
            d = t - (pc + 1)
            if pass_ and not -32 <= d <= 31:
                raise SystemExit(f'JR out of range at {pc:#x}: {d}')
            return bytes([(0xC0 | d) if d >= 0 else (0xC0 | (d & 0x3F))]) if False else bytes([0xC0 + d if d >= 0 else 0xC0 + (d & 0x3F)])
        if mn == 'JRE':
            t = self.val(ops, labels, pass_)
            d = t - (pc + 2)
            if pass_ and not -256 <= d <= 255:
                raise SystemExit('JRE out of range')
            return bytes([0x4E | 0 if d >= 0 else 0x4F, d & 255]) if False else bytes([0x4E if d >= 0 else 0x4F, d & 255])
        # generic: exact match, else one operand (any position) is an immediate/address
        key = mn + (' ' + ops.upper().replace(' ', '') if ops else '')
        if key in self.enc:
            return self.enc[key][0]
        toks = ops.replace(' ', '').split(',') if ops else []
        for i, t in enumerate(toks):
            p = mn + ' ' + ','.join(toks[:i] + ['#'] + toks[i + 1:])
            p = p.upper()
            if p in self.enc:
                bs, kind = self.enc[p]
                v = self.val(t, labels, pass_)
                return bs + (bytes([v & 255]) if kind == 'i8' else bytes([v & 255, v >> 8 & 255]))
        raise SystemExit(f'cannot assemble: {ln!r}')

if __name__ == '__main__':
    here = os.path.dirname(os.path.abspath(__file__))
    a = Asm(os.path.join(here, 'asm7801_ops.json'))
    src = open(sys.argv[1]).read()
    org = int(sys.argv[2], 0) if len(sys.argv) > 2 else 0
    code, labels = a.assemble(src, org)
    sys.stdout.buffer.write(code) if len(sys.argv) > 3 and sys.argv[3] == '-' else None
    open(os.path.splitext(sys.argv[1])[0] + '.bin', 'wb').write(code)
    for k, v in sorted(labels.items(), key=lambda x: x[1]):
        print(f'{v:04X} {k}')
    print(len(code), 'bytes')
