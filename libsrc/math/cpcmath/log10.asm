;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: log10.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		log10
		XDEF		log10c

		LIB		get_para

.log10	call	get_para
        call    firmware
.log10c	defw	CPCFP_FLO_LOG10
		ret
