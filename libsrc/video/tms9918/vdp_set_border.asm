; void vdp_set_border(int c) __z88dk_fastcall


    SECTION code_video_vdp
    PUBLIC  vdp_set_border
    PUBLIC  _vdp_set_border

    EXTERN  VDPreg_Write
    EXTERN  __tms9918_border
    EXTERN  RG0SAV

    INCLUDE "video/tms9918/vdp.inc"

vdp_set_border:
_vdp_set_border:
    ld      a,l
    and     15
    ld      (__tms9918_border),a
    ld      l,a
    ld      a,(RG0SAV+7)
    and     @11110000
    or      l
    ld      e,7
    jp      VDPreg_Write

