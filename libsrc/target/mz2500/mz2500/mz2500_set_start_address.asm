;
;	Sharp MZ-2500 specific routines
;
;	void mz2500_set_start_address(uint16_t addr) __z88dk_fastcall;
;
;	Offset in the video planes where the display starts (SAD0); this is the
;	hardware scroll.  It wraps at the SAD1 register ($12/$13).
;

    SECTION code_clib
    PUBLIC  mz2500_set_start_address
    PUBLIC  _mz2500_set_start_address

mz2500_set_start_address:
_mz2500_set_start_address:
    ld      a,$10
    out     ($bc),a
    ld      a,l
    out     ($bd),a
    ld      a,$11
    out     ($bc),a
    ld      a,h
    out     ($bd),a
    ret
