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

## IR optimiser (`ir_opt.c`)

| Name | Turning it off means |
| --- | --- |
| `const-fold` | no IR constant folding |
| `dce` | no dead-code elimination |
| `dce-live` | DCE keeps its cheap form; no liveness-driven mark-and-sweep |
| `dead-def` | keep a definition whose destination is never read |
| `dead-def-live` | `dead-def` decides without per-edge liveness (more conservative) |
| `prune` | keep unreachable basic blocks |
| `coalesce-copies` | keep `IR_MOV` copies that could be coalesced away |
| `addr-cse` | recompute an address expression instead of reusing it |
| `deref-offset` | keep a field offset as a separate address temporary rather than folding it into the access — the other half of `idx-deref` |
| `lea-offset` | no folding of a constant offset into an address computation |
| `narrow-byte` | keep a word value wide when every use fits a byte |
| `shr-wide` | a constant-count right shift is not narrowed to a byte |
| `shr-mask` | no folding of the mask a narrowed right shift implies |
| `iv-narrow` | no narrowing of an induction variable |
| `ivsr` | no induction-variable strength reduction (ADR 0008) |
| `ivsr-affine` | no folding of a non-power-of-two affine multiple (struct-array stride) |
| `ivsr-suppress` | apply IVSR even on the CPUs where a walking pointer is not cheaper |
| `lftr` | no linear-function test replacement |
| `lftr-signed` | LFTR only where the bound is a constant, never a signed variable |
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
| `bc-pack` | no tight BC packing pass after region selection |
| `ldsi-addr` | 8085 slot addresses use `ld hl,N; add hl,sp` instead of the shorter LDSI pair |
| `ldhi-addr` | 8085 pointer-plus-constant uses `ld de,N; add hl,de` instead of the shorter LDHI pair |
| `z80n-add-a` | z80n zero-extended byte adds go via DE instead of `add hl,a` |
| `de-widen` | a byte widened into DE and copied to HL keeps `ld e,S; ld d,0; ld hl,de` |
| `inc-mem` | a memory increment stays `ld a,MEM; inc a; ld MEM,a` instead of `inc MEM` |
| `idx-rmw-de` | an indexed word RMW keeps the BC address park instead of the `dec hl`-restored DE route |
| `shr-a-chain` | a constant word right shift stays `srl h; rr l` instead of the A-through-CB chain |
| `shr-dead-l` | the dead `ld l,a` before an A-through-CB shift chain is kept |
| `shr-tbac` | a masked `(x >> n) & M` in a loop keeps the top-byte `add hl,hl` route instead of the A-chain |
| `lea-frame-addr` | ez80 fp-mode frame addresses go through `add hl,sp` instead of `lea hl,ix+d` |
| `lea-frame-prologue` | ez80 fp-mode frame allocation uses `ld hl,-N; add hl,sp` instead of an IX-relative `lea` |
| `bc-evict` | a BC tenant is never displaced by a better candidate |
| `bc-per-cand` | BC cost is scored per class, not per candidate |
| `bc-call-cost` | the arbiter does not charge a BC home for call preservation **(measure: `=<N>` sets the margin)** |
| `byte-resident` | no byte homes (C slotless, E slot-backed) |
| `byte-tie` | equal-tick byte candidates are not broken by byte count |
| `word-resident` | no word (DE) home proposals |
| `de-home` | no general DE home for a loop-carried word |
| `loop-ra` | no loop-scoped DE allocation on top of `de-home` |
| `iv-resident` | no home for a hot write-many induction variable |
| `iv-acc` | no induction-variable accumulator home |
| `idx2-counter` | an index home is offered to a counter even where it would cost `push iy`/`pop hl` per iteration |
| `idx2-revisit` | a param that yielded the index register to a counter is never reconsidered |
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
| `depth-weight` | loop depth stops weighting the cost model — every block counts once |
| `g0-measured` | the cost model uses estimated rather than measured Z80 access costs **(measure)** |
| `idx2-base` | an index home is not offered to a dereference base |
| `byte-remat` | a byte loaded from a global is spilled instead of re-loaded at the use |
| `remat` | no rematerialisation of constants and symbol addresses |
| `slot-prune` | keep a frame slot for a byte that only ever rides A |

## Lowering (`ir_lower*.c`)

| Name | Turning it off means |
| --- | --- |
| `lazy-spill` | spill at the definition instead of deferring to the clobber |
| `a-carry` | the A-register belief is dropped at each basic-block boundary |
| `hl-carry` | the HL belief is not carried across a basic-block edge |
| `hl-addr-carry` | a slot address held in HL is not carried across an edge |
| `de-flow` | no DE liveness flow into the lowering decisions (8085) |
| `de-park` | no rewriting of a `push de`/`pop de` park |
| `de-ret` | every `ret` is read as reading DE, not only one that returns in DE |
| `de-call` | every `call` is read as reading DE, not only one that passes an argument there |
| `declean` | a DE home is not proven clean across a bitop |
| `dead-store` | a byte spill written but never read is still stored |
| `dead-store-word` | the same for a word spill |
| `dead-store-share` | dead-store analysis ignores slot sharing |
| `dead-regcopy` | keep a register copy the final peephole would delete |
| `regcopy-flow` | keep a GBZ80 HL restore before a local jump whose target immediately reloads HL |
| `deadframe` | a function with no live frame keeps its frame anyway |
| `frameless` | never drop the frame pointer, even where nothing uses it |
| `frame-index` | no direct `(ix+d)` frame access; the address is materialised |
| `sp-flip` | a framed function is never re-lowered against SP (fp mode only) |
| `home-demote` | an unrealisable home aborts instead of falling back to a slot |
| `home-rearb` | after a demotion the freed register is not offered to the next candidate |
| `home-resident` | no home-residency backstop during the render |
| `wh-exit-hoist` | a byte home is not flushed at the region exit |
| `remat-lea` | an address is reloaded rather than recomputed |
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
| `acc-drop` | a wide accumulator result is stored even when dead in the accumulator |
| `alu-fold` | no `(ix+d)` ALU fold for AND/OR/XOR |
| `ixd-fold` | no `(ix+d)` fold for the word accumulator |
| `r6k-ixd-alu` | no Rabbit 6000 indexed ALU form |
| `cmp-hi` | an unsigned `<`/`>=` against a constant compares both bytes |
| `cmp-k` | a compare against a constant is not given its immediate form |
| `byte-cmp-const` | a word compare against a byte-sized constant is not narrowed |
| `word-ztest` | a word zero test uses the baseline sequence |
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

## Text layer (ADR 0013, ADR 0025)

| Name | Turning it off means |
| --- | --- |
| `tail-merge` | duplicate instruction tails are not merged (per function) |
| `block-layout` | no trace movement to delete a jump |
| `jr-relax` | `jp` is never relaxed to `jr` |
| `label-elide` | dead basic-block labels are kept in the output |
| `ret-thread` | a jump to a `ret` is not threaded |

## Keeping this file true

`scripts/check_options.sh` fails if a registry name has no row here, or a row names an
option that no longer exists. Run it with any change that adds or removes an
`opt_disabled` call.
