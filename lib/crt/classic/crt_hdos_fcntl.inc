; HDOS style file buffers

    SECTION bss_crt

IF CLIB_OPEN_MAX > 0
    SECTION bss_crt
    PUBLIC  __fcb
__fcb:
    defs    CLIB_OPEN_MAX * (256+5+11+19)	; 
ENDIF

;     PUBLIC  defltdsk
; defltdsk:       defb    0	;Default disc
