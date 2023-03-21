;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int vdp_get_mode();
;
;	Gets the current screen mode
;
;
;	$Id: vdp_get_mode.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

    SECTION code_video_vdp
    PUBLIC  vdp_get_mode
    PUBLIC  _vdp_get_mode
    EXTERN  __tms9918_screen_mode


vdp_get_mode:
_vdp_get_mode:
    ld      hl,(__tms9918_screen_mode)
    ld      h,0
    ret
