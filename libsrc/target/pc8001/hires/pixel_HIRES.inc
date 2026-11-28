; Generic code to handle the pixel commands in the mkII hires modes
; Define NEEDxxx before including
;
; The GVRAM is paged in at $8000 - $BFFF, so this code must live outside
; that range (it is in code_driver, at the start of the program) and
; everything it needs from memory (variables, the font) has to be read before
; the plane is selected.
;
; Only plane 0 is used. Mode 1 is 640x200, one bit per pixel. Mode 2 is
; 320x200, two bits per pixel (four pixels per byte). Both are 80 bytes per row.
;
; Entry: hl = x, de = y

    INCLUDE "target/pc8001/hires/gvram.inc"
    INCLUDE "target/pc8001/hires/allram_only.inc"

    EXTERN  getmaxy
    EXTERN  getmaxx
    EXTERN  l_cmp
    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  __gfx_coords
    EXTERN  __pc8001_gfxmode
    EXTERN  __pc8001_ink

    push    hl                          ;save x
    call    getmaxy                     ;hl = max y
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc

    ex      de, hl                      ;de = x, hl = y
    push    hl                          ;save y
    call    getmaxx
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc
    ex      de, hl
    ld      (__gfx_coords), hl          ;x
    ld      (__gfx_coords+2), de        ;y
    push    bc

    ld      a, (__pc8001_gfxmode)
    ld      b, a                        ;b = 1 (640x200) or 2 (320x200)
    ld      a, (__pc8001_ink)
    ld      c, a                        ;c = ink for the 4 colour mode

    push    hl                          ;x
    ld      h, 0
    ld      l, e                        ;hl = y
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl                      ;y * 16
    ld      d, h
    ld      e, l
    add     hl, hl
    add     hl, hl                      ;y * 64
    add     hl, de                      ;y * 80
    ld      de, GVRAM
    add     hl, de                      ;hl = start of the row
    pop     de                          ;de = x

    ld      a, e                        ;keep the pixel position in the byte
    dec     b
    jr      nz, four_colour

    ; 640x200: 8 pixels per byte, the leftmost is bit 7
    srl     d
    rr      e
    srl     d
    rr      e
    srl     d
    rr      e                           ;x / 8
    add     hl, de
    and     7
    ld      b, a
    ld      a, $80
    jr      z, have_mask
mono_shift:
    rrca
    djnz    mono_shift
have_mask:
    ld      d, a                        ;d = mask of the pixel
    ld      e, a                        ;e = value to write
    jr      do_pixel

four_colour:
    ; 320x200: 4 pixels per byte, the leftmost is bits 7 and 6
    srl     d
    rr      e
    srl     d
    rr      e                           ;x / 4
    add     hl, de
    and     3
    add     a                           ;shift count (0, 2, 4, 6)
    ld      b, a
    ld      a, c
    rrca
    rrca                                ;ink in bits 7 and 6
    ld      e, a
    ld      a, $c0
    inc     b                           ;Is the shift count 0?
    dec     b
    jr      z, four_shifted
four_shift:
    rrca
    rrc     e
    djnz    four_shift
four_shifted:
    ld      d, a                        ;d = mask of the pixel
                                        ;e = value to write
do_pixel:
    call    l_push_di
    out     ($5c), a                    ;Plane 0
IF  NEEDplot
    ld      a, d
    cpl
    and     (hl)
    or      e
    ld      (hl), a
ENDIF
IF  NEEDunplot
    ld      a, d
    cpl
    and     (hl)
    ld      (hl), a
ENDIF
IF  NEEDxor
    ld      a, (hl)
    xor     e
    ld      (hl), a
ENDIF
IF  NEEDpoint
    ld      a, (hl)
    and     d                           ;Is the pixel set?
    ld      e, a
ENDIF
    out     ($5f), a                    ;Back to main memory
    call    l_pop_ei
IF  NEEDpoint
    ld      a, e
    and     a
ENDIF
    pop     bc                          ;Restore callers
    ret
