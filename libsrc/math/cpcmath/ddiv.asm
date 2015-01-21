;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: ddiv.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		ddiv
		PUBLIC		ddivc

		EXTERN		fsetup
		EXTERN		stkequ
		EXTERN		fa

.ddiv						; (fa+1)=(fa+1)*(sp+3)
		call	fsetup
        call    firmware
.ddivc	defw	CPCFP_FLO_DIV		; (hl)=(hl)/(de)
		jp      stkequ


