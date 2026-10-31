;
;	Sharp MZ-2500 graphics (the IPL subtype)
;
;	void mz2500_gfx_init(void);
;	void mz2500_gfx_ink(uint8_t ink, uint8_t paper) __smallc;
;
;	The graphics library draws in software, directly in the video planes: 320x200 in 16 colours, four planes (blue, red, green, intensity) of 40 bytes
;	a line, bit 0 of a byte the leftmost pixel, a pixel value B | R << 1 | G << 2 | I << 3.  The IPL's services are not used for drawing (the IPL ROM
;	does not have the drawing calls: _PSET and the like are only there if an operating system has loaded them), only for the text console and the
;	keyboard, so the text screen stays on top of the graphics and print/cprintf/getk work.
;
;	mz2500_gfx_init sets graphics mode $14 (320x200, 16 colours, screen A), the 4096 colour palette (rather than the fixed digital colours), and the
;	pixel to palette map to the identity.  The palette is the IBM CGA one: bits 0-2 are blue, red, green at 2/3 intensity, bit 3 brightens (black + 3 is
;	dark grey, 7 light grey, 15 white).  clg() calls it.  Change entries with mz2500_set_palette.
;
;	mz2500_gfx_ink sets the colour (0-15) that plot and xorplot use, and the one that unplot and clg use.  Power on: ink 15, paper 0.
;

    SECTION code_clib

    PUBLIC  mz2500_gfx_init
    PUBLIC  _mz2500_gfx_init
    PUBLIC  mz2500_gfx_ink
    PUBLIC  _mz2500_gfx_ink
    PUBLIC  __mz2500_gfx_ink
    PUBLIC  __mz2500_gfx_paper
    PUBLIC  __mz2500_cg_setcolour
    PUBLIC  __mz2500_mask_table
    EXTERN  mz2500_set_mode

mz2500_gfx_init:
_mz2500_gfx_init:
    xor     a
    ld      (__mz2500_cg_col), a        ; the CG registers are set up again for the next colour
    ld      hl, $14
    call    mz2500_set_mode             ; 320x200, 16 colours (this leaves the text screen alone)
    ld      a, $0e                      ; the YM2203's port A bit 2 low: the CRTC uses the 4096 colour palette ($AE)
    out     ($c8), a
    in      a, ($c9)
    and     $fb
    out     ($c9), a
    ld      hl, palette
    ld      d, 0                        ; the entry
pal_loop:
    ld      a, d
    add     a, a
    ld      b, a
    ld      c, $ae
    ld      e, (hl)                     ; r << 4 | b
    inc     hl
    out     (c), e
    inc     b
    ld      e, (hl)                     ; g
    inc     hl
    out     (c), e
    ld      a, d                        ; the pixel value shows this entry
    or      $80
    out     ($f4), a
    ld      a, d
    out     ($f5), a
    inc     d
    ld      a, d
    cp      16
    jr      nz, pal_loop
    ret

; Set the CG registers for the read-modify-write page to PSET mode with a colour: a = the colour (0-15); changes only af.  The registers are only written
; when the colour is not the last one set.
__mz2500_cg_setcolour:
    push    bc
    ld      b, a                        ;b = the colour
    inc     a
    ld      c, a                        ;c = the colour + 1
    ld      a, (__mz2500_cg_col)
    cp      c
    jr      z, same
    ld      a, c
    ld      (__mz2500_cg_col), a
    ld      a, 4                        ;register 4 = $0F: all four planes take the colour's bits
    out     ($bc), a
    ld      a, $0f
    out     ($bd), a
    ld      a, 5                        ;register 5 = $4F: PSET, all four planes
    out     ($bc), a
    ld      a, $4f
    out     ($bd), a
    ld      c, b
    xor     a
cg_loop:
    out     ($bc), a                    ;registers 0-3: $FF for a plane whose bit is set in the colour
    rrc     c
    push    af
    sbc     a, a
    out     ($bd), a
    pop     af
    inc     a
    cp      4
    jr      nz, cg_loop
same:
    pop     bc
    ret

; void mz2500_gfx_ink(uint8_t ink, uint8_t paper) __smallc
mz2500_gfx_ink:
_mz2500_gfx_ink:
    pop     hl
    pop     de                          ; paper
    pop     bc                          ; ink
    push    bc
    push    de
    push    hl
    ld      a, e
    and     15
    ld      (__mz2500_gfx_paper), a
    ld      a, c
    and     15
    xor     15                          ; (kept inverted, so that the power on state of 0 is white)
    ld      (__mz2500_gfx_ink), a
    ret

    SECTION rodata_clib
__mz2500_mask_table:
    defb    1, 2, 4, 8, 16, 32, 64, 128

; r << 4 | b, g: black, blue, red, magenta, green, cyan, yellow (brown), light grey, then the bright ones
palette:
    defb    $00, $0                     ; 0 black
    defb    $0a, $0                     ; 1 blue
    defb    $a0, $0                     ; 2 red
    defb    $aa, $0                     ; 3 magenta
    defb    $00, $a                     ; 4 green
    defb    $0a, $a                     ; 5 cyan
    defb    $a0, $a                     ; 6 yellow
    defb    $aa, $a                     ; 7 light grey
    defb    $55, $5                     ; 8 dark grey
    defb    $5f, $5                     ; 9 bright blue
    defb    $f5, $5                     ; 10 bright red
    defb    $ff, $5                     ; 11 bright magenta
    defb    $55, $f                     ; 12 bright green
    defb    $5f, $f                     ; 13 bright cyan
    defb    $f5, $f                     ; 14 bright yellow
    defb    $ff, $f                     ; 15 white

    SECTION bss_clib
__mz2500_gfx_ink:   defb    0           ; the ink xor 15
__mz2500_gfx_paper: defb    0
__mz2500_cg_col:    defb    0           ; the colour the CG registers are set to, plus 1 (0: not set)
