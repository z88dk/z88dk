
; ===============================================================
; feilipu Jan 2020
; ===============================================================
; 
; int in_inkey(void)
;
; Read instantaneous state of the keyboard and return ascii code
; if only one key is pressed.
;
; Note: Limited by cpm here as it can only register one keypress.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_inkey

EXTERN __BF_CIOIST, __BF_CIOIN
EXTERN asm_hbios

.asm_in_inkey

    ; exit : if one key is pressed
    ;
    ;           hl = ascii code
    ;           carry reset
    ;
    ;         if no keys are pressed
    ;
    ;            hl = 0
    ;            carry reset
    ;
    ;         if more than one key is pressed
    ;
    ;            hl = 0
    ;            carry set
    ;
    ; uses : potentially all (ix, iy saved for sdcc)

    ld bc,__BF_CIOIST<<8|0      ; direct console i/o test
    call asm_hbios              ; result in A
    ld hl,0                     ; prepare exit
    or a
    ret Z                       ; return for no keys

    dec a
    scf
    ret NZ                      ; return carry set for too many keys

    ld bc,__BF_CIOIN<<8|0       ; direct console i/o input
    call asm_hbios              ; key in E
    ld l,e
    xor a                       ; reset carry
    ld h,a                      ; make sure H is reset
    ret
