;
;       Kaypro II pseudo graphics routines
;       Version for the standard text symbols
;
;       Stefano Bodrato 2018
;
;
;        Video memory paging.
;

    SECTION code_graphics
    PUBLIC  __gfx_page_vram_in
    PUBLIC  ___gfx_page_vram_in

    PUBLIC  __gfx_page_vram_out
    PUBLIC  ___gfx_page_vram_out



__gfx_page_vram_in:
___gfx_page_vram_in:
    ex      af, af
    in      a, ($1c)
    set     7, a                        ; video page on
    out     ($1c), a
    ex      af, af
    ret

__gfx_page_vram_out:
___gfx_page_vram_out:
    ex      af, af
    in      a, ($1c)
    res     7, a                        ; video page off
    out     ($1c), a
    ex      af, af
    ret

    SECTION code_crt_init
    EXTERN  __BSS_END_tail
    EXTERN  __HIMEM_head
    EXTERN  __HIMEM_END_tail
    ld      hl, __BSS_END_tail
    ld      de, __HIMEM_head
    ld      bc, __HIMEM_END_tail-__HIMEM_head
    ldir
