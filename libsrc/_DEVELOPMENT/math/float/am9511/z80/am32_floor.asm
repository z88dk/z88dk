
SECTION code_fp_am9511

EXTERN __IO_APU_CONTROL
EXTERN __IO_APU_OP_FSUB

EXTERN asm_am9511_discardfraction

EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popf

PUBLIC asm_am9511_floor_fastcall

; Entry: dehl = floating point number
.asm_am9511_floor_fastcall
    call asm_am9511_discardfraction
    bit 7,d
    ret Z

.was_negative
    ; And subtract 1
    call asm_am9511_pushf_fastcall  ; x
    ld de,$3f80
    ld hl,$0000
    call asm_am9511_pushf_fastcall  ; y
    
    ld a,__IO_APU_OP_FSUB
    out (__IO_APU_CONTROL),a        ; x - y

    jp asm_am9511_popf

