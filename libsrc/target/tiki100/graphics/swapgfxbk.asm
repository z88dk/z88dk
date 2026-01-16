;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 15/10/98
;
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;	CAVEAT
;	CAVEAT	Always call __gfx_vram_page_out IMMEDIATELY after you are
;	CAVEAT	done with accessing video RAM using __gfx_vram_page_in.
;	CAVEAT
;
;	$Id: __gfx_vram_page_in.asm,v 1.2 2017-01-02 22:57:59 aralbrec Exp $
;

    SECTION code_graphics
    PUBLIC  __gfx_vram_page_in
    PUBLIC  ___gfx_vram_page_in

    PUBLIC  __gfx_vram_page_out
    PUBLIC  ___gfx_vram_page_out


__gfx_vram_page_in:
___gfx_vram_page_in:
    di
    ex      af, af
    ld      a, ($FFC8)                  ; Copy of system register
    or      $08                         ; select graphics RAM bank
    out     ($1C), a                    ; System register (page-in gfx RAM)
    ex      af, af
    ret

__gfx_vram_page_out:
___gfx_vram_page_out:
    ex      af, af
    ld      a, ($FFC8)                  ; Copy of system register
    out     ($1C), a                    ; System register (page-out gfx RAM)
    ex      af, af
    ei
    ret

    SECTION code_crt_init

    EXTERN  __BSS_END_tail
    EXTERN  __HIMEM_head
    EXTERN  __HIMEM_END_tail

    ld      hl, __BSS_END_tail
    ld      de, __HIMEM_head
    ld      bc, __HIMEM_END_tail-__HIMEM_head
    ldir

; TODO: Copy graphics to high memory
