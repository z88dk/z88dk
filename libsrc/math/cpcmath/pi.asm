;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pi.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"arch/cpc/def/cpcfirm.def"
		INCLUDE		"arch/cpc/def/cpcfp.def"

		PUBLIC		pi
		PUBLIC		pic


		EXTERN		fa

.pi		ld      hl,fa+1
        call    firmware
.pic	defw	CPCFP_FLO_PI
		ret
