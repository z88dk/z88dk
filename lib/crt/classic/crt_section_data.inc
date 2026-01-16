

    SECTION DATA
  IF !__crt_org_graphics
    SECTION smc_clib
  ENDIF
    SECTION smc_fp
    SECTION smc_sound_ay
    SECTION smc_compress
    SECTION smc_video_vdp
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
IF !__crt_org_far
    SECTION data_far
ENDIF
    SECTION data_crt
    SECTION data_fp_mbf32
    SECTION data_arch
    SECTION data_compiler
    SECTION data_splib2
    SECTION data_video_vdp
    SECTION data_user
    SECTION data_alloc_balloc
    SECTION data_SMSlib

    ; Alignment sections
    SECTION data_align_256
    align 256
    SECTION data_align_128
    align 128
    SECTION data_align_64
    align 64
    SECTION data_align_32
    align 32
    SECTION data_align_16
    align 16
    SECTION data_align_8
    align 8
    SECTION data_align_4
    align 4
    SECTION data_align_2
    align 2

    SECTION DATA_END
