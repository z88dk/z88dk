;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dne.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		dne
		PUBLIC		dnec

		EXTERN		fsetup
		EXTERN		stkequcmp
		EXTERN		cmpfin

.dne	call	fsetup
        call    firmware
.dnec	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      0			;(hl) != (de)
		jp      z,stkequcmp
		xor     a
		jp      cmpfin

