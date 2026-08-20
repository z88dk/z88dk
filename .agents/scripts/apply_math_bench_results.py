#!/usr/bin/env python3
"""Apply math16/math32 TIMER results into support/benchmarks readmes.

Reads a TSV from run_math_benches.sh (columns:
  id bench clib compiler cpu math size ticks status wall_s)

Policy (methodology-measure skill):
  - Update size + ticks + date only on existing RESULT / SUMMARY rows
  - No new prose unless documenting a known exception
  - math16 TIMER rows must be pure (no --math16 --math32 pollution)

Usage (from z88dk root, after a matrix run):

  python3 .agents/scripts/apply_math_bench_results.py \\
    --results /tmp/z88dk-bench-YYYYMMDD/results.tsv \\
    --date 'August 9, 2026' \\
    --date-summary 'Aug 9, 2026'

  python3 .agents/scripts/apply_math_bench_results.py --dry-run ...
  python3 .agents/scripts/apply_math_bench_results.py --list   # print ok rows only
"""
from __future__ import annotations

import argparse
import csv
import re
import sys
from pathlib import Path


def repo_root() -> Path:
    here = Path(__file__).resolve()
    # .agents/scripts/this.py → repo root
    return here.parents[2]


def fmt_ticks(n: int | str) -> str:
    s = str(int(n))
    parts: list[str] = []
    while s:
        parts.append(s[-3:])
        s = s[:-3]
    return "_".join(reversed(parts))


