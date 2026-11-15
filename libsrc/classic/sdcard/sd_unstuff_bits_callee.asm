;
;      Bit unpacking code for SD/MMC card
;
;      Stefano, 2012
;	Modified November 2026 feilipu.
;
; unsigned long unstuff_bits(unsigned char *resp, unsigned int start, unsigned int size)
;

    PUBLIC  unstuff_bits_callee
    PUBLIC  _unstuff_bits_callee
    PUBLIC  asm_unstuff_bits

    EXTERN  extract_bits_sub

unstuff_bits_callee:
_unstuff_bits_callee:
    pop     hl                          ; gbz80 has no ex (sp),hl. vm1: not pop af
    pop     bc                          ; size
    pop     de                          ; start
    push    hl                          ; return sits above the response pointer
    ld      hl, 2
    add     hl, sp
    ld      a, (hl+)
    ld      h, (hl)
    ld      l, a
; BC and DE are live. Copy the return over the response pointer.
    push    hl
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)
    ld      hl, 4
    add     hl, sp
    ld      (hl), a
    ld      hl, 3
    add     hl, sp
    ld      a, (hl)
    ld      hl, 5
    add     hl, sp
    ld      (hl), a
    pop     hl
    inc     sp
    inc     sp
    jp      asm_unstuff_bits

asm_unstuff_bits:
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
