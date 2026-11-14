;
;      Bit unpacking code for SD/MMC card
;
;      Stefano, 2012
;	Modified November 2026 feilipu.
;
; unsigned long UNSTUFF_BITS(unsigned char *resp, unsigned int start, unsigned int size)
;

    PUBLIC  UNSTUFF_BITS_callee
    PUBLIC  _UNSTUFF_BITS_callee
    PUBLIC  asm_UNSTUFF_BITS

    EXTERN  extract_bits_sub
    EXTERN  sd_c_ret
    EXTERN  sd_c_return_dehl

UNSTUFF_BITS_callee:
_UNSTUFF_BITS_callee:
    pop     hl                          ; gbz80 has no ex (sp),hl. vm1: not pop af
    ld      (sd_c_ret), hl
    pop     bc
    pop     de
    pop     hl
    call    asm_UNSTUFF_BITS
    jp      sd_c_return_dehl

asm_UNSTUFF_BITS:
    push    hl
    ld      hl, 128                     ; bit count start on the rightmost bit of the 16 bytes block
;	8080: sub then sbc, not sbc hl. ld de,hl is the cheap pair copy.
    ld      a, l
    sub     e
    ld      l, a
    ld      a, h
    sbc     a, d
    ld      h, a
    ld      a, l
    sbc     a, c
    ld      l, a
    ld      a, h
    sbc     a, b
    ld      h, a
    ld      de, hl
    pop     hl
    jp      extract_bits_sub
