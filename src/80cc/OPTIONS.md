# 80cc optimisation options

Every named optimisation the back end can turn off, and what turning it off
does. Two front doors onto one registry:

    zcc ... --opt-disable=name,name     a compiler flag, for a user
    IR_OFF=name,name zcc ...            the same registry, for a measurement

Both take a comma list and accept `all`. Every entry is **on by default**, and
every opt-out is intended to be byte-identical to the compiler before that
optimisation landed — that is the house rule (ADR 0004), and it is what makes
these usable for bisecting a miscompile.

`pattern:<name>` disables one IR pattern-matcher production (ADR 0015).

Names marked **(measure)** exist mainly to attribute a size or tick change; the
rest are real optimisations.

## AST layer

Disabled through the same flag, but a separate bitmask — these run before the IR
exists (ADR 0010).

| Name | Turning it off means |
| --- | --- |
| `fold` | no constant folding on the AST |
| `prop` | no copy/constant propagation |
| `simplify` | no algebraic simplification of binops |
| `typecheck` | skip the AST type-consistency pass |
| `compoundify` | leave compound assignment as read-modify-write trees |
| `strength-reduce` | no AST-level strength reduction |
| `cse` | no common-subexpression elimination |
| `cse-synth` | no synthesised temporaries for CSE |
| `licm` | no loop-invariant code motion |
| `dse` | no dead-store elimination on the AST |
| `dead-code` | keep statically unreachable statements |
| `thread-jumps` | no jump threading across conditionals |
| `demote-poststep` | keep `p++` as a post-step instead of demoting it |
| `loop-reverse` | never reverse a counted loop to count down to zero |
| `bool-step` | keep statement `x +=/-= !cond` as a materialised boolean update |
| `k-trip` | 8085 literal 16-bit countdown loops keep the regular zero-test rather than using a shifted counter and `jp nk` |

## IR optimiser (`ir_opt.c`)

| Name | Turning it off means |
| --- | --- |
| `arg-reorder` | keep call arguments in source order even when all are side-effect-free, so a control-flow argument spills the earlier ones |
| `const-fold` | no IR constant folding |
| `dce` | no dead-code elimination |
| `dce-live` | DCE keeps its cheap form; no liveness-driven mark-and-sweep |
| `dead-def` | keep a definition whose destination is never read |
| `dead-def-live` | `dead-def` decides without per-edge liveness (more conservative) |
| `prune` | keep unreachable basic blocks |
| `aggregate-promote` | keep fixed-offset fields of non-escaping local structs in memory |
| `coalesce-copies` | keep `IR_MOV` copies that could be coalesced away |
| `addr-cse` | recompute an address expression instead of reusing it |
| `deref-offset` | keep a field offset as a separate address temporary rather than folding it into the access — the other half of `idx-deref` |
| `store-chain` | lower adjacent fixed-offset stores through one pointer as an address-walking chain |
| `lea-offset` | no folding of a constant offset into an address computation |
| `narrow-byte` | keep a word value wide when every use fits a byte |
| `var-byte-shift` | keep a promoted variable-count byte shift on the established word-width path |
| `shr-wide` | a constant-count right shift is not narrowed to a byte |
| `shr-mask` | no folding of the mask a narrowed right shift implies |
| `iv-narrow` | no narrowing of an induction variable |
| `ivsr` | no induction-variable strength reduction (ADR 0008) |
| `ivsr-affine` | no folding of a non-power-of-two affine multiple (struct-array stride) |
| `ivsr-suppress` | apply IVSR even on the CPUs where a walking pointer is not cheaper |
| `ivsr-suppress-ez80` | ez80 is left out of the IVSR redundant-pointer suppression (the walking pointer is kept) |
| `ivsr-ez80-byte` | on ez80 a byte-bounded counter with a scaled (non-byte) index still suppresses the walking pointer it makes redundant |
| `ivsr-recompute` | CSE merges the `<<1` of an index that `ivsr-suppress` kept for address recompute, so two array addresses share one scaled index |
| `lftr` | no linear-function test replacement |
| `lftr-signed` | LFTR only where the bound is a constant, never a signed variable |
| `smax0` | LFTR's `max(0,n)` clamp for a signed variable bound is built as a logical shift, a subtract and an AND, instead of one sign test over a zero load |
| `cmp-unsign` | keep the sign tail on a comparison that cannot go negative |
| `conv-mask-fold` | keep a widening conversion feeding a mask |
| `sym-addr-fold` | keep `&sym + K` as an add instead of a symbol address |
| `sym-cmp-fold` | no folding of a symbol address into a compare |
| `sym-deref-fold` | no folding of a symbol address into a dereference |
| `reassoc` | no reassociation of word-resident expressions |
| `reduce-coalesce` | no coalescing during strength reduction |
| `word-resident` | no word-residency proposals at all (gates `reassoc` and `reduce-coalesce` too) |

