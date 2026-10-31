;
;	Sharp MZ-2500 specific routines
;
;	void mz2500_set_pixel_palette(uint8_t pixel, uint8_t entry) __smallc;
;
;	Choose which palette entry a pixel value (0-15, B | R << 1 | G << 2 | I << 3)
;	shows.  Power on state is the identity.
;

    SECTION code_clib
    PUBLIC  mz2500_set_pixel_palette
    PUBLIC  _mz2500_set_pixel_palette

mz2500_set_pixel_palette:
_mz2500_set_pixel_palette:
    pop     hl
    pop     de                          ; entry
    pop     bc                          ; pixel
    push    bc
    push    de
    push    hl
    ld      a,c
    and     $0f
    or      $80
    out     ($f4),a
    ld      a,e
    out     ($f5),a
    ret
