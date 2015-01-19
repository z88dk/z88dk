;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: deg.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		deg
		PUBLIC		degc



.deg	ld      a,1
        call    firmware
.degc   defw	CPCFP_FLO_DEG_RAD
		ret