## Allocation (`ir_alloc.c`)

| Name | Turning it off means |
| --- | --- |
| `bc-handoff` | a BC-packed temp may not take BC at the op where an existing BC tenant dies; it must wait for the tenant's whole range to end |
| `bc-pack` | no tight BC packing pass after region selection |
| `byte-pack` | no ranged packing of born-and-killed byte temporaries into B |
| `byte-pack-de` | no single slot-backed D home for a born-and-killed byte temporary |
| `z80n-add-a` | z80n zero-extended byte adds go via DE instead of `add hl,a` |
| `de-widen` | a byte widened into DE and copied to HL keeps `ld e,S; ld d,0; ld hl,de` |
| `inc-mem` | a memory increment stays `ld a,MEM; inc a; ld MEM,a` instead of `inc MEM` |
| `l-call-flags` | a `call l_*` runtime helper is assumed to read the flags, as any asm-linkage call is |
| `gb-word-mem` | gbz80 word `++`/`--` and zero/constant word stores go through HL and DE instead of `inc (hl)`, `ld (hl+),a` and immediate stores |
| `dsub-bc` | An 8085 signed compare with one operand already in BC copies the RHS into BC (push/pop if BC is live) instead of subtracting BC where it is |
| `hl-const-reuse` | a constant loaded into HL while HL holds a known constant is reloaded in full, instead of being dropped, stepped (`inc hl`/`dec hl`) or loaded one byte |
| `tos-rmw` | a stack-top slot read and write keep their `push hl` / `pop de` pair around a body that cannot see the stack |
| `slot-bitop-de` | a 16-bit and/or/xor of two (ix+d) word slots is staged through DE and HL even when DE is dead after it |
| `mask-shl-a` | a masked byte doubled as `ld l,a; ld h,0; add hl,hl` is not doubled in A first, even when A and S/P/V/H are dead after it |
| `dead-slot-drop` | a value whose frame slot the render never touched keeps the slot (only a wholly dead frame is dropped) |
| `small-frame-fast` | small frames use the default forms: two `push af` for a 4-byte frame (not `ld hl,-4; add hl,sp; ld sp,hl` on z180 or four `dec sp` on ez80/kc160/r800), and the ld-form teardown on kc160 and for 5-byte frames (not `pop af` / `inc sp`) |
| `dead-sp-addr` | an `ld hl,N; add hl,sp` whose HL and carry are both dead is kept |
| `hl-mem-carry` | a global word loaded for a branch test is reloaded in the block the branch reaches, instead of being taken from HL |
| `addr-fold` | `ex de,hl; ld hl,_sym; add hl,de` stays as is instead of becoming `ld de,_sym; add hl,de` where DE is dead after the add (not on VM1 or Rabbit) |
| `gb-store-a` | gbz80 HL-to-slot word stores go through DE (`ld de,hl; …; ld (hl),e; inc hl; ld (hl),d`) instead of A (`ld a,l; ld d,h; …; ld (hl+),a; ld (hl),d`) where A and E are dead |
| `gb-small-frame` | gbz80 frames of 1 or 2 bytes open with `add sp,-N` and close with `add sp,N` instead of `dec sp` / `push af` and `inc sp` / `pop bc` |
| `idx-rmw-de` | an indexed word RMW keeps the BC address park instead of the `dec hl`-restored DE route |
| `shr-a-chain` | a constant word right shift stays `srl h; rr l` instead of the A-through-CB chain |
| `shr-dead-l` | the dead `ld l,a` before an A-through-CB shift chain is kept |
| `shr-tbac` | a masked `(x >> n) & M` in a loop keeps the top-byte `add hl,hl` route instead of the A-chain |
| `lea-frame-addr` | ez80 fp-mode frame addresses go through `add hl,sp` instead of `lea hl,ix+d` |
| `lea-frame-prologue` | ez80 fp-mode frame allocation uses `ld hl,-N; add hl,sp` instead of an IX-relative `lea` |
| `bc-evict` | a BC tenant is never displaced by a better candidate |
| `bc-per-cand` | BC cost is scored per class, not per candidate |
| `callbc` | a call's word result never takes a BC home straight from the call, and a sign-fill arithmetic shift right still ends a BC pack span |
| `bc-call-cost` | the arbiter does not charge a BC home for call preservation **(measure: `=<N>` sets the margin)** |
| `byte-resident` | no byte homes (C slotless, E slot-backed) |
| `byte-tie` | equal-tick byte candidates are not broken by byte count |
| `word-resident` | no word (DE) home proposals |
| `de-home` | no general DE home for a loop-carried word |
| `deref-width` | a word dereference through BC/DE is priced as a byte `ld a,(bc)` rather than as a base read into HL |
| `de-rearb` | a word DE-home pick the render rejects is reverted to the allocator's snapshot only; the function is not lowered again without a DE-class home |
| `loop-ra` | no loop-scoped DE allocation on top of `de-home` |
| `iv-resident` | no home for a hot write-many induction variable |
| `iv-acc` | no induction-variable accumulator home |
| `idx2-counter` | an index home is offered to a counter even where it would cost `push iy`/`pop hl` per iteration |
| `idx2-revisit` | a param that yielded the index register to a counter is never reconsidered |
| `idx2-reuse` | the idx2 slot is a single whole-function owner instead of reusing it across non-overlapping live ranges |
| `idx2-call-ez80` | on ez80 in sp mode a value is not given an index home across calls |
| `yield-total` | a compared counter yields BC to a deref base for the index register even when the two homes are worth less together |
| `ez80-hl-ihl` | on ez80 a word read through HL is the byte pair through A, not `ld hl,(hl)` |
| `de-keep-hl` | a DE load that must keep HL saves it with `push hl`/`pop hl` even from an index home or an `(ix+d)` slot |
| `idx-deref` | an index-homed pointer is not dereferenced in place, and its cost term goes with it (ADR 0026) |
| `idxhalf` | no byte homes in IX/IY halves (sp mode, z80/z80n/ez80) |
| `iy-temp-pack` | no IY packing for a short-lived temporary |
| `iy-long` | do not run the IY packs in a function the BC veto excludes |
| `lra` | no linear-scan-style IY interval picking |
| `graph-alloc` | no interference-graph-driven index benefit |
| `home-swap` | two placed homes are never exchanged even when the swap wins |
| `stack-spill` | no parking of a value on the data stack instead of a frame slot |
| `tight-homes` | home intervals stay whole-function instead of narrowing to the live range (stage 1 of the ranging arc, ADR 0027) |
| `call-split` | no call-bounded live-range splitting |
| `cs-evict` | a call-split tenant never displaces an incumbent |
| `mwbc` | no multi-write BC home |
| `mwbc-pressure` | the multi-write BC home ignores register pressure |
| `prepush-narrow` | the pre-pushed-call veto stays whole-function instead of narrowing |
| `prepush-straddle` | a value written inside a pre-pushed argument group and read after its call keeps a BC, B or C home (the restore after the call overwrites it) |
| `depth-weight` | loop depth stops weighting the cost model — every block counts once |
| `g0-measured` | the cost model uses estimated rather than measured Z80 access costs **(measure)** |
| `idx2-base` | an index home is not offered to a dereference base |
| `byte-remat` | a byte loaded from a global is spilled instead of re-loaded at the use |
| `remat` | no rematerialisation of constants and symbol addresses |
| `slot-prune` | keep a frame slot for a byte that only ever rides A |
| `dead-de-reload` | keep a dead DE reload before a later use |
| `long-step-mhl` | keep the long-step MHL lowering disabled |
| `pool-remat-add-fold` | keep a post-render pool/rematerialisation add |
| `xorflip-chain` | keep chained sign-flip folding disabled |
| `xorflip-const` | keep constant sign-flip folding disabled |

