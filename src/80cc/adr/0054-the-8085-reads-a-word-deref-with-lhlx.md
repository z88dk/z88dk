# ADR 0054 — The 8085 reads a word deref with LHLX

Status: **Accepted**, default on. `--opt-disable=lhlx-deref` opts out.

Sibling of ADR 0039 (LDSI for slot addresses) — the same chip, the same idea
applied to a deref rather than a frame slot.

## Decision

On the 8085, read a word deref with LHLX, which takes the address in DE:

* `ld de,hl+n` (LDHI) folds a field offset in for free, so the whole access is
  **3 B / 20 c** against the offset chain plus byte walk's 6 B / 36 c;
* at offset 0, getting the address into DE costs **2 B / 14 c** against 4 B / 24 c;
* it leaves **A** alone, where the walk clobbers it;
* it reads the word with **one** bus access rather than two.

## The price, and the three exclusions

DE is the price. A small-offset word deref is one of the shapes `op_de_clean`
promises is DE-clean, which is how a DE home survives across it — so this is
gated on the function keeping no DE home (`func_has_de_home`).

Excluded: offsets outside LDHI's unsigned byte; a **post-step** (`*p++`), which
steps the base through its own path and wants HL; and a **banked or far
pointer**, which needs its page-in. All three stay on the byte walk.
