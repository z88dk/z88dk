;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: floor.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		floor
		XDEF		floorc
		XDEF		floorc2

		LIB		get_para

.floor		call	get_para
.floorc		call	CPCFP_FLO_BINFIX
		ld	a,b
.floorc2	call	CPCFP_BIN_2_FLO
		ret
