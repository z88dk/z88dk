# 80cc back end

The z88dk 80cc C compiler back end: an SSA-ish IR lowered to retargetable 8-bit asm.
This glossary pins the vocabulary used when reasoning about **register residency** — the
decision of where each value lives (register vs frame slot) and how the lowerer tracks it.
Glossary only: no implementation detail (that lives in the ADRs and `*_PLAN.md`).

## Language

**Residency**:
The property that a value is held in a register (rather than its frame slot) at a given
program point. The thing the allocator tries to maximise and the lowerer must track.

**Home**:
The physical register the allocator assigns to a vreg (the allocator's output, in
`vreg_to_phys`). A vreg with no register home is *spilled* (slot only).
_Avoid_: placement, assignment (when you mean the register specifically).

**Single source of truth (SSoT)**:
The design principle that residency at any point is *read* from one authoritative record,
never *re-derived*. Built *first*, as the deliberate foundation for ranged residency:
today the lowerer re-derives residency at render time (region computation + cross-BB
carries), which is both the shared root of the miscompile classes AND the thing that makes
ranged allocation unsafe to add. SSoT removes both at once.

**Ranged residency**:
Residency that varies across the program: one physical register holding different vregs
over disjoint intervals, or a value resident over only part of its live range. The
*destination* of the redesign (closes trailing-bench gaps). SSoT is sequenced before it not
because ranged is optional, but because ranged must be built *on* SSoT to be sound.
_Avoid_: live-range packing (that names today's partial, BC/stack/IY-only mechanism).

**Region-home-or-slot**:
The *current* residency model (ADR 0003): a vreg gets one home over a computed *region*,
all-or-nothing, else it is slot-only. The model the redesign moves away from.

**Region**:
The loop-aware, home-preserving-op span that `compute_home_region` proves at lower time —
the sub-function span over which a home stays register-resident. A *safety* span (validated
DE-clean), distinct from a liveness interval.
_Avoid_: interval, span (when you mean this specific proven region).

**Interval**:
A `[lo, hi]` op-index live span (`LiveRange`). Used for interference. Distinct from a
*region* (which adds loop-safety validation).
_Avoid_: range, region.

**Belief cache** (transient tenancy):
The lowerer's local record of what each physical register *physically holds right now*
(`L.rs.*`, plus the `bb_hl_out`/`bb_a_out` cross-BB carries). Covers ALL registers,
including the *bus* (HL, A); its job is reload avoidance. It is distinct from and *larger*
than the home table — it also tracks transient/scratch contents the allocator never sees.
For a homed value sitting in its home register the two agree (and that agreement is
checkable); for bus registers there is no home to derive from, so the belief cache is the
*only* record — lowerer-local and allocator-invisible. **SSoT governs homes, not bus
tenancy:** bus tracking (HL/A reload avoidance) is retained, not subsumed by the table.
_Avoid_: cache (unqualified).

**Proposer / Arbiter**:
The two halves of an allocation mechanism: a *proposer* nominates candidate vregs for a
register class; an *arbiter* picks winners and resolves conflicts.

**Home table** (`home_at`):
The allocator's output that the lowerer reads: for each value, which register it is homed
in over which interval (slot elsewhere). It is **not** a scratch free-list — the lowerer
never asks the allocator for a register. 80cc inverts the classic model: the lowerer's
per-op codegen has fixed register roles (see *Bus/Parking*); the allocator places
long-lived values into the parking registers in the gaps the fixed codegen leaves alone,
and tells the lowerer (1) where each value lives and (2) implicitly, which parking
registers are occupied across which interval. The lowerer reads placements; it does not
allocate scratch.

**Bus register / Parking register**:
The two-tier register model. *Bus* = HL and A — values pass through them (ALU/address
ports); not allocatable homes. *Parking* = DE, BC, IX, IY (+ their byte halves, alt-bank,
stack) — hold values across ops; the allocatable homes.

**Clean (of a register)**:
An op is *clean* w.r.t. a home register if lowering it preserves that register (e.g.
*DE-clean*). The predicate a region's validity is built from.

**Spill / Park**:
*Spill* = store a value to its frame slot. *Park* = push it to the stack (TOS) and pop at
its single use (`PR_STACK`). Both are the non-register fallbacks.

**Clobber-free window**:
A sub-interval of a value's live range over which its home register is provably *clean*
(un-clobbered) — the maximal span a *ranged home* can occupy without a save/restore. Its
boundaries are the clobbering ops (chiefly calls) that bracket it.

**Resident window**:
The span a value is *actually* homed over — live range ∩ `[home_lo, home_hi]`
(`hr_residency_window`). The *decision*, where a *clobber-free window* is the *capability*
(the maximal span a home could occupy). What `IR_HOME_VERIFY` checks for overlap, and what
ranged placement reads.
_Avoid_: home window, live window.

**Point interference**:
Two values needing the register at the same program *point* — both live out of one op, so
holes in a live range are honoured. Contrast the *interval* reading, which asks only whether
two `[lo, hi]` spans overlap and so reports a conflict across a hole where neither value is
live. Loop-body rounding is composed on top: both live anywhere in one loop span interfere.
_Avoid_: precise interference (a quality claim, not a mechanism).

**Call-crossing local**:
A local whose live range spans a call. Its home register is clobbered by the call, so a
ranged home for it must *save-around-call*. The dominant shape in emu.c's dense functions
(`dict_lookup` etc.) and the reason whole-function homes can't touch them.

**Save-around-call**:
Spilling a *ranged home* to its frame slot before a clobbering call and reloading after
(the slot doubles as the save location; or `push`/`pop` the pair). The mechanism that lets
a *call-crossing local* stay register-resident *between* calls. What sdcc does (176 push/pop
in dict_lookup to cut frame traffic 666→470).

**Byte-benefit gate** (density gate):
The admission test for a ranged home under a *density-primary* objective: home a value only
if the frame accesses it removes outweigh the save-around-call bytes it adds
(accesses-saved·per-access-cost > Σ save/restore cost over the window's clobbers). Ticks are
a hard guardrail (no regression), not the objective. Self-limits ranging to the values that
actually pay off.
