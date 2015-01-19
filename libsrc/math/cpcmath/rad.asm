;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: rad.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		rad
		PUBLIC		radc


		EXTERN		fa

.rad	xor     a
        call    firmware
.radc	defw	CPCFP_FLO_DEG_RAD
		ret

