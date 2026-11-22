;
;	Heath/Zenith HDOS
;
;	Stefano Bodrato - 2026
;
;
;	$Id: getk.asm $
;

    SECTION code_clib
    PUBLIC  getk
    PUBLIC  _getk

    INCLUDE "target/hdos/def/hdos.def"

getk:
_getk:
    rst    38h
	defb   SCIN
	ld     h,0
	jr     nc,got_key
	ld     l,h
	ret
got_key:
	ld     l,a
    ret
