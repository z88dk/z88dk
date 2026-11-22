;
;	Sharp MZ-2500 specific routines
;
;	void mz2500_map_planes(uint8_t first_window, uint8_t screen) __smallc;
;
;	Map the four planes (blue, red, green, intensity) of video screen 0-3
;	(A-D) into four consecutive windows starting at first_window (0-4).
;	Page = $20 + (screen & 1) + plane * 2 + (screen >> 1) * 8.
;

    SECTION code_clib
    PUBLIC  mz2500_map_planes
    PUBLIC  _mz2500_map_planes

mz2500_map_planes:
_mz2500_map_planes:
    pop     hl
    pop     de                          ; screen
    pop     bc                          ; first window
    push    bc
    push    de
    push    hl
    ld      a,e
    and     1
    ld      l,a
    ld      a,e
    and     2
    add     a,a
    add     a,a                         ; (screen >> 1) * 8
    or      l
    or      $20
    ld      e,a                         ; page of the blue plane
    ld      a,i
    push    af
    di
    ld      a,c
    out     ($b4),a
    ld      a,e
    out     ($b5),a                     ; the window steps on with each write
    add     a,2
    out     ($b5),a
    add     a,2
    out     ($b5),a
    add     a,2
    out     ($b5),a
    pop     af
    ret     po
    ei
    ret
