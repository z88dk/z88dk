

        SECTION code_clib
        EXTERN  __gfx_vram_page_out
        PUBLIC  __oz_gfxend

__oz_gfxend:
        call    __gfx_vram_page_out
        pop     ix                      ;restore callers
        ret

