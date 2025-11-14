; int bit_save_nassys(void *addr, void *endaddr)
; CALLER linkage for function pointers

    PUBLIC  bit_save_nassys
    PUBLIC  _bit_save_nassys

    EXTERN  asm_bit_save_nassys

bit_save_nassys:
_bit_save_nassys:

    pop     af
    pop     de
    pop     hl
    push    hl
    push    de
    push    af

    jp      asm_bit_save_nassys
