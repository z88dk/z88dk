;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dne.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		dne
		XDEF		dnec

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.dne	call	fsetup
        call    firmware
.dnec	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      0			;(hl) != (de)
		jp      z,stkequcmp
		xor     a
		jp      cmpfin

