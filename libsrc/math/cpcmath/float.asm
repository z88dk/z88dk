;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: float.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfp.def"
		INCLUDE		"#cpcfirm.def"

		XLIB		float
		LIB         int_inv_sgn
		XDEF		floatc
		XREF		fa

.float  ld      a,h
		push    af
		bit     7,h
		call    nz,int_inv_sgn	; hl=-hl si nz
		pop     af
		ld      de,fa+1
        call    firmware
.floatc	defw    CPCFP_INT_2_FLO		; (fa+1)<-hl et signe=bit 7,a
		ret


