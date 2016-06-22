;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dadd.asm,v 1.4 2016-06-22 19:50:48 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		dadd
		PUBLIC		daddc

		EXTERN		fsetup
		EXTERN		stkequ
		EXTERN		fa

.dadd						; (fa+1)=(fa+1)+(sp+3)
		call    fsetup
        call    firmware
.daddc  defw    CPCFP_FLO_ADD		; (hl)=(hl)+(de)
		jp stkequ		


