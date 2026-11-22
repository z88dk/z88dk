; void mz800_wait_vblank(void)
; Returns at the start of the vertical blank ($CE bit 6 is low during it)

    SECTION code_clib
    PUBLIC  mz800_wait_vblank
    PUBLIC  _mz800_wait_vblank

mz800_wait_vblank:
_mz800_wait_vblank:
wv1:
    in      a,($ce)
    and     $40
    jr      z,wv1           ; wait for the end of one in progress
wv2:
    in      a,($ce)
    and     $40
    jr      nz,wv2
    ret
