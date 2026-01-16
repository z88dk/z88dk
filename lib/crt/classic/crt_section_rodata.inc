; RODATA sections defined by the classic library

    SECTION RODATA
    SECTION rodata_fp
    SECTION rodata_fp_math48
    SECTION rodata_fp_math32
    SECTION rodata_fp_math16
    SECTION rodata_fp_mbf32
    SECTION rodata_fp_mbf64
    SECTION rodata_fp_am9511
    SECTION rodata_fp_dai32
    SECTION rodata_arch
    SECTION rodata_compiler
    SECTION rodata_clib
    SECTION rodata_psg
    SECTION rodata_sound_ay
IF !__crt_org_graphics
    SECTION rodata_graphics
ENDIF
IF !__crt_org_far
    SECTION rodata_far
ENDIF
    SECTION rodata_user
    SECTION rodata_font
    SECTION rodata_font_fzx
    SECTION rodata_font_4x8
    SECTION rodata_font_6x8
    SECTION rodata_font_8x8
    SECTION rodata_font_8x10
    SECTION rodata_font_ansi
    SECTION rodata_splib2
    SECTION rodata_sound_bit
    SECTION rodata_video_vdp

    ; Alignment sections
    SECTION rodata_align_256
    align 256
    SECTION rodata_align_128
    align 128
    SECTION rodata_align_64
    align 64
    SECTION rodata_align_32
    align 32
    SECTION rodata_align_16
    align 16
    SECTION rodata_align_8
    align 8
    SECTION rodata_align_4
    align 4
    SECTION rodata_align_2
    align 2

    ; Keep the following section last of all
    SECTION rodata_appdor
    SECTION RODATA_END