## Lowering (`ir_lower*.c`)

| Name | Turning it off means |
| --- | --- |
| `ix-indirect` | an sp-mode function with any indirect call saves IX, even when the call does not dispatch through it |
| `jp-next` | keep an unconditional `jp` that jumps to the label directly below it |
| `lazy-spill` | spill at the definition instead of deferring to the clobber |
| `ss-evidence` | lazy spill keeps a spill store unless a hook proved every later use cache-served, instead of keeping it only for the slot reads the render emitted |
| `ss-keep-hl` | lazy spill does not consider the stores of word call results (and other commits that keep the value in HL), so a dead one stays |
| `ss-byte` | lazy spill leaves byte values out, so a dead byte store to a frame slot stays |
| `gb-hl-to-de` | gbz80 moves a word from HL to DE with the synthesised `ex de,hl` even when DE holds nothing to keep, instead of `ld d,h; ld e,l` |
| `a-carry` | the A-register belief is dropped at each basic-block boundary |
| `hl-carry` | the HL belief is not carried across a basic-block edge |
| `de-carry` | the DE belief is not carried into a compare across a basic-block edge |
| `hl-addr-carry` | a slot address held in HL is not carried across an edge |
| `de-flow` | no DE liveness flow into the lowering decisions (8085) |
| `ldsi-addr` | 8085 slot addresses use `ld hl,N; add hl,sp` instead of the LDSI form |
| `ldhi-addr` | 8085 pointer-plus-constant uses `ld de,N; add hl,de` instead of the LDHI form |
| `de-park` | no rewriting of a `push de`/`pop de` park |
| `de-ret` | every `ret` is read as reading DE, not only one that returns in DE |
| `de-call` | every `call` is read as reading DE, not only one that passes an argument there |
| `de-call-asm` | an asm-linkage call (no `_` prefix), `call l_jphl`, `l_case` and `l_setjmp` are taken to read DE, as before the emitter's per-call record covered them |
| `declean` | a DE home is not proven clean across a bitop |
| `dead-store` | a byte spill written but never read is still stored |
| `dead-store-word` | the same for a word spill |
| `ds-fp-store` | a word stored straight to an `(ix+d)` slot by a producer is counted as a slot read, so dead-store never drops it |
| `dead-store-share` | dead-store analysis ignores slot sharing |
| `dead-regcopy` | keep a register copy the final peephole would delete |
| `regcopy-flow` | keep a GBZ80 HL restore before a local jump whose target immediately reloads HL |
| `home-exit-de` | a DE word home read after its loop is flushed to its slot at the exit block and reloaded, instead of staying in DE (and, when the exit only returns, never flushed) |
| `deadframe` | a function with no live frame keeps its frame anyway |
| `frameless` | never drop the frame pointer, even where nothing uses it |
| `frame-index` | no direct `(ix+d)` frame access; the address is materialised |
| `sp-flip` | a framed function is never re-lowered against SP (fp mode only) |
| `home-demote` | an unrealisable home aborts instead of falling back to a slot |
| `home-rearb` | after a demotion the freed register is not offered to the next candidate |
| `home-resident` | no home-residency backstop during the render |
| `wh-exit-hoist` | a byte home is not flushed at the region exit |
| `home-exit-dead` | flush a DE home at a loop exit even when it is dead there |
| `remat-lea` | an address is reloaded rather than recomputed |
| `remat-lea-ez80fp` | on ez80 in fp mode a frame-slot address gets a slot instead of being rematerialised |
| `remat-lea-call` | a frame-slot address in a function that makes a call gets a slot instead of being rematerialised |
| `lea-call-args` | any call in a function makes every frame address count as needed, even when all its uses fold to `(ix+d)` |
| `symaddr-deref` | a symbol address is not folded into its dereference |
| `slot-addr-widen` | a cached slot address is not reused for a wider access |
| `trunc-res` | a truncated result is materialised at full width first |
| `gwiden` | no A-liveness-driven widening fold |
| `shr-narrow` | a right-shift result is materialised wide before its narrow use |
| `xor-a` | zero is loaded with `ld a,0` instead of `xor a` |
| `add-bc` | `add hl,bc` is not used when one operand is BC-resident |
| `dsub` | no `sbc hl,bc` on the CPUs that have it |
| `bc-call` | BC is not kept live across a call |
| `bc-save-live` | BC is saved around a call even when it holds nothing live |
| `bc-step-param` | a stepped pointer parameter is reloaded from its slot each iteration instead of riding BC (ADR 0031) |
| `bc-live` | no BC park sweep in the final peephole |
| `bc-flow` | no BC liveness flow into the lowering decisions |
| `call-bremat` | a byte is reloaded after a call instead of rematerialised |
| `sdccdecl-byte-const` | a constant byte argument to `__z88dk_sdccdecl` is stored in a frame slot instead of rematerialised at the push |
| `acc-drop` | a wide accumulator result is stored even when dead in the accumulator |
| `acc-drop-wide` | a wide (float / long long) result is stored to its slot even when the next op reads it from the accumulator and it dies there (only the binop/compare push case drops it), and a wide call argument is always reloaded from its slot |
| `acc-int-literal` | an integer literal used as a 5/6/8-byte double operand or cast to one is converted at run time instead of becoming a double constant |
| `acc-pool-operand` | a pool constant operand of a 5/6/8-byte double add/sub/mul/div is loaded into a vreg (and its slot) instead of being read by address |
| `acc-drop-slot` | a double / long long whose every store is dropped still gets a frame slot |
| `acc-mirror` | a compare or long long subtract whose right operand is in the accumulator and left is not reloads the right operand instead of calling the mirrored helper |
| `acc-prepush` | the operand a double / long long binop or compare pushes is stored at its def and reloaded at the op, instead of being pushed when computed (sccz80 order) |
| `acc-conv-hl` | a word converted from the float accumulator is always stored, and a value whose next op converts it to double is stored though the conversion reads it from HL |
| `reg-int-literal` | an integer literal used as a 4-byte / 2-byte float operand or cast to one is converted at run time (l_f32_sint2f) instead of becoming a float constant |
| `hcall-commit` | a word result of a helper call is always stored to its slot (not dead-aware) |
| `remat-imm32` | a 4-byte constant read only as helper-call arguments keeps its def and slot instead of being rebuilt at each read |
| `f32-prepush` | a 4-byte value whose only use is a later helper's stacked argument is pushed at its def only in the narrow Lever A case (sp mode, nothing between), not across balanced calls or in fp mode |
| `alu-fold` | no `(ix+d)` ALU fold for AND/OR/XOR |
| `ixd-fold` | no `(ix+d)` fold for the word accumulator |
| `r6k-ixd-alu` | no Rabbit 6000 indexed ALU form |
| `cmp-hi` | an unsigned `<`/`>=` against a constant compares both bytes |
| `cmp-k` | a compare against a constant is not given its immediate form |
| `cmp-k-signed` | (not on the 8085) a signed word compare against a constant is not done byte-wise through A (`sub K_lo; ld a,hi; rla; ccf; rra; sbc a,K_hi^0x80`), so it goes through `sbc hl,de` and the overflow correction |
| `iv-narrow-unsigned` | a loop counter narrowed to a byte is still compared as a signed byte (`xor 0x80; cp K^0x80`) rather than with an unsigned `cp K` |
| `byte-cmp-const` | a word compare against a byte-sized constant is not narrowed |
| `frame-byte-trunc` | a width-2 value truncated to one byte materialises the whole word through HL first instead of reading the one byte directly |
| `byte-half-direct` | a byte taken from a word held in BC or DE copies the whole word to HL first instead of reading `c`/`b`/`e`/`d` |
| `sink-trunc` | a word-to-byte truncation is not moved down next to the byte store that reads it, so the byte lives across the address arithmetic |
| `ivsr-suppress-lea` | a stepped pointer is made for a local array addressed from the frame, instead of rebuilding the address from sp (ez80 sp always keeps it) |
| `ivsr-share` | two derived induction addresses with the same base, index, scale and step each get their own stepped pointer |
| `trunc-store-bc` | a byte store of a word held in BC loads the byte through A and E instead of storing `c` straight through HL |
| `self-ops` | no block-local value-equivalence folds (`1*x`, `(x+y)-y`, `x&~x`, `x^x`, `0 op x`) |
| `self-div` | `x/x` is not folded to 1 and `x%x` to 0 (division by zero is undefined, so x is assumed nonzero) |
| `pair-bitop` | a word AND/OR/XOR/NOT with its result in BC stages operands through HL and DE instead of working byte-wise through A |
| `de-home-step` | `i++` / `i--` of a word DE home goes through HL (`ld hl,de; inc hl; ex de,hl`) instead of `inc de`, and ends the DE-home region |
| `dehome-dead-exit` | a general DE home is not kept resident in a loop whose leaving edge follows a redefinition of the home, even when the home is dead at the exit |
| `word-ztest` | a word zero test uses the baseline sequence |
| `switch-chain` | a small word switch calls `l_case` with a case table instead of an inline `dec hl` / zero-test chain, even when the chain is no larger |
| `switch-byte-a` | a `char` switch scrutinee is widened to HL instead of staying in A |
| `gpderef` | no general-pointer dereference form |
| `lhlx-deref` | no `ld hl,(de)` dereference on the CPUs that have it |
| `lhlx-long` | no LDSI-based long load on 8085 |
| `shlx-store` | no `ld (de),hl` store form |
| `idx-fill` | an index home is filled with a load pair rather than one ez80 instruction |
| `fclong-carry` | a long fastcall result is not carried in registers |
| `f32-stack-arg` | a float argument is not passed on the stack |
| `narrow-mul` | `(unsigned long)u16 * u16` widens both operands to 32 bits instead of taking the 16x16->32 helper |
| `autopush-param` | a param is stashed across frame allocation instead of becoming a top-of-frame slot |
| `depark` | no unparking of a value held in E or D alone |
| `gbz80-tos-read` | GBZ80 word reads at the top frame slot use direct SP-relative loads instead of the POP/PUSH path |
| `tos-store` | GBZ80 eligible nonvolatile top-of-stack word stores keep the register-preserving path instead of using the POP/PUSH selector |
| `local-rmw` | the measured frame-local word RMW keeps its address and updated value on the stack instead of repeatedly spilling them to frame slots |
| `gbz80-rmw` | compatibility opt-out alias for `local-rmw` |

## Text layer (ADR 0013, ADR 0025)

| Name | Turning it off means |
| --- | --- |
| `tail-merge` | duplicate instruction tails are not merged (per function) |
| `block-layout` | no trace movement to delete a jump |
| `block-layout-rounds` | block layout runs once, so a trace ending in a jump that another move replaced stays put |
| `jr-relax` | `jp` is never relaxed to `jr` |
| `label-elide` | dead basic-block labels are kept in the output |
| `ret-thread` | a jump to a `ret` is not threaded |
| `defassign-verify` | not an optimisation: no stderr warning for a local that is read but never written on any path (`IR_DEFASSIGN_VERIFY=1` widens it, `=2` aborts) |
| `mulchain-de` | a constant-multiply shift-add chain reloads its multiplicand every term instead of keeping it in DE |

## Keeping this file true

`scripts/check_options.sh` fails if a registry name has no row here, or a row names an
option that no longer exists. Run it with any change that adds or removes an
`opt_disabled` call.
