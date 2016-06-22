;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pow10.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		pow10
		PUBLIC		pow10c

		EXTERN		float

		EXTERN		fa

.pow10	ld      hl,1
		call	float
		ld      hl,2
		add     hl,sp
		ld      a,(hl)
		ld      hl,fa+1
        call    firmware
.pow10c	defw	CPCFP_FLO_POW10
		ret

