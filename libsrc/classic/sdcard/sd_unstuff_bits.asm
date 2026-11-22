; unsigned long unstuff_bits(unsigned char *resp, unsigned int start, unsigned int size)
; CALLER linkage for function pointers
;	Modified November 2026 feilipu.

    SECTION code_driver

    PUBLIC  unstuff_bits
    PUBLIC  _unstuff_bits

    EXTERN  asm_unstuff_bits

unstuff_bits:
_unstuff_bits:
    ld      hl, 2
    add     hl, sp                      ; 8080: ld hl,sp+n clobbers C
    ld      c, (hl+)
    ld      b, (hl+)                    ; size
    ld      e, (hl+)
    ld      d, (hl+)                    ; start
    ld      a, (hl+)
    ld      h, (hl)
    ld      l, a                        ; response
    jp      asm_unstuff_bits
