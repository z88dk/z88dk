;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dge.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		dge
		PUBLIC		dgec

		EXTERN		fsetup
		EXTERN		stkequcmp
		EXTERN		cmpfin

.dge	call	fsetup
        call    firmware
.dgec	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      0			;(hl) <= (de)
		jp      z,cmpfin
		cp      1
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

