
SECTION rodata_video_vdp

PUBLIC __vdp_switch_graphics

EXTERN __tms9918_mode2_cls
EXTERN l_ret

; This will switch to mode 2 as the older implementation did
__vdp_switch_graphics:
defw __tms9918_mode2_cls
defw l_ret
defw l_ret
defw l_ret
defw l_ret
