;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dgt.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		dgt
		PUBLIC		dgtc

		EXTERN		fsetup
		EXTERN		stkequcmp
		EXTERN		cmpfin

.dgt	call	fsetup
        call    firmware
.dgtc	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      $1			;(hl) > (de)
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

