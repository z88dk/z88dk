;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dsub.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		dsub
		PUBLIC		dsubc

		EXTERN		stkequ
		EXTERN		fa


.dsub						; (fa+1)=(fa+1)-(sp+3)
		ld      hl,3
		add     hl,sp			; hl=sp+3
		ex      de,hl
		ld      hl,fa+1			; de=fa+1
        call    firmware
.dsubc	defw	CPCFP_FLO_REV_SUB	; (hl)=(de)-(hl)
		pop     hl			;ret to program
		pop     bc			;get rid of fp number
		pop     bc
		pop     bc
		jp      (hl)			;outta here back to program