def time_human(ticks: int, *, whet: bool = False) -> str:
    sec = ticks / 4_000_000.0
    if whet:
        return f"{sec:.4f} seconds"
    if sec < 60:
        return f"{sec:5.1f} sec"
    m = int(sec // 60)
    s = sec - 60 * m
    if m < 60:
        return f"{m} min {s:2.0f} sec"
    h = m // 60
    m2 = m % 60
    return f"{h} hr {m2} min"


def time_line(ticks: int, *, whet: bool = False) -> str:
    if whet:
        return f"time @ 4MHz  = {ticks} / 4x10^6 = {time_human(ticks, whet=True)}"
    return f"time @ 4MHz  = {ticks} / 4*10^6 =  {time_human(ticks)}"


def kwips_lines(ticks: int) -> tuple[str, str]:
    sec = ticks / 4_000_000.0
    k = 1000.0 / sec
    return (
        f"KWIPS        = 100*10*1 / {sec:.4f} = {k:.4f}",
        f"MWIPS        = {k:.4f} / 1000 = {k / 1000:.7f}",
    )


def load_results(path: Path) -> dict[str, dict[str, str]]:
    rows: dict[str, dict[str, str]] = {}
    with path.open(newline="") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            rid = row.get("id") or ""
            if rid:
                rows[rid] = row
    return rows


def replace_summary_tick(
    text: str,
    compiler: str,
    cpu: str,
    math: str,
    ticks: int,
    date_summary: str,
    *,
    kwips: float | None = None,
) -> tuple[str, int]:
    """Update CLASSIC SUMMARY table tick (and optional KWIPS) lines."""
    if kwips is not None:
        # sccz80   | z80  | math32  | 524_709_425     | 7.6233  (Jul 31, 2026)
        pat = re.compile(
            rf"(^{re.escape(compiler)}\s+\|\s+{re.escape(cpu)}\s+\|\s+{re.escape(math)}\s+\|\s*)"
            rf"([0-9_]+)(\s+\|\s+)([0-9.]+)(\s+\([^)]*\))",
            re.M,
        )

        def repl(m: re.Match[str]) -> str:
            return (
                f"{m.group(1)}{fmt_ticks(ticks)}{m.group(3)}"
                f"{kwips:.4f}  ({date_summary})"
            )

        return pat.subn(repl, text, count=1)

    pat = re.compile(
        rf"(^{re.escape(compiler)}\s+\|\s+{re.escape(cpu)}\s+\|\s+{re.escape(math)}\s+\|\s*)"
        rf"([0-9_]+)(\s*\([^)]*\))",
        re.M,
    )

    def repl(m: re.Match[str]) -> str:
        old_note = m.group(3)
        if "DT=" in old_note:
            note = f" ({date_summary}; DT=1e-1)"
        else:
            note = f" ({date_summary})"
        return f"{m.group(1)}{fmt_ticks(ticks)}{note}"

    return pat.subn(repl, text, count=1)


def replace_result_block(
    text: str,
    title_re: str,
    size: int,
    ticks: int,
    date_full: str,
    *,
    whet: bool = False,
) -> tuple[str, int]:
    """Update one RESULT block whose title line matches title_re.

    Prefer a match that is followed by a ``cycle count`` line (RESULT body).
    Recipe-only title lines (compile command lists) are skipped so the first
    hit is not a non-RESULT occurrence of the same label.
    """
    lines = text.splitlines(keepends=True)
    # Match whole title line (strip); avoid accidental substring hits.
    title_pat = re.compile(rf"^(?:{title_re})\s*$")

    def block_end(i: int) -> int:
        j_end = len(lines)
        for j in range(i + 1, len(lines)):
            if lines[j].startswith("Z88DK "):
                return j
            if re.match(r"^\d+[a-z]?\.\s*$", lines[j]):
                return j
        return j_end

    def has_cycle_count(i: int, j_end: int) -> bool:
        for j in range(i, j_end):
            if re.match(r"^cycle count\s*=\s*\d+\s*$", lines[j]):
                return True
        return False

    # Collect candidate title lines; prefer ones with a cycle-count body.
    candidates: list[int] = []
    for i, line in enumerate(lines):
        if title_pat.match(line.rstrip("\n")):
            candidates.append(i)
    if not candidates:
        return text, 0

    chosen = None
    for i in candidates:
        if has_cycle_count(i, block_end(i)):
            chosen = i
            break
    if chosen is None:
        # No RESULT body for this title (summary-only / recipe-only).
        return text, 0

    i = chosen
    for b in range(i, max(-1, i - 4), -1):
        if lines[b].startswith("Z88DK "):
            lines[b] = f"Z88DK {date_full}\n"
            break
    j_end = block_end(i)
    for j in range(i, j_end):
        if re.search(r"^\d+ bytes less page zero", lines[j]):
            lines[j] = f"{size} bytes less page zero\n"
        m = re.match(r"^(cycle count\s*=\s*)\d+\s*$", lines[j])
        if m:
            lines[j] = f"{m.group(1)}{ticks}\n"
        if lines[j].startswith("time @ 4MHz"):
            lines[j] = time_line(ticks, whet=whet) + "\n"
        if whet and lines[j].startswith("KWIPS"):
            kline, _ = kwips_lines(ticks)
            lines[j] = kline + "\n"
        if whet and lines[j].startswith("MWIPS"):
            _, mline = kwips_lines(ticks)
            lines[j] = mline + "\n"
    return "".join(lines), 1


# job_id → list of (path_rel, kind, kwargs)
# kind: summary | result
# summary kwargs: compiler, cpu, math [, whet]
# result kwargs: title (regex), whet optional
def job_map() -> dict[str, list[tuple[str, str, dict]]]:
    m: dict[str, list[tuple[str, str, dict]]] = {}

    def add(jid: str, *entries: tuple[str, str, dict]) -> None:
        m.setdefault(jid, []).extend(entries)

    # --- n-body classic ---
    add(
        "nb_c_sccz80_z80_m32",
        ("support/benchmarks/n-body/readme.txt", "summary", dict(compiler="sccz80", cpu="z80", math="math32")),
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"sccz80 / classic / math32")),
        ("support/benchmarks/n-body/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic / math32")),
    )
    add(
        "nb_c_sccz80_8085_m32",
        ("support/benchmarks/n-body/readme.txt", "summary", dict(compiler="sccz80", cpu="8085", math="math32")),
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"sccz80 / classic / 8085 / math32")),
        ("support/benchmarks/n-body/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic / 8085 / math32")),
    )
    add(
        "nb_c_zsdcc_z80_m32",
        ("support/benchmarks/n-body/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32")),
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"zsdcc / classic / math32")),
        # Never match historical "zsdcc #12070 / classic" (math48-era April 2021).
        ("support/benchmarks/n-body/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc / classic / math32")),
    )
    add(
        "nb_c_sccz80_z80_m16",
        ("support/benchmarks/n-body/readme.txt", "summary", dict(compiler="sccz80", cpu="z80", math="math16")),
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"sccz80 / classic / math16")),
        ("support/benchmarks/n-body/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic / math16")),
    )
    add(
        "nb_c_sccz80_8085_m16",
        ("support/benchmarks/n-body/readme.txt", "summary", dict(compiler="sccz80", cpu="8085", math="math16")),
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"sccz80 / classic / 8085 / math16")),
        ("support/benchmarks/n-body/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic / 8085 / math16")),
    )
    add(
        "nb_c_80cc_z80_m32",
        ("support/benchmarks/n-body/readme.txt", "summary", dict(compiler="80cc", cpu="z80", math="math32")),
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"80cc / classic / math32")),
        ("support/benchmarks/n-body/z88dk-classic/readme.txt", "result", dict(title=r"80cc / classic / math32")),
    )
    add(
        "nb_c_80cc_8085_m32",
        ("support/benchmarks/n-body/readme.txt", "summary", dict(compiler="80cc", cpu="8085", math="math32")),
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"80cc / classic / 8085 / math32")),
        ("support/benchmarks/n-body/z88dk-classic/readme.txt", "result", dict(title=r"80cc / classic / 8085 / math32")),
    )
    # n-body new
    add(
        "nb_n_sccz80_z80_m32",
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"sccz80 / new c library / math32")),
        ("support/benchmarks/n-body/z88dk-new/readme.txt", "result", dict(title=r"sccz80 / new / math32")),
    )
    add(
        "nb_n_zsdcc_z80_m32",
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"zsdcc.*new.*math32")),
        ("support/benchmarks/n-body/z88dk-new/readme.txt", "result", dict(title=r"zsdcc.*new.*math32")),
    )
    add(
        "nb_n_sccz80_z80_m16",
        ("support/benchmarks/n-body/readme.txt", "result", dict(title=r"sccz80 / new / math16")),
        ("support/benchmarks/n-body/z88dk-new/readme.txt", "result", dict(title=r"sccz80 / new / math16")),
    )

    # --- spectral classic ---
    add(
        "sn_c_sccz80_z80_m32",
        ("support/benchmarks/spectral-norm/readme.txt", "summary", dict(compiler="sccz80", cpu="z80", math="math32")),
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"sccz80 / classic c library / math32")),
        ("support/benchmarks/spectral-norm/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic c library / math32")),
    )
    add(
        "sn_c_sccz80_8085_m32",
        ("support/benchmarks/spectral-norm/readme.txt", "summary", dict(compiler="sccz80", cpu="8085", math="math32")),
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"sccz80 / classic c library / 8085 / math32")),
        ("support/benchmarks/spectral-norm/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic c library / 8085 / math32")),
    )
    add(
        "sn_c_zsdcc_z80_m32",
        ("support/benchmarks/spectral-norm/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32")),
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"zsdcc.*classic c library / math32")),
        ("support/benchmarks/spectral-norm/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc.*classic c library / math32")),
    )
    add(
        "sn_c_80cc_z80_m32",
        ("support/benchmarks/spectral-norm/readme.txt", "summary", dict(compiler="80cc", cpu="z80", math="math32")),
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"80cc / classic c library / math32")),
        ("support/benchmarks/spectral-norm/z88dk-classic/readme.txt", "result", dict(title=r"80cc / classic c library / math32")),
    )
    add(
        "sn_c_80cc_8085_m32",
        ("support/benchmarks/spectral-norm/readme.txt", "summary", dict(compiler="80cc", cpu="8085", math="math32")),
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"80cc / classic c library / 8085 / math32")),
        ("support/benchmarks/spectral-norm/z88dk-classic/readme.txt", "result", dict(title=r"80cc / classic c library / 8085 / math32")),
    )
    add(
        "sn_c_sccz80_z80_m16",
        ("support/benchmarks/spectral-norm/readme.txt", "summary", dict(compiler="sccz80", cpu="z80", math="math16")),
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"sccz80 / classic c library / math16")),
        ("support/benchmarks/spectral-norm/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic c library / math16")),
    )
    add(
        "sn_c_sccz80_8085_m16",
        ("support/benchmarks/spectral-norm/readme.txt", "summary", dict(compiler="sccz80", cpu="8085", math="math16")),
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"sccz80 / classic c library / 8085 / math16")),
        ("support/benchmarks/spectral-norm/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic c library / 8085 / math16")),
    )
    add(
        "sn_n_zsdcc_z80_m32",
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"zsdcc.*new c library / math32")),
        ("support/benchmarks/spectral-norm/z88dk-new/readme.txt", "result", dict(title=r"zsdcc.*new c library / math32")),
    )
    add(
        "sn_n_sccz80_z80_m32",
        # Never match bare "sccz80 / new c library" (math48-era April 2020).
        ("support/benchmarks/spectral-norm/readme.txt", "result", dict(title=r"sccz80 / new c library / math32")),
        ("support/benchmarks/spectral-norm/z88dk-new/readme.txt", "result", dict(title=r"sccz80 / new c library / math32")),
    )

    # --- mandelbrot classic ---
    add(
        "md_c_sccz80_z80_m32",
        ("support/benchmarks/mandelbrot/readme.txt", "summary", dict(compiler="sccz80", cpu="z80", math="math32")),
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"sccz80 / classic c library / math32")),
        ("support/benchmarks/mandelbrot/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic / math32")),
    )
    add(
        "md_c_sccz80_8085_m32",
        ("support/benchmarks/mandelbrot/readme.txt", "summary", dict(compiler="sccz80", cpu="8085", math="math32")),
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"sccz80 / classic c library / 8085 / math32")),
        ("support/benchmarks/mandelbrot/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic / 8085 / math32")),
    )
    add(
        "md_c_zsdcc_z80_m32",
        ("support/benchmarks/mandelbrot/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32")),
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"zsdcc / classic c library / math32")),
        ("support/benchmarks/mandelbrot/z88dk-classic/readme.txt", "result", dict(title=r"zsdcc.*classic / math32")),
    )
    add(
        "md_c_80cc_z80_m32",
        ("support/benchmarks/mandelbrot/readme.txt", "summary", dict(compiler="80cc", cpu="z80", math="math32")),
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"80cc / classic c library / math32")),
        ("support/benchmarks/mandelbrot/z88dk-classic/readme.txt", "result", dict(title=r"80cc / classic / math32")),
    )
    add(
        "md_c_80cc_8085_m32",
        ("support/benchmarks/mandelbrot/readme.txt", "summary", dict(compiler="80cc", cpu="8085", math="math32")),
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"80cc / classic c library / 8085 / math32")),
        ("support/benchmarks/mandelbrot/z88dk-classic/readme.txt", "result", dict(title=r"80cc / classic / 8085 / math32")),
    )
    add(
        "md_c_sccz80_z80_m16",
        ("support/benchmarks/mandelbrot/readme.txt", "summary", dict(compiler="sccz80", cpu="z80", math="math16")),
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"sccz80 / classic c library / math16")),
        ("support/benchmarks/mandelbrot/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic / math16")),
    )
    add(
        "md_c_sccz80_8085_m16",
        ("support/benchmarks/mandelbrot/readme.txt", "summary", dict(compiler="sccz80", cpu="8085", math="math16")),
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"sccz80 / classic c library / 8085 / math16")),
        ("support/benchmarks/mandelbrot/z88dk-classic/readme.txt", "result", dict(title=r"sccz80 / classic / 8085 / math16")),
    )
    add(
        "md_n_sccz80_z80_m32",
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"sccz80 / new c library / math32|sccz80 / new / math32")),
        ("support/benchmarks/mandelbrot/z88dk-new/readme.txt", "result", dict(title=r"sccz80 / new / math32")),
    )
    add(
        "md_n_zsdcc_z80_m32",
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"zsdcc.*new.*math32")),
        ("support/benchmarks/mandelbrot/z88dk-new/readme.txt", "result", dict(title=r"zsdcc.*new.*math32")),
    )
    add(
        "md_n_sccz80_z80_m16",
        ("support/benchmarks/mandelbrot/readme.txt", "result", dict(title=r"sccz80 / new c library / math16|sccz80 / new / math16")),
        ("support/benchmarks/mandelbrot/z88dk-new/readme.txt", "result", dict(title=r"sccz80 / new / math16")),
    )

    # --- fasta classic ---
    add(
        "fa_c_sccz80_z80_m32",
        ("support/benchmarks/fasta/readme.txt", "summary", dict(compiler="sccz80", cpu="z80", math="math32")),
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"sccz80 / classic c library / math32")),
        ("support/benchmarks/fasta/z88dk-classic/readme.txt", "result", dict(title=r"classic/sccz80/math32")),
    )
    add(
        "fa_c_sccz80_8085_m32",
        ("support/benchmarks/fasta/readme.txt", "summary", dict(compiler="sccz80", cpu="8085", math="math32")),
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"sccz80 / classic c library / 8085 / math32")),
        ("support/benchmarks/fasta/z88dk-classic/readme.txt", "result", dict(title=r"classic/sccz80/8085/math32")),
    )
    add(
        "fa_c_zsdcc_z80_m32",
        ("support/benchmarks/fasta/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32")),
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"zsdcc / classic c library / math32")),
    )
    add(
        "fa_c_80cc_z80_m32",
        ("support/benchmarks/fasta/readme.txt", "summary", dict(compiler="80cc", cpu="z80", math="math32")),
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"80cc / classic c library / math32")),
        ("support/benchmarks/fasta/z88dk-classic/readme.txt", "result", dict(title=r"classic/80cc/math32")),
    )
    add(
        "fa_c_80cc_8085_m32",
        ("support/benchmarks/fasta/readme.txt", "summary", dict(compiler="80cc", cpu="8085", math="math32")),
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"80cc / classic c library / 8085 / math32")),
        ("support/benchmarks/fasta/z88dk-classic/readme.txt", "result", dict(title=r"classic/80cc/8085/math32")),
    )
    add(
        "fa_n_sccz80_z80_m32",
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"sccz80 / new c library / math32")),
        ("support/benchmarks/fasta/z88dk-new/readme.txt", "result", dict(title=r"new/sccz80/math32")),
    )
    add(
        "fa_n_zsdcc_z80_m32",
        ("support/benchmarks/fasta/readme.txt", "result", dict(title=r"zsdcc / new c library / math32")),
        ("support/benchmarks/fasta/z88dk-new/readme.txt", "result", dict(title=r"new/zsdcc/math32")),
    )

    # --- whetstone classic ---
    add(
        "wh_c_sccz80_z80_m32",
        ("support/benchmarks/whetstone/readme.txt", "summary", dict(compiler="sccz80", cpu="z80", math="math32", whet=True)),
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"sccz80 / classic c library / math32", whet=True)),
        ("support/benchmarks/whetstone/z88dk-classic/readme.txt", "result", dict(title=r"classic/sccz80/math32", whet=True)),
    )
    add(
        "wh_c_sccz80_8085_m32",
        ("support/benchmarks/whetstone/readme.txt", "summary", dict(compiler="sccz80", cpu="8085", math="math32", whet=True)),
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"sccz80 / classic c library / 8085 / math32", whet=True)),
        ("support/benchmarks/whetstone/z88dk-classic/readme.txt", "result", dict(title=r"classic/sccz80/8085/math32", whet=True)),
    )
    add(
        "wh_c_zsdcc_z80_m32",
        ("support/benchmarks/whetstone/readme.txt", "summary", dict(compiler="zsdcc", cpu="z80", math="math32", whet=True)),
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"zsdcc / classic c library / math32", whet=True)),
    )
    add(
        "wh_c_80cc_z80_m32",
        ("support/benchmarks/whetstone/readme.txt", "summary", dict(compiler="80cc", cpu="z80", math="math32", whet=True)),
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"80cc / classic c library / math32", whet=True)),
        ("support/benchmarks/whetstone/z88dk-classic/readme.txt", "result", dict(title=r"classic/80cc/math32", whet=True)),
    )
    add(
        "wh_c_80cc_8085_m32",
        ("support/benchmarks/whetstone/readme.txt", "summary", dict(compiler="80cc", cpu="8085", math="math32", whet=True)),
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"80cc / classic c library / 8085 / math32", whet=True)),
        ("support/benchmarks/whetstone/z88dk-classic/readme.txt", "result", dict(title=r"classic/80cc/8085/math32", whet=True)),
    )
    add(
        "wh_n_sccz80_z80_m32",
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"sccz80 / new c library / math32", whet=True)),
        ("support/benchmarks/whetstone/z88dk-new/readme.txt", "result", dict(title=r"sccz80 / new c library / math32", whet=True)),
    )
    add(
        "wh_n_zsdcc_z80_m32",
        # math32 rows may be remeasured (including revision-tagged titles that name math32).
        ("support/benchmarks/whetstone/readme.txt", "result", dict(title=r"zsdcc.*new c library / math32", whet=True)),
        ("support/benchmarks/whetstone/z88dk-new/readme.txt", "result", dict(title=r"zsdcc.*new c library / math32", whet=True)),
    )

    return m


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

    for jid, row in sorted(ok.items()):
        entries = jmap.get(jid)
        if not entries:
            print(f"skip unmapped job: {jid}", file=sys.stderr)
            stats["miss_map"] += 1
            continue
        stats["jobs"] += 1
        size = int(row["size"])
        ticks = int(row["ticks"])
        for path_rel, kind, kw in entries:
            path = root / path_rel
            if path not in file_text:
                if not path.is_file():
                    print(f"missing file: {path}", file=sys.stderr)
                    continue
                file_text[path] = path.read_text()
            text = file_text[path]
            if kind == "summary":
                whet = bool(kw.get("whet"))
                karg = None
                if whet:
                    karg = 1000.0 / (ticks / 4_000_000.0)
                new, n = replace_summary_tick(
                    text,
                    kw["compiler"],
                    kw["cpu"],
                    kw["math"],
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
                )
                if n == 0:
                    print(f"result miss {jid} → {path_rel} / {kw['title']}", file=sys.stderr)
                    stats["miss_pat"] += 1
                else:
                    stats["result"] += n
                    file_text[path] = new

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
    ap.add_argument(
        "--root",
        type=Path,
        default=None,
        help="z88dk repo root (default: parent of .agents/)",
    )
    ap.add_argument(
        "--results",
        type=Path,
        required=False,
        help="results.tsv from run_math_benches.sh",
    )
    ap.add_argument("--date", default="August 10, 2026", help="RESULT date line")
    ap.add_argument(
        "--date-summary",
        default="Aug 10, 2026",
        help="SUMMARY table parenthetical date",
    )
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--list", action="store_true", help="list ok TSV rows only")
    args = ap.parse_args(argv)

    root = args.root or repo_root()
    if args.list:
        if not args.results:
            ap.error("--results required with --list")
        return apply(
            root,
            args.results,
            args.date,
            args.date_summary,
            dry_run=True,
            list_only=True,
        )
    if not args.results:
        ap.error("--results required")
    return apply(
        root,
        args.results,
        args.date,
        args.date_summary,
        dry_run=args.dry_run,
        list_only=False,
    )


if __name__ == "__main__":
    sys.exit(main())
