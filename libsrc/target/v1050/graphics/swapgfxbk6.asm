;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Visual 1050 by Stefano - 2025
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: __gfx_vram_page_in6.asm $
;


    SECTION code_clib
    PUBLIC  __gfx_vram_page_in
    PUBLIC  ___gfx_vram_page_in

    PUBLIC  __gfx_vram_page_out
    PUBLIC  ___gfx_vram_page_out
	
    EXTERN  v1050_sendchar


__gfx_vram_page_in:
___gfx_vram_page_in:
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

__gfx_vram_page_out:
___gfx_vram_page_out:
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

