; CP/M style FCB support (CP/M + MSXDOS1)

    ; Maximum number of FILEs available
    IF !DEFINED_CLIB_FCBS_MAX
        DEFC    CLIB_FCBS_MAX = CLIB_FOPEN_MAX
    ENDIF
    PUBLIC  __CPM_FCBS_MAX
    defc    __CPM_FCBS_MAX = CLIB_FCBS_MAX


    SECTION bss_crt

IF CLIB_DISABLE_FILEIO = 0
    SECTION bss_crt
    PUBLIC  __fcb
__fcb:
    defs    CLIB_FCBS_MAX * 43	; Each FCB is 43 bytes long
ENDIF

    PUBLIC  defltdsk
defltdsk:       defb    0	;Default disc
