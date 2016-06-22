;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: floor.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
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
