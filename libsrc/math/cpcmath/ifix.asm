;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: ifix.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		ifix
		PUBLIC		ifixc
		EXTERN		fa
		EXTERN		int_inv_sgn

.ifix	ld      hl,fa+1
        call    firmware
.ifixc	defw	CPCFP_FLO_2_INT
		call	m,int_inv_sgn
		ret
