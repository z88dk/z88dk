
; ===============================================================
; feilipu Jan 2020
; ===============================================================
; 
; void in_wait_key(void)
;
; Busy wait until a key is pressed.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_wait_key

.asm_in_wait_key

    ; exit : if one key is pressed
    ;
    ; uses : potentially all (ix, iy saved for sdcc)

    jp 0x0010                   ; direct console i/o input, blocking call, key in A
