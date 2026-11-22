#!/usr/bin/env python3
"""Apply zsdcc TIMER results into support/benchmarks readmes.

Updates size, ticks, date, version tags, KWIPS / dhrystone rates.
Does not touch vanilla SDCC / sccz80 / 80cc rows.
"""
from __future__ import annotations

import argparse
import csv
import re
import sys
from pathlib import Path

VERSION = "4.6.0 #16639"
VERSION_TITLE = "zsdcc 4.6.0 #16639"


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def fmt_ticks(n: int | str) -> str:
    s = str(int(n))
    parts: list[str] = []
    while s:
        parts.append(s[-3:])
        s = s[:-3]
    return "_".join(reversed(parts))


def time_human(ticks: int, *, whet: bool = False, seconds_word: bool = False) -> str:
    sec = ticks / 4_000_000.0
    if whet:
        return f"{sec:.4f} seconds"
    if seconds_word and sec < 60:
        return f"{sec:.2f} seconds"
    if sec < 60:
        return f"{sec:5.1f} sec"
    m = int(sec // 60)
    s = sec - 60 * m
    if m < 60:
        return f"{m} min {s:2.0f} sec"
    h = m // 60
    m2 = m % 60
    return f"{h} hr {m2} min"


def time_line(ticks: int, original: str, *, whet: bool = False) -> str:
    slash = "4x10^6" if "4x10^6" in original else "4*10^6"
    seconds_word = "seconds" in original
    human = time_human(ticks, whet=whet or seconds_word, seconds_word=seconds_word)
    if whet or seconds_word:
        return f"time @ 4MHz  = {ticks} / {slash} = {human}"
    mhz = "4MHZ" if "4MHZ" in original else "4MHz"
    return f"time @ {mhz}  = {ticks} / {slash} =  {human}"


def kwips_lines(ticks: int) -> tuple[str, str]:
    sec = ticks / 4_000_000.0
    k = 1000.0 / sec
    return (
        f"KWIPS        = 100*10*1 / {sec:.4f} = {k:.4f}",
        f"MWIPS        = {k:.4f} / 1000 = {k / 1000:.7f}",
    )


def dhry_lines(ticks: int) -> tuple[str, str]:
    sec = ticks / 4_000_000.0
    dps = 20000.0 / sec
    dmips = dps / 1757.0
    return (
        f"dhrystones/s = 20000 / {sec:.2f} = {dps:.4f}",
        f"DMIPS        = {dps:.4f} / 1757 = {dmips:.4f}",
    )


def rewrite_title(title: str) -> str:
    t = re.sub(r"zsdcc(?:\s+Build:)?(?:\s+\d+\.\d+\.\d+)?(?:\s+#\d+)?", VERSION_TITLE, title, count=1)
    t = re.sub(r"  +", " ", t)
    return t.strip()


def load_results(path: Path) -> dict[str, dict[str, str]]:
    rows: dict[str, dict[str, str]] = {}
    with path.open(newline="") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            rid = row.get("id") or ""
            if rid:
                rows[rid] = row
    return rows


def replace_summary(
    text: str,
    compiler: str,
    cpu: str,
    math: str | None,
    ticks: int,
    date_summary: str,
    *,
    kwips: float | None = None,
) -> tuple[str, int]:
    if math and kwips is not None:
        pat = re.compile(
            rf"(^{re.escape(compiler)}\s+\|\s+{re.escape(cpu)}\s+\|\s+{re.escape(math)}\s+\|\s*)"
            rf"([0-9_]+)(\s+\|\s+)([0-9.]+)(\s+\([^)]*\))",
            re.M,
        )

        def repl(m: re.Match[str]) -> str:
            return f"{m.group(1)}{fmt_ticks(ticks)}{m.group(3)}{kwips:.4f}  ({date_summary})"

        return pat.subn(repl, text, count=1)

    if math:
        pat = re.compile(
            rf"(^{re.escape(compiler)}\s+\|\s+{re.escape(cpu)}\s+\|\s+{re.escape(math)}\s+\|\s*)"
            rf"([0-9_]+)([ \t]*(?:\([^)]*\))?)",
            re.M,
        )

        def repl(m: re.Match[str]) -> str:
            return f"{m.group(1)}{fmt_ticks(ticks)} ({date_summary})"

        return pat.subn(repl, text, count=1)

    pat = re.compile(
        rf"(^{re.escape(compiler)}\s+\|\s+{re.escape(cpu)}\s+\|\s*)"
        rf"([0-9_]+)([ \t]*(?:\([^)]*\))?)",
        re.M,
    )

    def repl(m: re.Match[str]) -> str:
        return f"{m.group(1)}{fmt_ticks(ticks)}  ({date_summary})"

    return pat.subn(repl, text, count=1)


def block_end(lines: list[str], i: int) -> int:
    for j in range(i + 1, len(lines)):
        if lines[j].startswith("Z88DK "):
            return j
        if re.match(r"^\d+[a-z]?\.\s*$", lines[j]):
            return j
        if re.match(r"^RESULTS? ", lines[j]):
            return j
    return len(lines)


def replace_result_block(
    text: str,
    title_re: str,
    size: int,
    ticks: int,
    date_full: str,
    *,
    whet: bool = False,
    dhry: bool = False,
    append_cycle: bool = False,
) -> tuple[str, int]:
    lines = text.splitlines(keepends=True)
    title_pat = re.compile(rf"^(?:{title_re})\s*$")
    candidates: list[int] = []
    for i, line in enumerate(lines):
        if title_pat.match(line.rstrip("\n")):
            candidates.append(i)
    if not candidates:
        return text, 0

    chosen = None
    for i in candidates:
        body = "".join(lines[i : block_end(lines, i)])
        if "cycle count" in body or "bytes less page zero" in body:
            chosen = i
            break
    if chosen is None:
        chosen = candidates[-1]

    i = chosen
    for b in range(i, max(-1, i - 4), -1):
        if lines[b].startswith("Z88DK "):
            lines[b] = f"Z88DK {date_full}\n"
            break

    # rewrite title version
    raw = lines[i].rstrip("\n")
    # size embedded in pi new titles: new/zsdcc/small (6299 bytes less page zero)
    if re.search(r"\(\d+ bytes less page zero\)", raw):
        core = re.sub(r"\s*\(\d+ bytes less page zero\)\s*$", "", raw)
        core = rewrite_title(core)
        lines[i] = f"{core} ({size} bytes less page zero)\n"
    else:
        lines[i] = rewrite_title(raw) + "\n"

    j_end = block_end(lines, i)
    last_cycle = None
    for j in range(i, j_end):
        if re.search(r"^\d+ bytes less page zero", lines[j]):
            lines[j] = f"{size} bytes less page zero\n"
        if re.match(r"^cycle count\s*=\s*", lines[j]):
            last_cycle = j
        if lines[j].startswith("time @ 4M") or lines[j].startswith("time @ 4m"):
            lines[j] = time_line(ticks, lines[j], whet=whet) + "\n"
        if whet and lines[j].startswith("KWIPS"):
            kline, _ = kwips_lines(ticks)
            lines[j] = kline + "\n"
        if whet and lines[j].startswith("MWIPS"):
            _, mline = kwips_lines(ticks)
            lines[j] = mline + "\n"
        if dhry and lines[j].startswith("dhrystones/s"):
            dline, _ = dhry_lines(ticks)
            lines[j] = dline + "\n"
        if dhry and lines[j].startswith("DMIPS"):
            _, mline = dhry_lines(ticks)
            lines[j] = mline + "\n"

    if last_cycle is not None:
        if append_cycle:
            # keep history; append a dated line after the last cycle count
            extra = f"cycle count  = {ticks} ({date_full}, ZSDCC {VERSION})\n"
            # avoid duplicating if we already appended
            if extra not in "".join(lines[i:j_end]):
                lines.insert(last_cycle + 1, extra)
        else:
            prefix = re.match(r"^(cycle count\s*=\s*)", lines[last_cycle])
            if prefix:
                lines[last_cycle] = f"{prefix.group(1)}{ticks}\n"
    return "".join(lines), 1


def replace_sort_table(
    text: str,
    title_re: str,
    size: int,
    rows: dict[str, int],
    date_full: str,
) -> tuple[str, int]:
    lines = text.splitlines(keepends=True)
    title_pat = re.compile(rf"^(?:{title_re})\s*$")
    chosen = None
    for i, line in enumerate(lines):
        if title_pat.match(line.rstrip("\n")):
            chosen = i
    if chosen is None:
        return text, 0
    i = chosen
    for b in range(i, max(-1, i - 4), -1):
        if lines[b].startswith("Z88DK "):
            lines[b] = f"Z88DK {date_full}\n"
            break
    lines[i] = rewrite_title(lines[i].rstrip("\n")) + "\n"
    j_end = block_end(lines, i)
    for j in range(i, j_end):
        if re.search(r"^\d+ bytes less page zero", lines[j]):
            lines[j] = f"{size} bytes less page zero\n"
        m = re.match(r"^(sort-(?:ran|ord|rev|equ)-(?:20|5000))\s+(\d+|[A-Z]+)\s+([0-9.]+)\s+sec\s*$", lines[j])
        if m and m.group(1) in rows:
            t = rows[m.group(1)]
            sec = t / 4_000_000.0
            name = m.group(1)
            lines[j] = f"{name:<16}{t:>10}    {sec:7.4f} sec\n"
    return "".join(lines), 1


def job_map() -> dict[str, list[tuple[str, str, dict]]]:
    m: dict[str, list[tuple[str, str, dict]]] = {}

    def add(jid: str, *entries: tuple[str, str, dict]) -> None:
        m.setdefault(jid, []).extend(entries)

    # binary-trees
    add(
        "bt_c",
        ("support/benchmarks/binary-trees/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math48")),
        ("support/benchmarks/binary-trees/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library")),
        ("support/benchmarks/binary-trees/z88dk-classic/readme.txt", "result", dict(title=r"classic / zsdcc #\d+")),
    )
    add(
        "bt_n",
        ("support/benchmarks/binary-trees/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library")),
        ("support/benchmarks/binary-trees/z88dk-new/readme.txt", "result", dict(title=r"new/zsdcc #\d+")),
    )

    # dhrystone
    add(
        "dh_c",
        ("support/benchmarks/dhrystone21/readme.txt", "result", dict(title=r"classic/zsdcc #\d+", dhry=True)),
        ("support/benchmarks/dhrystone21/z88dk-classic/readme.txt", "result", dict(title=r"classic/zsdcc #\d+", dhry=True)),
    )
    add(
        "dh_n",
        ("support/benchmarks/dhrystone21/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library", dhry=True)),
        ("support/benchmarks/dhrystone21/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library", dhry=True)),
    )

    # fannkuch
    add(
        "fk_c",
        ("support/benchmarks/fannkuch/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80")),
        ("support/benchmarks/fannkuch/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library")),
        ("support/benchmarks/fannkuch/z88dk-classic/readme.txt", "result", dict(title=r"classic/zsdcc #\d+")),
    )
    add(
        "fk_n",
        ("support/benchmarks/fannkuch/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library")),
        ("support/benchmarks/fannkuch/z88dk-new/readme.txt", "result", dict(title=r"new/zsdcc #\d+")),
    )

    # fasta
    add(
        "fa_c",
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library")),
        ("support/benchmarks/fasta/z88dk-classic/readme.txt", "result", dict(title=r"classic/zsdcc #\d+")),
    )
    add(
        "fa_c_m32",
        ("support/benchmarks/fasta/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32")),
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"zsdcc(?: #\d+)? / classic c library / math32")),
    )
    add(
        "fa_n",
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library")),
        ("support/benchmarks/fasta/z88dk-new/readme.txt", "result", dict(title=r"new/zsdcc #\d+")),
    )

    # mandelbrot
    add(
        "md_c",
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library")),
        ("support/benchmarks/mandelbrot/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic")),
    )
    add(
        "md_c_m32",
        ("support/benchmarks/mandelbrot/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32")),
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"zsdcc(?: #\d+)? / classic c library / math32")),
        ("support/benchmarks/mandelbrot/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic / math32")),
    )
    add(
        "md_n",
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library")),
        ("support/benchmarks/mandelbrot/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new")),
    )
    add(
        "md_n_m32",
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library / math32")),
        ("support/benchmarks/mandelbrot/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new / math32")),
    )

    # n-body
    add(
        "nb_c",
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic")),
        ("support/benchmarks/n-body/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic")),
    )
    add(
        "nb_c_m32",
        ("support/benchmarks/n-body/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32")),
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"zsdcc / classic / math32")),
    )
    add(
        "nb_n",
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library")),
        ("support/benchmarks/n-body/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new")),
    )
    add(
        "nb_n_m32",
        ("support/benchmarks/n-body/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new / math32")),
    )

    # pi
    add(
        "pi_c",
        ("support/benchmarks/pi/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80")),
        ("support/benchmarks/pi/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library")),
        ("support/benchmarks/pi/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library")),
    )
    add(
        "pi_n_small",
        ("support/benchmarks/pi/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library / small int math")),
        ("support/benchmarks/pi/z88dk-new/readme.txt", "result", dict(title=r"new/zsdcc/small \(\d+ bytes less page zero\)", append_cycle=True)),
    )

    # sieve
    add(
        "sv_c",
        ("support/benchmarks/sieve/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80")),
        ("support/benchmarks/sieve/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library")),
        ("support/benchmarks/sieve/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library")),
    )
    add(
        "sv_n",
        ("support/benchmarks/sieve/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library")),
        ("support/benchmarks/sieve/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library")),
    )

    # spectral
    add(
        "sn_c_m48",
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library / math48")),
        ("support/benchmarks/spectral-norm/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc #\d+ / classic c library / math48")),
    )
    add(
        "sn_c_m32",
        ("support/benchmarks/spectral-norm/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32")),
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"zsdcc(?: #\d+)? / classic c library / math32")),
        ("support/benchmarks/spectral-norm/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc(?: #\d+)? / classic c library / math32")),
    )
    add(
        "sn_n",
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library")),
        ("support/benchmarks/spectral-norm/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library")),
    )
    add(
        "sn_n_m32",
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library / math32")),
        ("support/benchmarks/spectral-norm/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library / math32")),
    )

    # whetstone
    add(
        "wh_c_m48",
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"classic/zsdcc #\d+/math48", whet=True)),
        ("support/benchmarks/whetstone/z88dk-classic/readme.txt", "result", dict(title=r"classic/zsdcc #\d+/math48", whet=True)),
    )
    add(
        "wh_c_m32",
        ("support/benchmarks/whetstone/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32", whet=True)),
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"zsdcc / classic c library / math32", whet=True)),
    )
    add(
        "wh_n_m48",
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library / math48", whet=True)),
        ("support/benchmarks/whetstone/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library / math48", whet=True)),
    )
    add(
        "wh_n_m32",
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library / math32", whet=True)),
        ("support/benchmarks/whetstone/z88dk-new/readme.txt", "result", dict(title=r"zsdcc #\d+ / new c library / math32", whet=True)),
    )

    return m


