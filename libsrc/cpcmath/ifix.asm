;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: ifix.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		ifix
		XDEF		ifixc
		XREF		fa
		LIB		int_inv_sgn

.ifix		ld	hl,fa+1
.ifixc		call	CPCFP_FLO_2_INT
		call	m,int_inv_sgn
		ret
