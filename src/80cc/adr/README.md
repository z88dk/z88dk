# 80cc Architecture Decision Records

These ADRs describe **how the 80cc back end works and why** — the durable design,
as distinct from the many `*_PLAN.md` files (which are transient, per-effort
working notes). Read these to understand the compiler; read the plans only for
the history of a specific optimisation.

80cc is one of z88dk's C compilers: a small-C front end feeding an SSA-ish
intermediate representation and a retargetable 8-bit back end (z80, z80n, z180,
ez80, rabbit, gbz80, 8080, 8085, kc160).

| ADR | Topic |
|-----|-------|
| [0001](0001-ir-backend-pipeline.md) | IR-based back end and the compilation pipeline |
| [0002](0002-z80-register-model.md) | The z80 register reality and the vreg → physical-register model |
| [0003](0003-register-residency.md) | Register residency: region-home-or-slot, the orchestrator, and live-range packing |
| [0004](0004-soundness-and-gating.md) | Soundness: `op_clobbers`, `IR_VERIFY`, revert-to-slot, `require_slot`, and byte-identical gating |
| [0005](0005-helper-clobber-table.md) | The runtime-helper clobber table (`__preserve_regs`) |
| [0006](0006-multi-cpu-retargeting.md) | Multi-CPU retargeting (CPU-agnostic pipeline; CPU knowledge in the lowerer) |
| [0007](0007-kind-width-type-model.md) | The type-kind / width model on VRegs |
| [0008](0008-ivsr-strength-reduction.md) | Induction-variable strength reduction (IVSR) and LFTR |
| [0009](0009-wide-value-accumulator.md) | Wide (6/8-byte) value handling via a memory accumulator (`__i64_acc` / FA) |
| [0010](0010-ast-vs-ir-optimisation-layering.md) | AST-level and IR-level optimisation: a deliberate two-level split |
| [0011](0011-index-register-allocation.md) | Index-register (IX/IY) allocation by frame mode, and reservation |
| [0012](0012-frame-pointer-default-by-cpu.md) | Per-CPU default for the frame pointer (fp on z80/z80n/z180/ez80) |
| [0017](0017-ranged-residency-ssot.md) | Ranged residency: a home-per-interval table as the single source of truth (amends 0003) |
| [0013](0013-peephole-text-layer.md) | The peephole / assembly-text layer: copt (80cc_rules.1 only) + the post-render text filter (dead-label elision, defc relocation, operand-rewrite jump threading) |
| [0014](0014-volatile-behaviour.md) | Volatile behaviour: VREG_VOLATILE locals, `mem.volatile_` derefs, the `;volatile` copt stamp |
| [0015](0015-ir-pattern-matcher.md) | The IR pattern-matcher engine: declarative production table (templates + check/apply + exclude_cpus), side conditions written once |
| [0016](0016-two-pass-lowering-and-carry.md) | Two-pass lowering: cross-BB register carry (bb_hl_out / byte-home), lazy spill (store-on-clobber), and rematerialisation |
| [0018](0018-operand-residency-de-cache.md) | **Rejected** — operand residency via a DE cache (both the single-BB cache and the cross-BB carry) |
| [0019](0019-cross-function-tail-merging.md) | **Rejected** — cross-function tail merging and shared epilogue helpers (banking) |
| [0020](0020-narrowing-a-pushed-argument.md) | **Rejected** — narrowing the producer of a byte-wide pushed argument |
| [0021](0021-per-value-spill-heuristics.md) | **Rejected** — per-value spill/placement heuristics (the decision is interference, not value kind) |
| [0022](0022-widening-the-long-stack-park.md) | **Rejected** — widening the long stack-park pass (its gate is def-uniqueness, not use count) |
| [0023](0023-bytewise-word-store.md) | **Rejected** — the bytewise word store (it must drop a belief the pair form keeps) |
| [0025](0025-post-render-code-layout.md) | Post-render code layout: tail merging, then block layout, then branch relaxation (amends 0013) |
| [0026](0026-index-home-as-addressing-mode.md) | The index home is an addressing mode, not only a value carrier (amends 0011) |
| [0027](0027-truthful-home-intervals.md) | **Accepted** — each home narrows to its true live range (stage 1 of 0017); 20 cells smaller, none larger |
| [0028](0028-trip-count-weighting.md) | *Proposed* — weight costs by derived trip counts instead of `4^depth` |
| [0029](0029-de-cache-fold-brick.md) | **Rejected** — the fail-safe DE cache fold MISCOMPILES (17 cells); deleted, −114 lines |
| [0032](0032-gbz80-word-cost-row.md) | The measured gbz80 cost rows (SLOT+BC), shipped — and why the regression that held them back was a failed recovery, not a ranking tie |
| [0034](0034-one-owner-for-the-allocation.md) | `ir_alloc` is the only writer of the plan; the render reports typed rejections (amends 0003) |
| [0061](0061-call-split-eviction-is-coupled-to-prepush-narrowing.md) | **Accepted** — `cs-evict` defaults to `prepush-narrow`, because its opportunity only exists once narrowing admits the candidates |
| [0060](0060-the-iy-packs-do-not-need-the-bc-veto.md) | **Accepted** — the IY packs self-guard, so the BC veto never applied to them |
| [0059](0059-revisit-a-yielded-index-home.md) | **Accepted** — a param that yielded the index home takes it back if the counter never collected it |
| [0058](0058-bc-and-the-index-home-can-be-swapped.md) | **Accepted** — the greedy never prices the PAIRING; swapping BC and the index home wins 76 on reg_set |
| [0057](0057-the-offset-fold-is-half-a-change.md) | **Accepted** — the deref-offset fold REGRESSES ALONE (+77 B) and only pays with the idx-deref rung |
| [0056](0056-signed-compares-that-need-no-sign-correction.md) | **Accepted** — 50 of 153 signed compares need no sign correction; monotonic is not bounded |
| [0055](0055-a-deref-through-a-symbol-base-becomes-absolute.md) | **Accepted** — a deref through a `&symbol` base folds to an absolute load; 4 B and ~20 T a site |
| [0054](0054-the-8085-reads-a-word-deref-with-lhlx.md) | **Accepted** — the 8085 reads a word deref with LHLX/LDHI — 3 B/20 c against 6 B/36 c |
| [0053](0053-narrow-a-constant-shift-to-the-bytes-that-survive.md) | **Accepted** — narrow a width-4 constant shift to the bytes a CONV_TRUNC keeps; −257 B, none larger |
| [0052](0052-fold-an-offset-into-a-rematerialised-symbol.md) | **Accepted** — fold a field offset into a rematerialised `&symbol`; 7 B becomes 3 |
| [0074](0074-the-gameboy-has-no-ex-de-hl.md) | **Accepted** — the in-place rewrite is excluded on gbz80: no `ex de,hl`, and both firing benches are better without it |
| [0075](0075-the-rabbit-multiply-is-a-call-not-a-loop.md) | **Accepted** (copt fold) — Rabbit's `l_mult` IS already `mul`; the cost is the CALL. A store-reload fold ships; inlining the multiply was measured and **withdrawn** |
| [0076](0076-the-iy-pack-cannot-be-arbitrated-against-the-pools.md) | **Refused** ×3 — `RC_DE_ACC`/`RC_IDX2` vs `ir_iy_reduction_pack`: `idx_ben` is the same unit but a different model, and a late home cannot survive the word-home revert |
| [0077](0077-ldhi-pointer-plus-constant-on-8085.md) | **Accepted**, default on — LDSI's sibling: `ld de,N; add hl,de` → `ld de,hl+N; ex de,hl` on the 8085, with the same three hazards |
| [0078](0078-z80n-add-hl-a-for-zero-extended-bytes.md) | **Accepted**, default on — z80n `add hl,a` for a zero-extended byte; also records `add hl,nn` and `push nn` **refused** as size-neutral. Its closing recommendation (tell the sweep which calls and returns really take DE) landed as 0084 |
| [0079](0079-the-cpu-sweep-is-finished.md) | **Accepted** — closes the CPU sweep: `tst`, kc160 divide and the z80n immediate forms **refused** with numbers; its ez80 `lea` row was wrong and is superseded by 0081 |
| [0080](0080-a-memory-increment-is-one-instruction.md) | **Accepted**, default on — `ld a,MEM; inc a; ld MEM,a` → `inc MEM` on every CPU; the win needs a branch-FOLLOWING A-liveness walk |
| [0081](0081-ez80-frame-addresses-are-ix-relative.md) | **Accepted**, default on — supersedes 0079 item 1: in fp mode the address IS IX-relative and the offset is known, so `lea hl,ix+d` replaces `ld hl,N; add hl,sp`. Needed the `#SP2L` copt fold to move with it |
| [0082](0082-an-escaped-local-is-not-a-constant.md) | **Accepted**, not gated — CORRECTNESS: `ir_opt_const_fold` kept a local's constant belief across a call that took its address (`int a=0; bump(&a); return a+x;` → `x`). Long-standing, silent, both frame modes |
| [0083](0083-a-write-through-a-pointer-names-no-symbol.md) | **Accepted**, not gated — CORRECTNESS: the same hole as 0082 in four more places. `*p = a + x; t = a + x;` handed `t` **the pointer** — OP_ASSIGN's `(deref (lv=p))` destination was read with the spelling a COMPOUND assignment uses. Plus `ir_opt_cse` across a call that escapes a local, and `cse-synth` / `licm` across an indirect store. Corpus +497 B |
| [0084](0084-de-is-not-read-by-every-return-or-call.md) | **Accepted**, default on (`de-ret`, `de-call`) — `instr_effects` read EVERY `ret` and EVERY `call` as reading DE. A `ret` does so only where the FUNCTION returns in DE; a `call` only where the EMITTER placed an argument there, which the rendered text cannot know, so the call site records it per symbol, prove-clean. Unthrottles `[de-park]`, `[ldsi-addr]`, `[ldhi-addr]`, `[z80n-add-a]`. Supersedes half of 0047, and is the successor 0078 asked for |
| [0085](0085-the-widen-belongs-in-the-register-the-consumer-wants.md) | **Accepted** — a zero-extended byte is widened in the register its consumer needs; the census refuses five smaller zero-extension shapes |
| [0086](0086-a-dead-gameboy-hl-restore-does-not-cross-a-loop-backedge.md) | **Accepted** — Game Boy omits an HL restore before a local loop jump whose target replaces HL |
| [0087](0087-the-ez80-prologue-uses-the-full-ix-frame-offset.md) | **Accepted**, default on — a framed eZ80 prologue allocates from IX with the full frame size, including any auto-pushed parameter |
| [0090](0090-the-short-word-right-shift-is-a-size-regression.md) | **Accepted**, every CB-shift target (z80/z180/ez80/gbz80/kc160) — `ld a,l; (srl h; rra) × count; ld l,a` makes the step 3 bytes instead of 4; widening was −178 B/40 cells/0 larger. The original "no corpus size change" was WRONG, corrected in the ADR: the rung is worth −44 B on z80 alone |
| [0091](0091-the-dead-l-store-before-an-a-chain-shift.md) | **Accepted** — the `ld l,a; ld a,l` round trip in front of an A-chain shift is dead and drops as a pair; −18 B/14 cells/0 larger. copt removes the `ld a,l` AFTER 80cc, so both lines are still present at peephole time |
| [0092](0092-a-masked-shift-in-a-loop-gives-up-the-top-byte-route.md) | **Accepted**, z80/z180/gbz80 ONLY — `(x >> n) & M` takes the A-chain at n==2 always and n==3 IN A LOOP; the curves cross at n==4. The trade INVERTS on ez80 (+2.44 %) and kc160 (+4.63 %), which an aggregate would have hidden — report a trade per CPU, never averaged |
| [0089](0089-addition-swap-has-no-scalar-two-pass-gate.md) | **Rejected** — a sound addition swap gate needs a second pass-1 render; md5 −6 % but binary-trees +28 B and emu.c +75 B |
| [0088](0088-indexed-word-rmw-address-restoration-is-a-small-rung.md) | **Sized** — one histbench site in 8 CPU/frame cells, 40 B total; no emitter change |
| [0073](0073-ask-slot-off-not-the-spill-slot.md) | **Accepted** — ask `slot_off`, not `vreg_spill_slot`; the wrong query cost structbench +10.5 % |
| [0072](0072-the-commutative-swap-is-refused.md) | **Rejected** — the commutative swap in addition resurrects an elided store; md5 −6 % against emu.c +75 B |
| [0071](0071-the-call-split-eviction-floor.md) | **Accepted** — the eviction floor is magnitude, not ratio; below it the model is inside its own error |
| [0070](0070-a-carried-span-needs-the-loop-extended-interval.md) | **Accepted** — flat op order is not control-flow order; a carried span needs the loop-extended interval |
| [0069](0069-a-bare-pop-hl-clears-the-address-belief.md) | **Accepted** — a bare `pop hl` clears the address belief; this was the vm1 wrong-answer class |
| [0068](0068-the-index-half-home-is-gated-on-net-bytes.md) | **Accepted** — the index-half home is gated on RAW net bytes, threshold 4 by sweep |
| [0067](0067-opening-an-index-home-costs-every-exit.md) | **Accepted** — opening an IY home costs every exit; the cycle model is structurally blind to it |
| [0066](0066-a-home-dear-to-fill-cannot-take-a-parameter.md) | **Accepted** — a home dear to FILL cannot take a parameter; idx_ben prices accesses, not filling |
| [0065](0065-the-deref-offset-term.md) | **Accepted** — the deref-offset term is what tells an index home from a GP pair |
| [0064](0064-the-accumulator-margin-is-three.md) | **Accepted** — the accumulator's contention margin is 3x, and a modelled zero means blind, not free |
| [0063](0063-the-prepush-narrowing-is-a-pair.md) | **Accepted** — pre-push narrowing is a PAIR with `bc-save-live`; alone it regresses |
| [0062](0062-a-deref-base-may-take-the-index-home.md) | **Accepted** — a deref base may take the index home, and the win is the EVICTED value getting cheaper |
| [0051](0051-8085-k-flag-trip-counters.md) | *Proposed* — 8085 `jp k`/`jp nk`; 33/59 logical zero-tests are pure trip counters; needs an IV shift, not a peephole |
| [0050](0050-stack-transient-spill-is-an-sp-mode-trade.md) | **Accepted** — stack-transient spill is sp-mode only, and the CPU test genuinely is the question |
| [0049](0049-bc-liveness-follows-branches.md) | **Accepted** — BC liveness follows intra-function branches; −248 B, none larger, nothing slower |
| [0048](0048-the-8085-de-park-is-decided-on-rendered-text.md) | **Accepted** — the 8085 DE park is decided on rendered text, because the residency cache cannot see the future; its DE-liveness question is re-answered by 0084 |
| [0047](0047-de-liveness-follows-branches-but-not-calls.md) | **Accepted**, superseded in part by 0084 — DE liveness follows branches. Its "calls and `ret` stay conservative" half no longer holds |
| [0046](0046-the-a-cache-invalidates-by-default.md) | **Accepted** — the A cache invalidates by default, so an incomplete recogniser loses bytes not correctness |
| [0045](0045-xor-a-rides-the-backward-flag-sweep.md) | **Accepted** — `xor a` for `ld a,0`, decided by a backward flag sweep; −230 B, none larger |
| [0044](0044-a-call-argument-qualifies-a-byte-remat.md) | **Accepted** — a call argument qualifies a global byte remat; emu.c −131/−272 B, invisible to the corpus |
| [0043](0043-a-pushed-long-param-is-carried-past-the-prologue.md) | **Accepted** — a pushed long param is carried in DE:HL past the prologue; emu.c −60/−51 B |
| [0042](0042-a-narrowing-result-stays-in-hl.md) | **Accepted** — a long→int narrowing result stays in HL; −285 B over 38 cells, none larger |
| [0041](0041-a-dead-store-is-blocked-only-by-a-channel-reader.md) | **Accepted** — a dead store is vetoed only by a channel reader, not any sharing reader; −1200 B |
| [0040](0040-frame-slot-addresses-rematerialise.md) | **Accepted** — frame-slot addresses rematerialise instead of spilling; the CPU test hid a property test |
| [0039](0039-ldsi-slot-addresses-on-8085.md) | **Accepted** — 8085 slot addresses via LDSI: −366 B, −0.95 % ticks, nothing larger or slower |
| [0038](0038-the-8085-is-not-a-z80.md) | **Rejected** — 8085 is priced as a z80 and should not be; the correct rows are recorded, and they make the output worse |
| [0037](0037-pricing-the-eviction-in-t-states.md) | **Rejected** — pricing the BC eviction in the arbiter's own unit; worse on both axes, and the same eviction is ±12 % across CPUs |
| [0036](0036-charging-a-param-eviction-for-framelessness.md) | **Rejected** — charging a param eviction for framelessness; the win came from applying it in sp mode |
| [0035](0035-claims-are-priced-in-isolation.md) | Why a *more correct* cost input made things worse twice — nothing prices the displaced claim |
| [0033](0033-relaxing-unconditional-jumps.md) | Relaxing unconditional jumps is per-CPU; `IR_JR_UNCOND` overrides it (amends 0025) |
| [0031](0031-stepped-pointer-param-in-bc.md) | A stepped pointer parameter may live in BC (promoted after the `frameless_ok` fix) |
| [0030](0030-debug-locals-in-frame-slots.md) | Under `-debug`, a named local is forced to a coherent frame slot (address-taken), with offsets emitted post-lowering |
| [0024](0024-byte-home-for-a-single-use-temp.md) | **Rejected** — relaxing the byte-home use-count gate (E is slot-backed; one byte home per function) |

