;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dmul.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		dmul
		XDEF		dmulc

		LIB		fsetup
		LIB		stkequ
		XREF		fa

.dmul						; (fa+1)=(fa+1)*(sp+3)
		call	fsetup
.dmulc		call	CPCFP_FLO_MUL		; (hl)=(hl)*(de)
		jp	stkequ


