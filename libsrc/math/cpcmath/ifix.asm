;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: ifix.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		ifix
		XDEF		ifixc
		XREF		fa
		LIB		int_inv_sgn

.ifix	ld      hl,fa+1
        call    firmware
.ifixc	defw	CPCFP_FLO_2_INT
		call	m,int_inv_sgn
		ret
