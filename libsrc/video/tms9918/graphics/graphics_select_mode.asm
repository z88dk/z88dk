
SECTION code_video_vdp

EXTERN  __tms9918_graphics_hook

PUBLIC  __tms9918_graphics_cls
PUBLIC  __tms9918_graphics_plot
PUBLIC  __tms9918_graphics_res
PUBLIC  __tms9918_graphics_xor
PUBLIC  __tms9918_graphics_point

EXTERN  l_ret

INCLUDE "video/tms9918/vdp.inc"


graphics_set_mode:
    ld      e,a
    ld      hl,mode_graphics_table - 2
loop:
    inc     hl
    inc     hl
    ld      a,(hl)
    inc     hl
    cp      255
    ret     z
    cp      e
    jr      nz,loop
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    ld      de,__tms9918_graphics_spec
    ld      bc, +(__tms9918_graphics_spec_end - __tms9918_graphics_spec)
    ldir
    ret

SECTION data_video_vdp

PUBLIC  __tms9918_graphics_cls
PUBLIC  __tms9918_graphics_plot
PUBLIC  __tms9918_graphics_res
PUBLIC  __tms9918_graphics_xor
PUBLIC  __tms9918_graphics_point

__tms9918_graphics_spec:
__tms9918_graphics_cls:
    defw        l_ret       ;cls
__tms9918_graphics_plot:
    defw        l_ret       ;plot
__tms9918_graphics_res:
    defw        l_ret       ;reset
__tms9918_graphics_xor:
    defw        l_ret       ;xorplot
__tms9918_graphics_point:
    defw        l_ret       ;point
__tms9918_graphics_spec_end:

SECTION rodata_video_vdp

EXTERN  __vdp_mode0_graphics
EXTERN  __vdp_mode0_80col_graphics
EXTERN  __vdp_mode1_graphics
EXTERN  __vdp_mode2_graphics
EXTERN  __vdp_mode3_graphics
EXTERN  __vdp_mode4_graphics
EXTERN  __vdp_mode5_graphics
EXTERN  __vdp_mode6_graphics
EXTERN  __vdp_mode8_graphics
EXTERN  __vdp_mode1_2_graphics

mode_graphics_table:
    defb    0
    defw    __vdp_mode0_graphics
    defb    1
    defw    __vdp_mode1_graphics
    defb    2
    defw    __vdp_mode2_graphics
    defb    3
    defw    __vdp_mode3_graphics
IFDEF V9938
    defb    4
    defw    __vdp_mode4_graphics
    defb    5
    defw    __vdp_mode5_graphics
    defb    6
    defw    __vdp_mode6_graphics
    defb    8
    defw    __vdp_mode8_graphics
ENDIF

IF V9938 | F18A
    defb    80
    defw    __vdp_mode0_80col_graphics
ENDIF
    defb    81
    defw    __vdp_mode1_2_graphics
    defb    $ff


SECTION code_crt_init

    ld      hl,graphics_set_mode
    ld      (__tms9918_graphics_hook),hl
