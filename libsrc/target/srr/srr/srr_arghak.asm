; This routine takes the first 7 args on the stack
; and places them contiguously at the "args" ram area.
; This allows a library routine to make one call    to arghak
; and henceforth have all it's args available directly
; through lhld's instead of having to hack the stack as it
; grows and shrinks. Note that arghak should be called as the
; VERY FIRST THING a function does
;

SECTION code_clib

PUBLIC srr_arghak
EXTERN srr_args

srr_arghak:
    LD  DE,srr_args ;destination for block move in DE
    LD  HL,4    ;pass over two return address
    ADD HL,SP   ;source for block move in HL

    LD  B,14    ;countdown in B
srr_arghk2:
    LD  A,(HL)  ;copy loop
    LD  (DE),A
    INC HL
    INC DE
    DEC B
    JP  NZ,srr_arghk2

    RET

