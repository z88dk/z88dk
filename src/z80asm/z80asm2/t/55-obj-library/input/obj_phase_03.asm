; Issue #3024
; The PHASE directive adds to the org, but only sometimes

ORG $0100

PHASE $0300
foo:
    ld hl, $    ;[0000] 21 00 04; should be 21 00 03
    jp foo      ;[0003] c3 00 03
DEPHASE
