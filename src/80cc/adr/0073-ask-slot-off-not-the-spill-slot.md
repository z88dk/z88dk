# ADR 0073 — Ask `slot_off`, not `vreg_spill_slot`

Status: **Accepted**. A correctness-and-cost rule about which query to ask.

## The rule

**Spilled is not the same as having an address**, and **having a spill slot is
not the same as being addressable**.

A rematerialisable constant (`LD_IMM` / `LD_SYM` / remat LEA) is `IR_PR_SPILL`
but **NO_SLOT**, so `slot_off` returns −1 and a caller that assumed otherwise
emits `ld hl,-1; add hl,sp` — an address below sp, which the byte walk then
compares against.

So ask **`slot_off`**, which is what the caller actually emits from.

## The trap on the other side

Asking `vreg_spill_slot` instead **also rejects every PARAMETER**: a param is
homed in the caller's frame, so it has no spill slot (−1) while `slot_off`
returns a perfectly good offset.

That cost `structbench`'s `i < n` its byte-walk compare, which forced the bound
into DE, which evicted the running sum to a stack-transient home — **three
pop/push pairs per iteration, +10.5 % on z80 sp for 117 B**.

One wrong query, three passes downstream, a 10 % regression. Ask the query the
emitter uses.
