;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pow.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		pow
		PUBLIC		powc


		EXTERN		fa

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

