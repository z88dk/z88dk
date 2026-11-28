
; Select the mkII graphics mode. This is called by the console ioctl.
;
; Entry: a = 0 for no graphics (semigraphics only)
;            1 for 640x200 mono
;            2 for 320x200 4 colour
;
; The text columns are set by the caller. Port $31 can't be read back, so
; N-BASIC's copy of it ($E6C6) is kept up to date.

    SECTION code_graphics
    PUBLIC  __pc8001_hires_setmode
    EXTERN  __pc8001_gfxmode
    EXTERN  l_push_di
    EXTERN  l_pop_ei

__pc8001_hires_setmode:
    ld      (__pc8001_gfxmode), a
    ld      c, 0                        ;graphics off
    and     a
    jr      z, got_bits
    ld      c, @11101100                ;graphics on, mono, white
    cp      1
    jr      z, got_bits
    ld      c, @11111000                ;graphics on, 320x200, white
got_bits:
    call    l_push_di
    ld      a, $e4                      ;DMA: channel 2 with extended write
    out     ($68), a
    ld      hl, $e6c6
    ld      a, (hl)
    and     @00000011                   ;keep the ROM and memory mode bits
    or      c
    ld      (hl), a
    out     ($31), a
    call    l_pop_ei
    ret
