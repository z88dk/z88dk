;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: ddiv.asm,v 1.4 2016-06-22 19:50:48 dom Exp $
;

                SECTION         code_fp
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


