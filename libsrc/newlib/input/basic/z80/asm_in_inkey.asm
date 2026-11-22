
; ===============================================================
; feilipu Sept 2020
; ===============================================================
; 
; int in_inkey(void)
;
; Read instantaneous state of the keyboard and return ascii code
; if only one key is pressed.
;
; Note: Limited by basic here as it can only register one keypress.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_inkey

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

    rst 18h                     ; # waiting keys in A
    ld hl,0                     ; prepare exit
    or a
    ret Z                       ; return for no keys

    dec a
    scf
    ret NZ                      ; return carry set for too many keys

    rst 10h                     ; key in A
    ld l,a
    or a                        ; reset carry
    ret
