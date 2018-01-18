;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: deq.asm,v 1.4 2016-06-22 19:50:48 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"arch/cpc/def/cpcfirm.def"
		INCLUDE		"arch/cpc/def/cpcfp.def"

		PUBLIC		deq
		PUBLIC		deqc

		EXTERN		fsetup
		EXTERN		stkequcmp
		EXTERN		cmpfin

.deq	call	fsetup
        call    firmware
.deqc	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      0			;(hl) != (de)
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

