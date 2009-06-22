;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pow.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		pow
		XDEF		powc


		XREF		fa

.pow
		ld      hl,8
		add     hl,sp
		ld      de,fa			; (fa)<-(hl)
		ld      bc,6
		ldir
		ld      hl,3
		add     hl,sp
		ex      de,hl
		ld      hl,fa+1
        call    firmware
.powc	defw	CPCFP_FLO_POW
		ret

