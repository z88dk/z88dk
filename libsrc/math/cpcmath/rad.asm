;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: rad.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		rad
		XDEF		radc


		XREF		fa

.rad	xor     a
        call    firmware
.radc	defw	CPCFP_FLO_DEG_RAD
		ret

