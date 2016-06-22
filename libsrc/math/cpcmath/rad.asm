;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: rad.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		rad
		PUBLIC		radc


		EXTERN		fa

.rad	xor     a
        call    firmware
.radc	defw	CPCFP_FLO_DEG_RAD
		ret

