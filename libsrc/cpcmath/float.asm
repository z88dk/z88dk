;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: float.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		float
		LIB		int_inv_sgn
		XDEF		floatc
		XREF		fa

.float		ld	a,h
		push af
		bit 7,h
		call nz,int_inv_sgn	; hl=-hl si nz
		pop af
		ld de,fa+1
.floatc		call CPCFP_INT_2_FLO		; (fa+1)<-hl et signe=bit 7,a
		ret


