;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pow10.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		pow10
		XDEF		pow10c

		LIB		float

		XREF		fa

.pow10	ld      hl,1
		call	float
		ld      hl,2
		add     hl,sp
		ld      a,(hl)
		ld      hl,fa+1
        call    firmware
.pow10c	defw	CPCFP_FLO_POW10
		ret

