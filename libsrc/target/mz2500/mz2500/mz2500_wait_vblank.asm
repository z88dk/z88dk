;
;	Sharp MZ-2500 specific routines
;
;	void mz2500_wait_vblank(void);
;
;	Wait for the start of the next vertical blanking (text screen's
;	blank flags: port $F4 bit 0 is 1 while the display is active).
;

    SECTION code_clib
    PUBLIC  mz2500_wait_vblank
    PUBLIC  _mz2500_wait_vblank

mz2500_wait_vblank:
_mz2500_wait_vblank:
wait_active:
    in      a,($f4)
    rrca
    jr      nc,wait_active
wait_blank:
    in      a,($f4)
    rrca
    jr      c,wait_blank
    ret
