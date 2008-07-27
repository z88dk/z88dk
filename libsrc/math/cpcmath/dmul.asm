;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dmul.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
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


