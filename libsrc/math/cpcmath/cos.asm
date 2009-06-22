;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: cos.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

        INCLUDE		"cpcfirm.def"

		INCLUDE		"cpcfp.def"

		XLIB		cos
		XDEF		cosc

		LIB		get_para

.cos		call	get_para
            call    firmware
.cosc		defw	CPCFP_FLO_COS
            ret
