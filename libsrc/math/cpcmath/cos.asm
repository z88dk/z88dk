;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: cos.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

        INCLUDE		"#cpcfirm.def"

		INCLUDE		"#cpcfp.def"

		XLIB		cos
		XDEF		cosc

		LIB		get_para

.cos		call	get_para
            call    firmware
.cosc		defw	CPCFP_FLO_COS
            ret
