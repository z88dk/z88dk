;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pow.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		pow
		XDEF		powc


		XREF		fa

.pow
		ld	hl,8
		add	hl,sp
		ld	de,fa			; (fa)<-(hl)
		ld	bc,6
		ldir
		ld	hl,3
		add	hl,sp
		ex	de,hl
		ld	hl,fa+1    
.powc		call	CPCFP_FLO_POW
		ret

