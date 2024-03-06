; CP/M style FCB support (CP/M + MSXDOS1)


    ; Control whether extending a file will write an empty record
    IF !DEFINED_CPM_WRITE_EMPTY_RECORD
        DEFC    CPM_WRITE_EMPTY_RECORD = 1
    ENDIF
    PUBLIC  __CPM_WRITE_EMPTY_RECORD
    defc    __CPM_WRITE_EMPTY_RECORD = CPM_WRITE_EMPTY_RECORD

    SECTION bss_crt

IF CLIB_OPEN_MAX > 0
    SECTION bss_crt
    PUBLIC  __fcb
__fcb:
    defs    CLIB_OPEN_MAX * 166	; Each FCB is 43 bytes long
ENDIF

    PUBLIC  defltdsk
defltdsk:       defb    0	;Default disc
