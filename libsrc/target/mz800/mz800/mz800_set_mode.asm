; void mz800_set_mode(uint8_t dmd) __z88dk_fastcall
; Display mode: $00 = 320x200 4 colours (planes I and II), $01 = planes III and IV, $04/$05 640x200 2 colours, $06 640x200 4 colours, $08 = MZ-700 text

    SECTION code_clib
    PUBLIC  mz800_set_mode
    PUBLIC  _mz800_set_mode

mz800_set_mode:
_mz800_set_mode:
    ld      a,l
    out     ($ce),a
    ret
