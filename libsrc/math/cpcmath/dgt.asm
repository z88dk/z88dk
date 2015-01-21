;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dgt.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

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