def apply_sort(root: Path, rows: dict[str, dict[str, str]], date_full: str, file_text: dict[Path, str]) -> int:
    names = {
        "so_c_ran_20": "sort-ran-20",
        "so_c_ord_20": "sort-ord-20",
        "so_c_rev_20": "sort-rev-20",
        "so_c_equ_20": "sort-equ-20",
        "so_c_ran_5000": "sort-ran-5000",
        "so_c_ord_5000": "sort-ord-5000",
        "so_c_rev_5000": "sort-rev-5000",
        "so_c_equ_5000": "sort-equ-5000",
    }
    table: dict[str, int] = {}
    sizes_20: list[int] = []
    for jid, name in names.items():
        r = rows.get(jid)
        if not r or r.get("status") != "ok" or not r.get("ticks"):
            continue
        table[name] = int(r["ticks"])
        if name.endswith("-20") and r.get("size"):
            sizes_20.append(int(r["size"]))
    if len(table) < 8:
        print(f"sort classic incomplete ({len(table)}/8)", file=sys.stderr)
        if not table:
            return 0
    size = max(sizes_20) if sizes_20 else 0
    n = 0
    for rel, title in (
        ("support/benchmarks/sorting/z88dk-classic/readme.txt", r"classic / zsdcc Build: .*"),
        ("support/benchmarks/sorting/readme.txt", r"zsdcc #\d+ / classic c library / shellsort"),
    ):
        path = root / rel
        if path not in file_text:
            file_text[path] = path.read_text()
        new, k = replace_sort_table(file_text[path], title, size, table, date_full)
        if k == 0:
            print(f"sort miss {rel} / {title}", file=sys.stderr)
        else:
            file_text[path] = new
            n += k
    return n


