
; With -clib=mk2 the graphics routines are linked at CRT_ORG_GRAPHICS, out of
; the way of the GVRAM that is paged in at $8000 - $BFFF. The loader puts
; them straight after the program, so move them to where they belong.
; This must stay in low memory because it runs before the move is done.

    SECTION code_clib
    PUBLIC  __pc8001_hires_init
    EXTERN  __BSS_END_tail
    EXTERN  __HIMEM_head
    EXTERN  __HIMEM_END_tail

__pc8001_hires_init:
    ld      hl, __BSS_END_tail
    ld      de, __HIMEM_head
    ld      bc, __HIMEM_END_tail-__HIMEM_head
    ldir
    ret
