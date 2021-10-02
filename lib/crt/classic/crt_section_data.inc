

    SECTION DATA
  IF !__crt_org_graphics
    SECTION smc_clib
  ENDIF
    SECTION smc_fp
    SECTION smc_compress
    SECTION smc_user
    SECTION data_driver
    SECTION data_clib
    SECTION data_stdlib
    SECTION data_psg
    SECTION data_sound_ay
    SECTION	data_PSGlib
  IF !__crt_org_graphics
    SECTION data_graphics
  ENDIF
    SECTION data_crt
    SECTION data_fp_mbf32
    SECTION data_arch
    SECTION data_compiler
    SECTION data_splib2
    SECTION data_user
    SECTION data_alloc_balloc
    SECTION DATA_END
