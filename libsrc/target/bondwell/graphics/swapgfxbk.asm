;
;       Bondwell 12/14 pseudo graphics routines
;
;       Stefano Bodrato 2021
;
;
;        Video memory paging.
;

                SECTION code_graphics
                PUBLIC    swapgfxbk
                PUBLIC    _swapgfxbk

                PUBLIC    swapgfxbk1
                PUBLIC    _swapgfxbk1



.swapgfxbk
._swapgfxbk
        ret


.swapgfxbk1
._swapgfxbk1
        ret


;        SECTION code_crt_init
;        EXTERN  __BSS_END_tail
;        EXTERN  __HIMEM_head
;        EXTERN  __HIMEM_END_tail
;        ld      hl,__BSS_END_tail
;        ld      de,__HIMEM_head
;        ld      bc,__HIMEM_END_tail - __HIMEM_head
;        ldir
