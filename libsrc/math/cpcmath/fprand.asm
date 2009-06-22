;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: fprand.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		fprand
		XDEF		fprandc
		
		XREF		fa

.fprand
		ld      hl,fa+1
        call    firmware
.fprandc	
        defw	CPCFP_FLO_RND
		ret
