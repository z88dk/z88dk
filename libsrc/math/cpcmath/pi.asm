;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pi.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		pi
		PUBLIC		pic


		EXTERN		fa

.pi		ld      hl,fa+1
        call    firmware
.pic	defw	CPCFP_FLO_PI
		ret
