;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: fprand.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		fprand
		PUBLIC		fprandc
		
		EXTERN		fa

.fprand
		ld      hl,fa+1
        call    firmware
.fprandc	
        defw	CPCFP_FLO_RND
		ret
