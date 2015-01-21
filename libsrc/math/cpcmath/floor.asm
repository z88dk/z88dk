;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: floor.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		floor
		PUBLIC		floorc
		PUBLIC		floorc2

		EXTERN		get_para

.floor	call	get_para
        call    firmware
.floorc	defw	CPCFP_FLO_BINFIX
		ld	a,b
        call    firmware
.floorc2
        defw	CPCFP_BIN_2_FLO
		ret
