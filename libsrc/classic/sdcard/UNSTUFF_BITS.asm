; unsigned long UNSTUFF_BITS(unsigned char *resp, unsigned int start, unsigned int size)
; CALLER linkage for function pointers
;	Modified November 2026 feilipu.

    PUBLIC  UNSTUFF_BITS
    PUBLIC  _UNSTUFF_BITS

    EXTERN  asm_UNSTUFF_BITS
    EXTERN  sd_c_ret
    EXTERN  sd_c_return_dehl

UNSTUFF_BITS:
_UNSTUFF_BITS:
    pop     hl
    ld      (sd_c_ret), hl
    pop     bc
    pop     de
    pop     hl
    push    hl
    push    de
    push    bc
    call    asm_UNSTUFF_BITS
    jp      sd_c_return_dehl
