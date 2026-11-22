# ADR 0061 — Call-split eviction is coupled to pre-push narrowing

Status: **Accepted**, coupled. `IR_CS_EVICT=0/1` forces either way;
it otherwise defaults to whatever `prepush-narrow` is.

## Context

`cs-evict` lets a call-bounded split **evict** a picker-placed BC tenant it
out-benefits, instead of silently losing BC to whoever the picker placed first.

## Decision

Default it to `prepush-narrow`'s setting rather than to a fixed value.

The reason is that the arbitration gap **only becomes reachable** once the
narrowing admits whole-function BC candidates into functions with pre-pushed
calls. Tying the two means the default build stays byte-identical and the opt-in
configuration is self-contained — you cannot accidentally enable a pass whose
opportunity does not exist yet.

`IR_CS_EVICT=0/1` forces it either way, which is how to isolate the two when
attributing a change.

## Note

A gate whose default is another gate is unusual and worth keeping visible. The
alternative — defaulting it on — would have made the narrowing's measurements
un-attributable, because two passes would have started firing together.
