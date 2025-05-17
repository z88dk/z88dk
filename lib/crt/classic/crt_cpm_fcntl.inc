; CP/M style FCB support (CP/M + MSXDOS1)


    IFNDEF CPM_READ_CACHE_ALWAYS
        defc    CPM_READ_CACHE_ALWAYS = 1
    ENDIF
    PUBLIC  __CPM_READ_CACHE_ALWAYS
    defc    __CPM_READ_CACHE_ALWAYS = CPM_READ_CACHE_ALWAYS

    SECTION bss_crt

IF CLIB_OPEN_MAX > 0
    SECTION bss_crt
    PUBLIC  __fcb
__fcb:
    defs    CLIB_OPEN_MAX * (36+12+133)	; 
ENDIF

    PUBLIC  defltdsk
defltdsk:       defb    0	;Default disc
