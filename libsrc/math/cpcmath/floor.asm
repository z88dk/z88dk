;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: floor.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		floor
		XDEF		floorc
		XDEF		floorc2

		LIB		get_para

.floor	call	get_para
        call    firmware
.floorc	defw	CPCFP_FLO_BINFIX
		ld	a,b
        call    firmware
.floorc2
        defw	CPCFP_BIN_2_FLO
		ret
