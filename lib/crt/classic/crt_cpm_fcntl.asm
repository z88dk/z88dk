; CP/M style FCB support (CP/M + MSXDOS1)





    SECTION bss_crt

IF CLIB_OPEN_MAX > 0
    SECTION bss_crt
    PUBLIC  __fcb
__fcb:
    defs    CLIB_OPEN_MAX * 166	; Each FCB is 43 bytes long
ENDIF

    PUBLIC  defltdsk
defltdsk:       defb    0	;Default disc
