;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dleq.asm,v 1.5 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		dleq
		PUBLIC		dleqc

		EXTERN		fsetup
		EXTERN		stkequcmp
		EXTERN		cmpfin

.dleq	call	fsetup
        call    firmware
.dleqc	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      0			;(hl) <= (de)
		jp      z,cmpfin
		cp      255
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

