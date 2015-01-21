;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dmul.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		dmul
		PUBLIC		dmulc

		EXTERN		fsetup
		EXTERN		stkequ
		EXTERN		fa

.dmul						; (fa+1)=(fa+1)*(sp+3)
		call	fsetup
        call    firmware
.dmulc	defw    CPCFP_FLO_MUL		; (hl)=(hl)*(de)
		jp      stkequ