def apply(
    root: Path,
    results: Path,
    date_full: str,
    date_summary: str,
    *,
    dry_run: bool,
    list_only: bool,
) -> int:
    rows = load_results(results)
    ok = {
        k: v
        for k, v in rows.items()
        if v.get("status") == "ok" and v.get("ticks") and v.get("size")
    }
    print(f"results: {len(rows)} rows, {len(ok)} ok with size+ticks", file=sys.stderr)
    if list_only:
        for k, v in sorted(ok.items()):
            print(f"{k}\t{v['size']}\t{v['ticks']}\t{fmt_ticks(v['ticks'])}")
        return 0

    jmap = job_map()
    file_text: dict[Path, str] = {}
    stats = {"jobs": 0, "summary": 0, "result": 0, "miss_map": 0, "miss_pat": 0}

    # pi_ldiv parent small title is the second match of the same regex —
    # handle child via append; parent ldiv block is under RESULTS - PI_LDIV
    # Apply pi_n_small first (pi.c section), then do a targeted second pass
    # for parent ldiv by unique following context. Simpler: only child for ldiv
    # plus a dedicated parent title that appears in the ldiv section. Both
    # parent titles are identical strings. We'll update the last match for ldiv
    # by temporarily renaming... skip: replace_result_block uses first cycle-count
    # match. For parent ldiv, first "zsdcc #NNNN / new c library / small int math"
    # is pi.c. So map pi_n_small_ldiv only to child; parent ldiv updated below.

    for jid, row in sorted(ok.items()):
        entries = jmap.get(jid)
        if not entries:
            if jid.startswith("so_c_") or jid in ("fa_n_m32", "pi_n_small_ldiv"):
                continue
            print(f"skip unmapped job: {jid}", file=sys.stderr)
            stats["miss_map"] += 1
            continue
        stats["jobs"] += 1
        size = int(row["size"])
        ticks = int(row["ticks"])
        for path_rel, kind, kw in entries:
            # parent pi ldiv: skip generic small title on parent for ldiv job
            if jid == "pi_n_small_ldiv" and path_rel.endswith("pi/readme.txt"):
                continue
            path = root / path_rel
            if path not in file_text:
                if not path.is_file():
                    print(f"missing file: {path}", file=sys.stderr)
                    continue
                file_text[path] = path.read_text()
            text = file_text[path]
            if kind == "summary":
                karg = None
                if kw.get("whet"):
                    karg = 1000.0 / (ticks / 4_000_000.0)
                new, n = replace_summary(
                    text,
                    kw["compiler"],
                    kw["cpu"],
                    kw.get("math"),
                    ticks,
                    date_summary,
                    kwips=karg,
                )
                if n == 0:
                    print(f"summary miss {jid} → {path_rel}", file=sys.stderr)
                    stats["miss_pat"] += 1
                else:
                    stats["summary"] += n
                    file_text[path] = new
            elif kind == "result":
                new, n = replace_result_block(
                    text,
                    kw["title"],
                    size,
                    ticks,
                    date_full,
                    whet=bool(kw.get("whet")),
                    dhry=bool(kw.get("dhry")),
                    append_cycle=bool(kw.get("append_cycle")),
                )
                if n == 0:
                    print(f"result miss {jid} → {path_rel} / {kw['title']}", file=sys.stderr)
                    stats["miss_pat"] += 1
                else:
                    stats["result"] += n
                    file_text[path] = new

    # pi_ldiv blocks sit after a PI_LDIV heading in parent and child
    if "pi_n_small_ldiv" in ok:
        size = int(ok["pi_n_small_ldiv"]["size"])
        ticks = int(ok["pi_n_small_ldiv"]["ticks"])
        for rel, marker, title in (
            (
                "support/benchmarks/pi/readme.txt",
                "RESULTS - PI_LDIV.C (LDIV USED)",
                r"zsdcc #\d+ / new c library / small int math",
            ),
            (
                "support/benchmarks/pi/z88dk-new/readme.txt",
                "PI_LDIV.C",
                r"new/zsdcc/small \(\d+ bytes less page zero\)",
            ),
        ):
            path = root / rel
            if path not in file_text:
                file_text[path] = path.read_text()
            text = file_text[path]
            if marker not in text:
                print(f"result miss pi_n_small_ldiv marker {rel}", file=sys.stderr)
                stats["miss_pat"] += 1
                continue
            head, tail = text.split(marker, 1)
            new_tail, n = replace_result_block(
                tail,
                title,
                size,
                ticks,
                date_full,
                append_cycle=rel.endswith("z88dk-new/readme.txt"),
            )
            if n:
                file_text[path] = head + marker + new_tail
                stats["result"] += n
            else:
                print(f"result miss pi_n_small_ldiv {rel}", file=sys.stderr)
                stats["miss_pat"] += 1

    stats["result"] += apply_sort(root, rows, date_full, file_text)

    print(
        f"applied jobs={stats['jobs']} summary={stats['summary']} "
        f"result={stats['result']} miss_map={stats['miss_map']} "
        f"miss_pat={stats['miss_pat']}",
        file=sys.stderr,
    )
    if dry_run:
        print("dry-run: no files written", file=sys.stderr)
        return 0 if stats["miss_pat"] == 0 else 1
    for path, text in sorted(file_text.items()):
        path.write_text(text)
        print(f"wrote {path.relative_to(root)}", file=sys.stderr)
    return 0 if stats["miss_pat"] == 0 else 1


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--root", type=Path, default=None)
    ap.add_argument("--results", type=Path, required=True)
    ap.add_argument("--date", default="August 16, 2026")
    ap.add_argument("--date-summary", default="Aug 16, 2026")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--list", action="store_true")
    args = ap.parse_args(argv)
    root = args.root or repo_root()
    return apply(
        root,
        args.results,
        args.date,
        args.date_summary,
        dry_run=args.dry_run or args.list,
        list_only=args.list,
    )


if __name__ == "__main__":
    sys.exit(main())
