; int bit_save_block_zx(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

        PUBLIC  bit_save_block_zx
        PUBLIC  _bit_save_block_zx

        EXTERN  asm_bit_save_block_zx

bit_save_block_zx:
_bit_save_block_zx:

        pop     hl
        pop     bc
        ld      a, c
        pop     de
        pop     bc
        push    bc
        push    de
        push    bc
        push    hl

        jp      asm_bit_save_block_zx
