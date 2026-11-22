
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

EXTERN __BF_CIOIN
EXTERN asm_hbios

.asm_in_wait_key

    ; exit : if one key is pressed
    ;
    ; uses : potentially all (ix, iy saved for sdcc)
    
    ld bc,__BF_CIOIN<<8|0       ; direct console i/o input, blocking call
    jp asm_hbios                ; key in E
