#!/usr/bin/env python3
"""Regenerate wiki drop-in pages from math TIMER results.tsv.

Updates (numbers / sizes / dates / bold only):
  - wiki-Benchmarks.md  (repo-root drop-in for Benchmarks wiki page)
  - wiki-Classic--Maths-Libraries.md
  - wiki/libraries/maths/Benchmarks.md
  - wiki/libraries/classic/Classic--Maths-Libraries.md
  - wiki/libraries/classic/Classic--Maths-Libraries-benchmarks-paste.md

Policy (methodology-measure):
  - Bold best **z80** and best **8085** math32 speed separately
  - math16 / z180 / z80n not bolded for speed
  - KWIPS highest wins for whetstone
"""
from __future__ import annotations

import argparse
import csv
import re
import sys
from pathlib import Path


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def fmt_comma(n: int) -> str:
    return f"{int(n):,}"


def fmt_us(n: int) -> str:
    s = str(int(n))
    parts: list[str] = []
    while s:
        parts.append(s[-3:])
        s = s[:-3]
    return "_".join(reversed(parts))


def wall_loose(ticks: int) -> str:
    sec = ticks / 4_000_000.0
    if sec < 60:
        return f"{sec:.2f} sec"
    m = int(sec // 60)
    s = int(round(sec - 60 * m))
    if s == 60:
        m += 1
        s = 0
    return f"{m} min {s} sec"


def wall_whet(ticks: int) -> str:
    return f"{ticks / 4_000_000.0:.4f} sec"


def kwips(ticks: int) -> float:
    return 1000.0 / (ticks / 4_000_000.0)


def load_ok(path: Path) -> dict[str, dict[str, str]]:
    with path.open(newline="") as f:
        rows = {r["id"]: r for r in csv.DictReader(f, delimiter="\t")}
    return {
        k: v
        for k, v in rows.items()
        if v.get("status") == "ok" and v.get("ticks") and v.get("size")
    }


def get(ok: dict[str, dict[str, str]], jid: str) -> tuple[int, int]:
    r = ok[jid]
    return int(r["size"]), int(r["ticks"])


def bold_wrap(s: str, bold: bool) -> str:
    return f"__{s}__" if bold else s


def replace_date_notes(text: str, date_note: str) -> str:
    # Aug 9, 2026 → new date in TIMER refresh notes
    text = re.sub(r"Aug \d+, 2026", date_note, text)
    text = re.sub(r"August \d+, 2026", date_note.replace("Aug", "August"), text)
    return text


# ---------------------------------------------------------------------------
# Benchmarks.md table row updaters
# ---------------------------------------------------------------------------

# (job_id, section_heading, row_label, is_whetstone)
BENCH_ROWS: list[tuple[str, str, str, bool]] = [
    # Fasta
    ("fa_c_sccz80_z80_m32", "Fasta", "Z88DK/SCCZ80_CLASSIC/MATH32", False),
    ("fa_c_sccz80_8085_m32", "Fasta", "Z88DK/SCCZ80_CLASSIC/8085/MATH32", False),
    ("fa_c_80cc_z80_m32", "Fasta", "Z88DK/80CC_CLASSIC/MATH32", False),
    ("fa_c_80cc_8085_m32", "Fasta", "Z88DK/80CC_CLASSIC/8085/MATH32", False),
    ("fa_c_zsdcc_z80_m32", "Fasta", "Z88DK/SDCC_CLASSIC/MATH32", False),
    ("fa_n_sccz80_z80_m32", "Fasta", "Z88DK/SCCZ80_NEW/MATH32", False),
    ("fa_n_zsdcc_z80_m32", "Fasta", "Z88DK/SDCC_NEW/MATH32", False),
    # n-Body
    ("nb_c_sccz80_z80_m32", "n-Body", "Z88DK/SCCZ80_CLASSIC/MATH32", False),
    ("nb_c_sccz80_8085_m32", "n-Body", "Z88DK/SCCZ80_CLASSIC/8085/MATH32", False),
    ("nb_c_sccz80_z80_m16", "n-Body", "Z88DK/SCCZ80_CLASSIC/MATH16", False),
    ("nb_c_sccz80_8085_m16", "n-Body", "Z88DK/SCCZ80_CLASSIC/8085/MATH16", False),
    ("nb_c_zsdcc_z80_m32", "n-Body", "Z88DK/SDCC_CLASSIC/MATH32", False),
    ("nb_n_sccz80_z80_m32", "n-Body", "Z88DK/SCCZ80_NEW/MATH32", False),
    ("nb_n_sccz80_z80_m16", "n-Body", "Z88DK/SCCZ80_NEW/MATH16", False),
    ("nb_n_zsdcc_z80_m32", "n-Body", "Z88DK/SDCC_NEW/MATH32", False),
    # Whetstone
    ("wh_c_sccz80_z80_m32", "Whetstone 1.2", "Z88DK/SCCZ80_CLASSIC/MATH32", True),
    ("wh_c_sccz80_8085_m32", "Whetstone 1.2", "Z88DK/SCCZ80_CLASSIC/8085/MATH32", True),
    ("wh_c_zsdcc_z80_m32", "Whetstone 1.2", "Z88DK/SDCC_CLASSIC/MATH32", True),
    ("wh_n_sccz80_z80_m32", "Whetstone 1.2", "Z88DK/SCCZ80/MATH32", True),
    ("wh_n_zsdcc_z80_m32", "Whetstone 1.2", "Z88DK/SDCC/MATH32", True),
]


def section_slice(text: str, heading: str) -> tuple[int, int]:
    """Return [start, end) line indices for a # heading section."""
    lines = text.splitlines(keepends=True)
    start = None
    for i, ln in enumerate(lines):
        if ln.startswith("# ") and heading in ln:
            start = i
            break
    if start is None:
        raise KeyError(heading)
    end = len(lines)
    for j in range(start + 1, len(lines)):
        if lines[j].startswith("# "):
            end = j
            break
    return start, end


def update_benchmarks(text: str, ok: dict[str, dict[str, str]], date_note: str) -> str:
    text = replace_date_notes(text, date_note)
    lines = text.splitlines(keepends=True)

    # Precompute bold winners per section for math32 only
    # For each section, among updated rows that are math32 (not math16), bold
    # best z80 and best 8085 by ticks (or KWIPS for whet).
    by_section: dict[str, list[tuple[str, str, int, int, bool]]] = {}
    for jid, sec, label, whet in BENCH_ROWS:
        if jid not in ok:
            print(f"benchmarks: missing {jid}", file=sys.stderr)
            continue
        size, ticks = get(ok, jid)
        by_section.setdefault(sec, []).append((jid, label, size, ticks, whet))

    # Determine which labels get bold for speed
    bold_labels: dict[tuple[str, str], bool] = {}
    for sec, items in by_section.items():
        candidates = []
        for jid, label, size, ticks, whet in items:
            if "MATH16" in label:
                continue  # never bold math16 for speed
            cpu = "8085" if "/8085/" in label or label.endswith("/8085/MATH32") else "z80"
            # refine cpu
            if "8085" in label:
                cpu = "8085"
            else:
                cpu = "z80"
            score = kwips(ticks) if whet else -ticks  # higher better
            candidates.append((cpu, score, label, whet))
        for cpu in ("z80", "8085"):
            group = [c for c in candidates if c[0] == cpu]
            if not group:
                continue
            best = max(group, key=lambda x: x[1])
            for c in group:
                bold_labels[(sec, c[2])] = c[2] == best[2]

    # Apply row replacements within each section
    for sec, items in by_section.items():
        # find section bounds in current lines
        start = end = None
        for i, ln in enumerate(lines):
            if ln.startswith("# ") and sec in ln:
                start = i
                break
        if start is None:
            print(f"section miss: {sec}", file=sys.stderr)
            continue
        end = len(lines)
        for j in range(start + 1, len(lines)):
            if lines[j].startswith("# "):
                end = j
                break

        for jid, label, size, ticks, whet in items:
            bold = bold_labels.get((sec, label), False)
            # also bold wall clock when speed is bold (existing convention)
            for i in range(start, end):
                ln = lines[i]
                if not ln.lstrip().startswith("|"):
                    continue
                # match row by label token
                if label not in ln:
                    continue
                if whet:
                    # | label | 32 | 24 | SIZE | TICKS | WALL | KWIPS |
                    k = kwips(ticks)
                    k_s = f"{k:.4f}"
                    size_s = str(size)
                    ticks_s = bold_wrap(fmt_comma(ticks), bold)
                    wall_s = bold_wrap(wall_whet(ticks), bold)
                    k_cell = bold_wrap(k_s, bold)
                    lines[i] = (
                        f"| {label}| 32 | 24 | {size_s} | {ticks_s} | "
                        f"{wall_s} | {k_cell} |\n"
                    )
                else:
                    size_s = str(size)
                    ticks_s = bold_wrap(fmt_comma(ticks), bold)
                    wall_s = bold_wrap(wall_loose(ticks), bold)
                    # preserve trailing style of "1 min 01.0 sec" only if we had it —
                    # use consistent wall_loose.
                    # Some SDCC_NEW fasta used "1 min 01.0 sec" — regenerate cleanly.
                    lines[i] = (
                        f"| {label}| {size_s} | {ticks_s} | {wall_s} |\n"
                    )
                break
            else:
                print(f"row miss {sec} / {label}", file=sys.stderr)

    return "".join(lines)


# ---------------------------------------------------------------------------
# Classic--Maths-Libraries.md tables (underscore ticks)
# ---------------------------------------------------------------------------

# job_id → (section_key, library_cell_prefix, compiler)
# library cell like "math32 (Aug 2026)" or "math32_8085 (Aug 2026)" or "math16 (Aug 2026)"
CLASSIC_ROWS = [
    # n-body
    ("nb_c_sccz80_z80_m32", "n-body", "math32", "sccz80"),
    ("nb_c_zsdcc_z80_m32", "n-body", "math32", "zsdcc"),
    ("nb_c_sccz80_8085_m32", "n-body", "math32_8085", "sccz80"),
    ("nb_c_sccz80_z80_m16", "n-body", "math16", "sccz80"),
    ("nb_c_sccz80_8085_m16", "n-body", "math16_8085", "sccz80"),
    # spectral
    ("sn_c_zsdcc_z80_m32", "spectral-norm", "math32", "zsdcc"),
    ("sn_c_sccz80_z80_m32", "spectral-norm", "math32", "sccz80"),
    ("sn_c_80cc_z80_m32", "spectral-norm", "math32", "80cc"),
    ("sn_c_sccz80_8085_m32", "spectral-norm", "math32_8085", "sccz80"),
    ("sn_c_80cc_8085_m32", "spectral-norm", "math32_8085", "80cc"),
    ("sn_c_sccz80_z80_m16", "spectral-norm", "math16", "sccz80"),
    ("sn_c_sccz80_8085_m16", "spectral-norm", "math16_8085", "sccz80"),
    # mandelbrot
    ("md_c_zsdcc_z80_m32", "mandelbrot", "math32", "zsdcc"),
    ("md_c_sccz80_z80_m32", "mandelbrot", "math32", "sccz80"),
    ("md_c_80cc_z80_m32", "mandelbrot", "math32", "80cc"),
    ("md_c_sccz80_z80_m16", "mandelbrot", "math16", "sccz80"),
    ("md_c_sccz80_8085_m32", "mandelbrot", "math32_8085", "sccz80"),
    ("md_c_80cc_8085_m32", "mandelbrot", "math32_8085", "80cc"),
    ("md_c_sccz80_8085_m16", "mandelbrot", "math16_8085", "sccz80"),
    # fasta
    ("fa_c_sccz80_z80_m32", "fasta", "math32", "sccz80"),
    ("fa_c_zsdcc_z80_m32", "fasta", "math32", "zsdcc"),
    ("fa_c_80cc_z80_m32", "fasta", "math32", "80cc"),
    ("fa_c_sccz80_8085_m32", "fasta", "math32_8085", "sccz80"),
    ("fa_c_80cc_8085_m32", "fasta", "math32_8085", "80cc"),
    # whetstone
    ("wh_c_sccz80_z80_m32", "whetstone", "math32", "sccz80"),
    ("wh_c_zsdcc_z80_m32", "whetstone", "math32", "zsdcc"),
    ("wh_c_sccz80_8085_m32", "whetstone", "math32_8085", "sccz80"),
]


def update_classic(text: str, ok: dict[str, dict[str, str]], date_note: str) -> str:
    text = replace_date_notes(text, date_note)
    lines = text.splitlines(keepends=True)

    # bold winners per section
    bold_key: set[tuple[str, str, str]] = set()  # (sec, lib, compiler)
    groups: dict[str, list[tuple[str, str, str, int, bool]]] = {}
    for jid, sec, lib, comp in CLASSIC_ROWS:
        if jid not in ok:
            continue
        _, ticks = get(ok, jid)
        whet = sec == "whetstone"
        groups.setdefault(sec, []).append((lib, comp, jid, ticks, whet))
    for sec, items in groups.items():
        for cpu_tag, pred in (
            ("z80", lambda lib: "8085" not in lib and not lib.startswith("math16")),
            ("8085", lambda lib: "8085" in lib and "math16" not in lib),
        ):
            cands = [(lib, comp, ticks, whet) for lib, comp, jid, ticks, whet in items if pred(lib)]
            if not cands:
                continue
            if cands[0][3]:  # whet
                best = max(cands, key=lambda x: kwips(x[2]))
            else:
                best = min(cands, key=lambda x: x[2])
            bold_key.add((sec, best[0], best[1]))

    for jid, sec, lib, comp in CLASSIC_ROWS:
        if jid not in ok:
            print(f"classic: missing {jid}", file=sys.stderr)
            continue
        size, ticks = get(ok, jid)
        bold = (sec, lib, comp) in bold_key
        # Match lines like:
        # math32 (Aug 2026)        | sccz80   | ... | __791_166_003__ [*](...)
        # or whetstone with KWIPS column
        lib_pat = re.escape(lib) + r"\s*\(Aug \d+, 2026\)"
        # allow date already rewritten
        lib_pat = re.escape(lib) + r"\s*\([^)]*2026\)"
        tick_us = fmt_us(ticks)
        tick_cell = f"__{tick_us}__" if bold else tick_us

        for i, ln in enumerate(lines):
            if not re.search(lib_pat, ln):
                continue
            if f"| {comp}" not in ln and f"| {comp} " not in ln:
                # compilers are padded: "sccz80   |"
                if not re.search(rf"\|\s*{re.escape(comp)}\s*\|", ln):
                    continue
            # ensure we're in roughly the right bench — energy/result cols vary
            # For multi-section, same lib+comp may appear once per section.
            # Walk sections by finding nearest preceding ### heading.
            # Safer: only replace if ticks-like field present.
            if sec == "whetstone":
                # Library | Compiler | Ticks | KWIPS
                k = kwips(ticks)
                k_s = f"{k:.4f}"
                k_cell = f"__{k_s}__" if bold else k_s
                # preserve [*] link if present
                m = re.search(r"(\[\*\]\([^)]+\))", ln)
                link = (" " + m.group(1)) if m else ""
                # rebuild keeping energy cols? whet has no energy
                # Format: math32 (Aug 2026)        | sccz80   | 362_679_466   | __11.0290__ [*](...)
                prefix = re.match(
                    rf"^({re.escape(lib)}\s*\([^)]*\))\s*\|\s*{re.escape(comp)}\s*\|",
                    ln,
                )
                if not prefix:
                    continue
                # pad library field like original (~25 chars before |)
                lib_field = f"{lib} ({date_note})"
                lib_field = f"{lib_field:<24}"
                lines[i] = (
                    f"{lib_field} | {comp:<7} | {tick_cell:<13} | {k_cell}{link}\n"
                )
                break
            else:
                # n-body has energy columns; spectral has result; mandelbrot/fasta ticks only
                m = re.search(r"(\[\*\]\([^)]+\))", ln)
                link = (" " + m.group(1)) if m else ""
                # Replace the last underscore-number (ticks) before optional link
                # Keep middle columns as-is.
                # Pattern: leading lib/comp, then columns, then ticks field
                # n-body: lib | comp | e0 | e1 | ticks link
                # spectral: lib | comp | result | ticks link
                # mandelbrot/fasta: lib | comp | ticks link
                parts = ln.rstrip("\n").split("|")
                if len(parts) < 3:
                    continue
                # update lib date in first field
                parts[0] = re.sub(
                    rf"{re.escape(lib)}\s*\([^)]*\)",
                    f"{lib} ({date_note})",
                    parts[0],
                )
                # last content field before link is ticks — may be glued with link
                last = parts[-1]
                # strip link for rewrite
                last_core = re.sub(r"\s*\[\*\].*$", "", last).strip()
                # if last_core looks like ticks or bold ticks
                if re.fullmatch(r"_?_?[0-9_]+_?_?", last_core.replace(" ", "")) or re.search(
                    r"[0-9]{3,}", last_core
                ):
                    parts[-1] = f" {tick_cell}{link}"
                else:
                    # ticks may be second-to-last (if trailing empty)
                    # try second last
                    if len(parts) >= 2:
                        # find rightmost field with digit underscores
                        for k in range(len(parts) - 1, 0, -1):
                            if re.search(r"\d{3,}", parts[k]):
                                # if this field also has result float for spectral, skip if has '.'
                                if "." in parts[k] and sec == "spectral-norm":
                                    continue
                                if "." in parts[k] and sec == "n-body":
                                    continue
                                # energy cols have leading minus and dot
                                if re.search(r"-?\d+\.\d+", parts[k]):
                                    continue
                                if re.search(r"\d+\.\d+", parts[k]) and "274" in parts[k]:
                                    continue
                                parts[k] = f" {tick_cell}{link}"
                                # clear link from other fields
                                for t in range(len(parts)):
                                    if t != k:
                                        parts[t] = re.sub(r"\s*\[\*\]\([^)]+\)", "", parts[t])
                                break
                lines[i] = "|".join(parts) + "\n"
                break
        else:
            print(f"classic row miss {sec} {lib} {comp}", file=sys.stderr)

    return "".join(lines)


def make_paste(ok: dict[str, dict[str, str]], date_note: str) -> str:
    """Compact paste tables for Classic Maths benchmarks section."""

    def row(jid: str, lib: str, comp: str, cpu: str, *, bold=False, whet=False) -> str:
        size, ticks = get(ok, jid)
        t = fmt_us(ticks)
        if whet:
            k = f"{kwips(ticks):.4f}"
            if bold:
                return f"| **{lib}** | **{comp}** | **{cpu}** | **{t}** | **{k}** | {size} |"
            return f"| {lib} | {comp} | {cpu} | {t} | {k} | {size} |"
        if bold:
            return f"| **{lib}** | **{comp}** | **{cpu}** | **{t}** | {size} |"
        return f"| {lib} | {comp} | {cpu} | {t} | {size} |"

    # winners
    def best_jid(jids: list[str]) -> str:
        return min(jids, key=lambda j: int(ok[j]["ticks"]))

    def best_kwips(jids: list[str]) -> str:
        return max(jids, key=lambda j: kwips(int(ok[j]["ticks"])))

    lines = [
        "# Classic Maths Libraries — benchmark numbers (wiki paste)",
        "",
        f"**Date:** {date_note}. **Source:** `support/benchmarks` TIMER recipes.",
        "",
        "Paste the tables below into the Benchmarks section of",
        "[Classic--Maths-Libraries](https://github.com/z88dk/z88dk/wiki/Classic--Maths-Libraries)",
        "(keep library prose above the tables from the live wiki page).",
        "",
        "**Bold:** best z80 / best 8085 math32 speed. math16 not bolded for speed.",
        "",
        "### n-body (N=1000)",
        "",
        "| Library | Compiler | CPU | Ticks | Size |",
        "|---------|----------|-----|------:|-----:|",
    ]
    nb_z80 = ["nb_c_sccz80_z80_m32", "nb_c_zsdcc_z80_m32"]
    nb_z80 = [j for j in nb_z80 if j in ok]
    bz = best_jid(nb_z80) if nb_z80 else None
    for jid, lib, comp, cpu in [
        ("nb_c_sccz80_z80_m32", "math32", "sccz80", "z80"),
        ("nb_c_zsdcc_z80_m32", "math32", "zsdcc", "z80"),
        ("nb_c_sccz80_8085_m32", "math32_8085", "sccz80", "8085"),
        ("nb_c_sccz80_z80_m16", "math16", "sccz80", "z80"),
        ("nb_c_sccz80_8085_m16", "math16_8085", "sccz80", "8085"),
    ]:
        if jid not in ok:
            continue
        bold = jid == bz or (cpu == "8085" and "math32" in lib and "math16" not in lib)
        # only one 8085 math32 sccz80
        if cpu == "8085" and "math16" not in lib:
            bold = True
        if "math16" in lib:
            bold = False
        if cpu == "z80" and "math32" in lib and "math16" not in lib:
            bold = jid == bz
        lines.append(row(jid, lib, comp, cpu, bold=bold))

    lines += [
        "",
        "### spectral-norm (N=100)",
        "",
        "| Library | Compiler | CPU | Ticks | Size |",
        "|---------|----------|-----|------:|-----:|",
    ]
    sn_z80 = [j for j in ["sn_c_sccz80_z80_m32", "sn_c_zsdcc_z80_m32", "sn_c_80cc_z80_m32"] if j in ok]
    sn_85 = [j for j in ["sn_c_sccz80_8085_m32", "sn_c_80cc_8085_m32"] if j in ok]
    bz = best_jid(sn_z80) if sn_z80 else None
    b5 = best_jid(sn_85) if sn_85 else None
    for jid, lib, comp, cpu in [
        ("sn_c_sccz80_z80_m32", "math32", "sccz80", "z80"),
        ("sn_c_zsdcc_z80_m32", "math32", "zsdcc", "z80"),
        ("sn_c_80cc_z80_m32", "math32", "80cc", "z80"),
        ("sn_c_sccz80_8085_m32", "math32_8085", "sccz80", "8085"),
        ("sn_c_80cc_8085_m32", "math32_8085", "80cc", "8085"),
        ("sn_c_sccz80_z80_m16", "math16", "sccz80", "z80"),
        ("sn_c_sccz80_8085_m16", "math16_8085", "sccz80", "8085"),
    ]:
        if jid not in ok:
            continue
        bold = jid in (bz, b5) and "math16" not in lib
        lines.append(row(jid, lib, comp, cpu, bold=bold))

    lines += [
        "",
        "### mandelbrot (w=h=60)",
        "",
        "| Library | Compiler | CPU | Ticks | Size |",
        "|---------|----------|-----|------:|-----:|",
    ]
    md_z80 = [j for j in ["md_c_sccz80_z80_m32", "md_c_zsdcc_z80_m32", "md_c_80cc_z80_m32"] if j in ok]
    md_85 = [j for j in ["md_c_sccz80_8085_m32", "md_c_80cc_8085_m32"] if j in ok]
    bz = best_jid(md_z80) if md_z80 else None
    b5 = best_jid(md_85) if md_85 else None
    for jid, lib, comp, cpu in [
        ("md_c_sccz80_z80_m32", "math32", "sccz80", "z80"),
        ("md_c_zsdcc_z80_m32", "math32", "zsdcc", "z80"),
        ("md_c_80cc_z80_m32", "math32", "80cc", "z80"),
        ("md_c_sccz80_8085_m32", "math32_8085", "sccz80", "8085"),
        ("md_c_80cc_8085_m32", "math32_8085", "80cc", "8085"),
        ("md_c_sccz80_z80_m16", "math16", "sccz80", "z80"),
        ("md_c_sccz80_8085_m16", "math16_8085", "sccz80", "8085"),
    ]:
        if jid not in ok:
            continue
        bold = jid in (bz, b5) and "math16" not in lib
        lines.append(row(jid, lib, comp, cpu, bold=bold))

    lines += [
        "",
        "### fasta (N=1000)",
        "",
        "| Library | Compiler | CPU | Ticks | Size |",
        "|---------|----------|-----|------:|-----:|",
    ]
    fa_z80 = [j for j in ["fa_c_sccz80_z80_m32", "fa_c_zsdcc_z80_m32", "fa_c_80cc_z80_m32"] if j in ok]
    fa_85 = [j for j in ["fa_c_sccz80_8085_m32", "fa_c_80cc_8085_m32"] if j in ok]
    bz = best_jid(fa_z80) if fa_z80 else None
    b5 = best_jid(fa_85) if fa_85 else None
    for jid, lib, comp, cpu in [
        ("fa_c_sccz80_z80_m32", "math32", "sccz80", "z80"),
        ("fa_c_zsdcc_z80_m32", "math32", "zsdcc", "z80"),
        ("fa_c_80cc_z80_m32", "math32", "80cc", "z80"),
        ("fa_c_sccz80_8085_m32", "math32_8085", "sccz80", "8085"),
        ("fa_c_80cc_8085_m32", "math32_8085", "80cc", "8085"),
    ]:
        if jid not in ok:
            continue
        bold = jid in (bz, b5)
        lines.append(row(jid, lib, comp, cpu, bold=bold))

    lines += [
        "",
        "### whetstone",
        "",
        "| Library | Compiler | CPU | Ticks | KWIPS @ 4 MHz | Size |",
        "|---------|----------|-----|------:|--------------:|-----:|",
    ]
    wh_z80 = [j for j in ["wh_c_sccz80_z80_m32", "wh_c_zsdcc_z80_m32"] if j in ok]
    wh_85 = [j for j in ["wh_c_sccz80_8085_m32"] if j in ok]
    bz = best_kwips(wh_z80) if wh_z80 else None
    b5 = best_kwips(wh_85) if wh_85 else None
    for jid, lib, comp, cpu in [
        ("wh_c_sccz80_z80_m32", "math32", "sccz80", "z80"),
        ("wh_c_zsdcc_z80_m32", "math32", "zsdcc", "z80"),
        ("wh_c_sccz80_8085_m32", "math32_8085", "sccz80", "8085"),
    ]:
        if jid not in ok:
            continue
        bold = jid in (bz, b5)
        lines.append(row(jid, lib, comp, cpu, bold=bold, whet=True))

    lines += [
        "",
        "### Exception",
        "",
        "- Spectral math16 TIMER requires pure `--math16` (after `(DOUBLE)1.0` cast in classic source). Do not link `--math32` for math16 TIMER rows.",
        "",
    ]
    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--results", type=Path, required=True)
    ap.add_argument("--date-summary", default="Aug 10, 2026")
    ap.add_argument("--root", type=Path, default=None)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args(argv)
    root = args.root or repo_root()
    ok = load_ok(args.results)
    print(f"ok rows: {len(ok)}", file=sys.stderr)
    date_note = args.date_summary

    targets = {
        root / "wiki-Benchmarks.md": "benchmarks",
        root / "wiki/libraries/maths/Benchmarks.md": "benchmarks",
        root / "wiki-Classic--Maths-Libraries.md": "classic",
        root / "wiki/libraries/classic/Classic--Maths-Libraries.md": "classic",
        root / "wiki/libraries/classic/Classic--Maths-Libraries-benchmarks-paste.md": "paste",
    }

    for path, kind in targets.items():
        if not path.is_file() and kind != "paste":
            print(f"skip missing {path}", file=sys.stderr)
            continue
        if kind == "paste":
            new = make_paste(ok, date_note)
        elif kind == "benchmarks":
            new = update_benchmarks(path.read_text(), ok, date_note)
        else:
            new = update_classic(path.read_text(), ok, date_note)
        if args.dry_run:
            print(f"dry-run would write {path} ({len(new)} bytes)", file=sys.stderr)
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(new)
            print(f"wrote {path.relative_to(root)}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
