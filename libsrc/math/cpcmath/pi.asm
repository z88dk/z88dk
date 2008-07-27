;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pi.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		pi
		XDEF		pic


		XREF		fa

.pi		ld      hl,fa+1
        call    firmware
.pic	defw	CPCFP_FLO_PI
		ret
