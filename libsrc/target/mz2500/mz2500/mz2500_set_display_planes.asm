;
;	Sharp MZ-2500 specific routines
;
;	void mz2500_set_display_planes(uint8_t mask) __z88dk_fastcall;
;
;	Which video planes are displayed: low nibble = screen A's B, R, G, I,
;	high nibble = screen B's.
;

    SECTION code_clib
    PUBLIC  mz2500_set_display_planes
    PUBLIC  _mz2500_set_display_planes

mz2500_set_display_planes:
_mz2500_set_display_planes:
    ld      a,$18
    out     ($bc),a
    ld      a,l
    out     ($bd),a
    ret
