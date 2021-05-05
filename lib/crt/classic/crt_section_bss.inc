    SECTION BSS
IF __crt_org_bss
    org     __crt_org_bss
    defb    0   ; control name of bss binary
ENDIF
    SECTION bss_fp
    SECTION bss_fp_math32
    SECTION bss_fp_math16
    SECTION bss_fp_mbf32
    SECTION bss_fp_mbf64
    SECTION bss_fp_am9511
    SECTION bss_fp_dai32
    SECTION bss_compress_aplib
    SECTION bss_error
    SECTION bss_crt
    SECTION bss_fardata
IF __crt_org_bss_fardata_start
    org	__crt_org_bss_fardata_start
ENDIF
    SECTION bss_compiler
IF __crt_org_bss_compiler_start
    org	__crt_org_bss_compiler_start
ENDIF
    SECTION bss_driver
    SECTION bss_arch
    SECTION bss_clib
    SECTION bss_string
    SECTION bss_alloc_balloc
IF !__crt_org_graphics
    SECTION bss_graphics
ENDIF
    SECTION bss_psg
    SECTION bss_sound_ay
    SECTION	bss_PSGlib
    SECTION bss_splib2
    SECTION bss_user
