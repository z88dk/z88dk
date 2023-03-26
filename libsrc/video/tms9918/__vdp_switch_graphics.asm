
SECTION rodata_video_vdp

PUBLIC __vdp_switch_graphics

EXTERN ansi_cls
EXTERN l_ret

; This will switch to mode 2 as the older implementation did
__vdp_switch_graphics:
    defw ansi_cls
    defw l_ret
    defw l_ret
    defw l_ret
    defw l_ret
