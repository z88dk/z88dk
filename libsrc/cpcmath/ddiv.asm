;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: ddiv.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		ddiv
		XDEF		ddivc

		LIB		fsetup
		LIB		stkequ
		XREF		fa

.ddiv						; (fa+1)=(fa+1)*(sp+3)
		call	fsetup
.ddivc		call	CPCFP_FLO_DIV		; (hl)=(hl)/(de)
		jp	stkequ


