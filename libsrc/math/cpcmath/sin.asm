;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: sin.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		sin
		XDEF		sinc

		LIB		get_para

.sin	call	get_para
        call    firmware
.sinc	defw	CPCFP_FLO_SIN
		ret
