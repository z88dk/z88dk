;
;	Samsung SPC-1500 specific routines
;
;	void spc1500_gfx_init(void);
;	void spc1500_gfx_ink(uint8_t ink, uint8_t paper) __smallc;
;
;	The graphics screen: the 40 column mode, 320x200 in eight colours: three
;	bit planes (blue, red and green: a pen is the Spectrum's bits, 1 blue, 2
;	red, 4 green) of 40 bytes a
;	pixel row, a byte's leftmost pixel its bit 7.  The planes are not in the
;	Z80's memory but behind I/O ports (OUT (C),A and IN A,(C), the whole of
;	BC the address): blue at
;	$4000, red at $8000 and green at $C000, and the byte for pixel row y at
;	x is at (y & 7) * $800 + (y >> 3) * 40 + x / 8 in a plane.
;	gfx_init puts the machine in that mode: the 6845's registers (40 columns
;	of 8 line characters, 25 rows: the IPL's 40 column timing for the rest),
;	the 8255's port C for 40
;	columns, the palette (pen n the colour n) and the graphics over the text
;	layer everywhere, which is cleared.  Nothing else needs doing: the
;	planes are always there.
;	Plot, unplot, xorplot, clg and the console share the ink and paper pens
;	(default 7 and 0): textcolor and textbackground set them, and so does
;	spc1500_gfx_ink.
;

    SECTION code_clib
    PUBLIC  spc1500_gfx_init
    PUBLIC  _spc1500_gfx_init
    PUBLIC  spc1500_gfx_ink
    PUBLIC  _spc1500_gfx_ink
    PUBLIC  __spc1500_gfx_clear
    EXTERN  __spc1500_con_ink
    EXTERN  __spc1500_con_paper
    EXTERN  __spc1500_palette

spc1500_gfx_init:
_spc1500_gfx_init:
    ld      hl, crtc                    ; the 6845's registers 0 to 13
    ld      bc, $1800
    ld      d, 0
    ld      e, 14
crtc_loop:
    out     (c), d
    inc     c
    ld      a, (hl)
    out     (c), a
    dec     c
    inc     hl
    inc     d
    dec     e
    jr      nz, crtc_loop
    ld      bc, $1a03                   ; the 8255's bit set: port C bit 6, the 40 column mode (the IPL's value for it: $F2)
    ld      a, $0d
    out     (c), a
    ld      hl, __spc1500_palette
    ld      (hl), $aa                   ; the palette: pen n is the colour n (the pens' bits: blue $AA, red $CC, green $F0)
    inc     hl
    ld      (hl), $cc
    inc     hl
    ld      (hl), $f0
    ld      bc, $1000
    ld      a, $aa
    out     (c), a
    ld      b, $11
    ld      a, $cc
    out     (c), a
    ld      b, $12
    ld      a, $f0
    out     (c), a
    ld      bc, $1300                   ; the graphics over the text layer for every pen
    ld      a, $ff
    out     (c), a
    ld      bc, $2000                   ; the text layer's attributes and codes 0: nothing over the graphics
    call    clear_text
    ld      bc, $3000
clear_text:
    ld      de, 2048
clear_text_loop:
    xor     a
    out     (c), a
    inc     bc
    dec     de
    ld      a, d
    or      e
    jr      nz, clear_text_loop
    ret

; The 40 column mode with 8 line characters: R0-R3 as the IPL's 40 column mode,
; R4 31 and R5 6 (262 lines), R6 25 rows, R7 28, R9 7, the cursor off
    SECTION rodata_clib
crtc:
    defb    $38, $28, $30, $44, $1f, $06, $19, $1c, $00, $07, $20, $07, $00, $00

    SECTION code_clib
; void spc1500_gfx_ink(uint8_t ink, uint8_t paper) __smallc
spc1500_gfx_ink:
_spc1500_gfx_ink:
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)                     ; paper
    and     7
    ld      (__spc1500_con_paper), a
    inc     hl
    inc     hl
    ld      a, (hl)                     ; ink
    and     7
    ld      (__spc1500_con_ink), a
    ret

; Clear the screen to the pen in a: each plane's 16 KB (the whole of it, whether
; or not the screen shows it) to all ones or all zeros.  Uses af, bc, e, l.
__spc1500_gfx_clear:
    ld      l, a                        ; l = the pen
    ld      bc, $4000                   ; blue: the pen's bit 0
    ld      a, l
    rra
    call    clear_plane
    ld      bc, $8000                   ; red: bit 1
    ld      a, l
    rra
    rra
    call    clear_plane
    ld      bc, $c000                   ; green: bit 2
    ld      a, l
    rra
    rra
    rra
; the carry = the plane's value, bc = the plane's first address
clear_plane:
    sbc     a, a                        ; $FF or $00
    ld      e, 64                       ; the 64 pages of 256 bytes
clear_page:
    REPT 16
    out     (c), a
    inc     c
    ENDR
    jr      nz, clear_page
    inc     b
    dec     e
    jr      nz, clear_page
    ret
