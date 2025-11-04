

        SECTION code_clib
        EXTERN  __gfx_page_vram_out
        PUBLIC  __oz_gfxend

__oz_gfxend:
        call    __gfx_page_vram_out
        pop     ix                      ;restore callers
        ret

