;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dlt.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		dlt
		PUBLIC		dltc

		EXTERN		fsetup
		EXTERN		stkequcmp
		EXTERN		cmpfin

.dlt	call	fsetup
        call    firmware
.dltc	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      $FF			;(hl) < (de)
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

