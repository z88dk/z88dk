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

    SECTION code_clib
    PUBLIC  vdp_get_mode
    PUBLIC  _vdp_get_mode

IF FORmsx
        INCLUDE "target/msx/def/msxbasic.def"
ELSE
        INCLUDE "target/svi/def/svibasic.def"
ENDIF

vdp_get_mode:
_vdp_get_mode:
    ld      a,(SCRMOD)
    ld      h,0
    ld      l,a
    ret
