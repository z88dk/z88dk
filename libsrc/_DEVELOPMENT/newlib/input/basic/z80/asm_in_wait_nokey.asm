
; ===============================================================
; feilipu Sept 2020
; ===============================================================
; 
; void in_wait_nokey(void)
;
; Busy wait until no keys are pressed.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_wait_nokey

.asm_in_wait_nokey

    ; uses : potentially all (ix, iy saved for sdcc)

    rst 18h                     ; # waiting keys in A
    ld b,a
    or a
    ret Z                       ; return if no key pressed

.asm_in_wait_nokey_get          ; empty the buffer of keys captured
    rst 10h                     ; key in A
    djnz asm_in_wait_nokey_get

    jr asm_in_wait_nokey        ; check again whether we have no keys pressed
