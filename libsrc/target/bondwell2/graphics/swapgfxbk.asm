;
;       Bondwell 2 pseudo graphics routines
;
;       Stefano Bodrato 2021
;
;
;        Video memory paging.
;

    SECTION code_graphics

    PUBLIC  __gfx_page_vram_in
    PUBLIC  ___gfx_page_vram_in

    PUBLIC  __gfx_page_vram_out
    PUBLIC  ___gfx_page_vram_out
    EXTERN  __bdos



__gfx_page_vram_in:
___gfx_page_vram_in:
    in      a, (2)                      ; PPIC, get current bank
    ld      (bankval), a

	;set VRAM bank
    ld      a, 1                        ; no mask, to keep the NMI disabled
    out     (2), a                      ; PPIC, set VRAM bank

    ret


__gfx_page_vram_out:
___gfx_page_vram_out:
    ld      a, (bankval)
    out     (2), a                      ; PPIC, restore previous memory bank
    ret


    SECTION bss_graphics

bankval:
    defb    0


    SECTION code_crt_init

    EXTERN  __BSS_END_tail
    EXTERN  __HIMEM_head
    EXTERN  __HIMEM_END_tail
    ld      hl, __BSS_END_tail
    ld      de, __HIMEM_head
    ld      bc, __HIMEM_END_tail-__HIMEM_head
    ldir

    ld      c, 2
    ld      e, 0x1a                     ;Clears screen, sets up VRAM at 0
    call    __bdos

