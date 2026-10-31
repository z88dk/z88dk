;
;	Sharp MZ-2500 specific routines
;
;	uint8_t mz2500_get_page(uint8_t window) __z88dk_fastcall;
;
;	The page currently mapped in a window.
;

    SECTION code_clib
    PUBLIC  mz2500_get_page
    PUBLIC  _mz2500_get_page

mz2500_get_page:
_mz2500_get_page:
    ld      a,i
    push    af
    di
    ld      a,l
    out     ($b4),a
    in      a,($b5)                     ; reading steps the window on, it is not used again
    ld      l,a
    ld      h,0
    pop     af
    ret     po
    ei
    ret
