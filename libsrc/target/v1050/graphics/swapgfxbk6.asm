;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Visual 1050 by Stefano - 2025
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: swapgfxbk6.asm $
;


    SECTION code_clib
    PUBLIC  swapgfxbk
    PUBLIC  _swapgfxbk

    PUBLIC  swapgfxbk1
    PUBLIC  _swapgfxbk1
	
    EXTERN  v1050_sendchar


swapgfxbk:
_swapgfxbk:
	push    hl
	push    af
    ld      l, 27
    call    v1050_sendchar
    ld      l, ')'
    call    v1050_sendchar
    ld      l, '2'                      ; Select G2 for the extended font (pseudo-graphics)
    call      v1050_sendchar
	pop     af
	pop     hl
	ret

swapgfxbk1:
_swapgfxbk1:
	push    hl
	push    af
    ld      l, 27
    call    v1050_sendchar
    ld      l, ')'
    call    v1050_sendchar
    ld      l, '1'                      ; Go back to G1 (UDG symbols)
    call    v1050_sendchar
	pop     af
	pop     hl
	ret

