;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dleq.asm,v 1.4 2012-04-16 08:44:33 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		dleq
		XDEF		dleqc

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.dleq	call	fsetup
        call    firmware
.dleqc	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      0			;(hl) <= (de)
		jp      z,cmpfin
		cp      255
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

