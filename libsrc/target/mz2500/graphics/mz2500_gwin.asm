;
;	Sharp MZ-2500: borrowing a window of the Z80's address space for the video RAM
;
;	The program's memory map belongs to the program, so drawing code does not own a window: it takes the one the crt names (__MZ2500_GFX_WINDOW, see
;	mz2500_crt0.asm), maps a page of video RAM into it, and puts back the page that was there.  With interrupts off while it is borrowed, and the
;	stack and the running code not in it, that works in any memory map.
;
;	All of these change only af.  The caller brackets them with l_push_di and l_pop_ei:
;
;	  call l_push_di
;	  call __mz2500_gwin_save       ; remember the page that is in the window
;	  ld a, page / call __mz2500_gwin_map    ; (as often as needed)
;	  call __mz2500_gwin_restore    ; put it back
;	  call l_pop_ei
;
;	__mz2500_gfx_clear fills the whole screen (all four planes) with a colour; it brackets itself, one plane at a time, so interrupts are off for a plane
;	(about 28 ms) rather than for the screen.
;

    SECTION code_clib

    PUBLIC  __mz2500_gwin_save
    PUBLIC  __mz2500_gwin_map
    PUBLIC  __mz2500_gwin_restore
    PUBLIC  __mz2500_gfx_clear
    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  __MZ2500_GFX_WINDOW
    EXTERN  __MZ2500_GFX_BASE
    EXTERN  __MZ2500_GFX_PAGE

__mz2500_gwin_save:
    ld      a, __MZ2500_GFX_WINDOW
    out     ($b4), a
    in      a, ($b5)
    ld      (__mz2500_gwin_page), a
    ret

; a = the page
__mz2500_gwin_map:
    push    af
    ld      a, __MZ2500_GFX_WINDOW
    out     ($b4), a                    ;(writing the page steps the window on, so it is selected each time)
    pop     af
    out     ($b5), a
    ret

__mz2500_gwin_restore:
    ld      a, (__mz2500_gwin_page)
    jr      __mz2500_gwin_map

; a = the colour (0-15).  Uses af, bc, de, hl
__mz2500_gfx_clear:
    ld      c, a
    ld      b, __MZ2500_GFX_PAGE
clear_plane:
    xor     a
    rrc     c                           ;the colour's bit for this plane
    jr      nc, clear_value
    cpl
clear_value:
    ld      d, a
    push    bc
    call    l_push_di
    call    __mz2500_gwin_save
    ld      a, b
    call    __mz2500_gwin_map
    ld      hl, __MZ2500_GFX_BASE
    ld      (hl), d
    ld      de, __MZ2500_GFX_BASE + 1
    ld      bc, 7999
    ldir
    call    __mz2500_gwin_restore
    call    l_pop_ei
    pop     bc
    inc     b
    inc     b
    ld      a, b
    cp      __MZ2500_GFX_PAGE + 8
    jr      nz, clear_plane
    ret

    SECTION bss_clib
__mz2500_gwin_page: defb    0           ; the page that was in the window
