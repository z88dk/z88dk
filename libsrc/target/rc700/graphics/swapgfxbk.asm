;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;
;       Page the graphics bank in/out - used by all gfx functions
;       Version for the TRS80 Model II CP/M
;
;       Stefano Bodrato - 2025
;
;
;	$Id: swapgfxbk.asm $
;


    SECTION code_clib

    PUBLIC  swapgfxbk
    PUBLIC  _swapgfxbk

    PUBLIC  swapgfxbk1
    PUBLIC  _swapgfxbk1


swapgfxbk:
_swapgfxbk:

 ;   di
    ret



swapgfxbk1:
_swapgfxbk1:
extern __bdos

    ld      e,6         ; Home cursor
    ld      c,2
    call    __bdos
    ld      e,32
    ld      c,2
    call    __bdos
    ld      e,32
    ld      c,2
    call    __bdos

    ld      e,148       ; Force graphics character set
    ld      c,2
    jp     __bdos

