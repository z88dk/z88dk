;
;       Otrona Attachè graphics routines
;		direct video HW access
;
;       Stefano Bodrato 2018
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;	$Id: w_plotpixl.asm $
;


    INCLUDE "graphics/grafix.inc"

    SECTION smc_clib
    PUBLIC  w_plotpixel

    EXTERN  l_cmp
    EXTERN  plot_setup

w_plotpixel:
    push    hl
    ld      hl, maxy
    call    l_cmp
    pop     hl
    ret     nc                          ; Return if Y overflows

    push    de
    ld      de, maxx
    call    l_cmp
    pop     de
    ret     c                           ; Return if X overflows

    call    plot_setup
    OR      $40                         ; SMC instruction changed from RES to SET

    AND     0E7H                        ; mask for SMC code
    OR      B
    XOR     18H                         ; @11000: mask for the the 2 changed bits

    LD      (GRFBIT+1), A

						;CALL	XDDR			; SET X ADDRESS
    LD      A, L                        ; X COORDINATE IN [HL]
    AND     0FCH                        ; @11111100, mask out the 2 rightmost bits
    OR      H
    RRCA
    RRCA

    LD      B, A
    LD      C, 0FEH                     ; DISPLAY DATA
    IN      A, (C)
GRFBIT:
    SET     0, A                        ; MODIFIED BIT SET
    OUT     (C), A

    EI
    RET

