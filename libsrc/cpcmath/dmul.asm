;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dmul.asm,v 1.2 2007-07-21 21:28:22 dom Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		dmul
		XDEF		dmulc

		LIB		fsetup
		LIB		stkequ
		XREF		fa

.dmul						; (fa+1)=(fa+1)*(sp+3)
		call	fsetup
        call    firmware
.dmulc	defw    CPCFP_FLO_MUL		; (hl)=(hl)*(de)
		jp      stkequ


