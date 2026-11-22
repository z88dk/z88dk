;
;	Heath/Zenith HDOS
;
;	Stefano Bodrato - 2026
;
;
;	$Id: fgetc_cons.asm $
;

    SECTION code_clib
    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons

    INCLUDE "target/hdos/def/hdos.def"

fgetc_cons:
_fgetc_cons:
    rst    38h
	defb   SCIN
	jr     c,fgetc_cons
	ld     h,0
	ld     l,a
    ret
