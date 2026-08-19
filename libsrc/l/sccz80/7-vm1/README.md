# sccz80 runtime overrides for the KR580VM1

A tier in the same shape as `7-8085`: the routines a VM1 build should take from
here instead of `9-common`, listed in `libsrc/l/sccz80/vm1.lst`. Everything not
named there falls through to the 8080 versions, which are correct — the VM1
runs 8080 code unchanged — merely longer than they need to be.

**None of this assembles yet.** z80asm does not know the CPU, so the tier
cannot be built until it does. The encodings the mnemonics stand for are in
`src/80cc/vm1_shim.py`.

## The one thing to know before reading these

Every VM1 word instruction reads or writes DE — DCMP, DSUB, LHLX and SHLX all
do — so each routine here clobbers DE where the common version did not. That
is affordable because **sccz80 guarantees very little about register state
across a helper call** unless a copt rule has rewritten the sequence. Checked
rather than assumed: no rule in `lib/z80rules.*` keeps DE live across `l_gint`
(the three that come close all write DE afterwards, with `pop de` or
`ld de,N`), and the hand-written callers do not either — two of the three are
commented out, the third is compiler output.

`l_sub` is the one whose callers were worth reading individually: lib3d's
`turn_left`/`turn_right` reload DE immediately after, and the borrow they then
test with `ret nc` is set by DSUB exactly as it was by the byte chain's final
`sbc a,h`.

## What is here

**Comparisons — `cp hl,de` (DCMP D).** One byte, and HL survives. The 8085
needs `ld bc,de` + `sub hl,bc` because its DSUB reaches BC and nothing else;
the common code walks the halves through A. So each of these is the 8085
routine minus its staging move.

| | 9-common | 7-8085 | here |
|---|---|---|---|
| `l_eq` `l_ne` | 6 instructions, byte-wise | `ld bc,de` + `sub hl,bc` | `cp hl,de` |
| `l_ult` `l_ule` `l_ugt` `l_uge` | `cp`/`cp` on the halves | as above | `cp hl,de` |

`l_compare_tf.asm` carries the `l_compare_true` / `l_compare_false` tails those
four jump to. The 8085 keeps them in a file called `l_compare_result.asm`,
which SHADOWS `9-common/l_compare_result.asm` — affordable there because that
tier overrides all ten comparisons, so nothing is left calling
`l_compare_result`. This tier leaves the four signed comparisons to 9-common,
which does call it, so the file needs a name of its own or the build loses a
symbol it still needs.

**Word loads — `ld hl,(de)` (LHLX).** `l_gint` and its `l_gint1/2/3` entries,
`l_gint4`…`l_gint8`, `l_gintsp`, `l_gint_eq`. The common form is a three-line
byte walk that also destroys A (4 instructions once the 8080 expands
`ld a,(hl+)`); this is `ex de,hl` + `ld hl,(de)`, 2 bytes against 4 and 14T
against 24T, with A left alone.

**Word stores — `ld (de),hl` (SHLX).** `l_pint_eq`, `l_pint_pop`. Taken from
the 8085 unchanged; `l_pint` aliases into `l_pint_pop_pint` and so is covered
without a file of its own.

**Subtraction — `sub hl,de` (DSUB D).** `l_sub` is `ex de,hl` + `sub hl,de`
against six instructions.

## What is deliberately not here

- **Signed comparisons** (`l_lt` `l_le` `l_gt` `l_ge`). Possible but not worth
  it. DSUB and DCMP set S, Z and CY and leave OF alone — OF comes from the
  8-bit ALU — so there is no `jp k` shortcut as on the 8085, and the route is
  to flip both sign bits and then DCMP. Costed: 18 bytes against the common
  version's 16, and slower too, because the common one exits early once the
  high bytes differ.
- **`l_cmp`.** Could sign-flip and DCMP, but the common version leaves HL and
  DE both intact and clobbers only A and B. No instruction that reads DE can
  match that, and unlike the routines above this one has a caller that cares
  (`l_graphics_cmp`).
- **`l_putptr` `l_plong`.** They store through BC while DE holds part of the
  value, so SHLX would need the value staged out of the way first. `l_plong`
  looks like 8 instructions against 11 that way; it also returns with HL
  changed, which wants its callers checked first.
- **`l_asr` `l_asr_u`** (ARHL), **`l_mult` `l_mult_ulong` `l_rlde` `l_div_u`**
  (RDEL), **`l_gint1sp`…`l_gint8sp`** (LDSI). The 8085 has those instructions
  and the VM1 does not. The LDSI group is the standing reason the VM1 trails
  the 8085: it cannot form a frame address in DE without going through HL.
- **`i32/l_long_sub` `l_long_cmp` `l_long_ucmp`.** The 8085 versions walk the
  stack operand with LDSI. Without it there is no VM1 form.
