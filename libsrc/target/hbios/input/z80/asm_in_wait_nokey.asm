
; ===============================================================
; feilipu Jan 2020
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

EXTERN __BF_CIOIST, __BF_CIOIN
EXTERN asm_hbios

.asm_in_wait_nokey

    ; uses : potentially all (ix, iy saved for sdcc)

    ld bc,__BF_CIOIST<<8|0      ; direct console i/o input
    call asm_hbios              ; # waiting keys in A
    ld b,a
    or a
    ret Z                       ; return if no key pressed

.asm_in_wait_nokey_get          ; empty the buffer of keys captured
    push bc
    ld bc,__BF_CIOIN<<8|0       ; direct console i/o input
    call asm_hbios              ; key in E
    pop bc
    djnz asm_in_wait_nokey_get

    jr asm_in_wait_nokey        ; check again whether we have no keys pressed