Derived from the `*_PLAN.md` working notes: 0006 ← MULTICPU_IR, 0007 ← KIND_WIDTH,
0008 ← IVSR, 0009 ← the long-long/double accumulator design. Transient
per-optimisation plans (BC_PACK, PTRBENCH_*, the residency levers, MR_SQUASH,
REORG, the `*_BUG` post-mortems) stay as plans, not ADRs.

## Conventions

- **Status** of each ADR: Accepted / Superseded / Proposed / **Rejected**.
- A **Rejected** ADR records a lever that was measured and refused: what was
  tried, why it does not work, and what would have to change to reopen it. This
  is durable knowledge — it stops the same idea being rebuilt — but it is not a
  decision about how the compiler works, so it never changes the architecture
  the other ADRs describe. Keep it short, and link the evidence rather than
  quoting it.
- Performance figures for an **Accepted** decision live in commit messages,
  `BENCH_MATRIX.txt` and plan docs, **not in the ADR or in code comments** —
  they go stale, and the mechanism is what endures. State the shape of the
  result and point at the dated log section.
- **A refusal is the exception: keep the number that refused it.** In a
  **Rejected** ADR, and in a "refused in the same family" section of an
  accepted one, the regression IS the decision — `+1789 bytes` (ADR 0020),
  `+307 bytes` with four times as many cells larger as smaller (ADR 0024) —
  and a refutation whose number has been moved elsewhere is the one that gets
  re-attempted. Write the figure inline, with its matrix and both frame modes
  named, and say what would have to change to reopen it.
- Each residency feature is gated so the compiler is **byte-identical with it
  off** — see ADR 0004. New residency work should preserve that property.
