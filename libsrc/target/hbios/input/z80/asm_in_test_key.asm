
; ===============================================================
; feilipu Jan 2020
; ===============================================================
; 
; int in_test_key(void)
;
; Return true if a key is currently pressed.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_test_key

EXTERN __BF_CIOIST
EXTERN asm_hbios

.asm_in_test_key

    ; exit : NZ flag set if a key is pressed
    ;         Z flag set if no key is pressed
    ;
    ; uses : potentially all (ix, iy saved for sdcc)

    ld bc,__BF_CIOIST<<8|0      ; direct console i/o test
    call asm_hbios              ; result in A
    ld l,a
    ld h,0                      ; make sure H is reset
    or a                        ; reset carry
    ret
