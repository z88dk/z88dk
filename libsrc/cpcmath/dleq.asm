;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dleq.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		dleq
		XDEF		dleqc

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.dleq		call	fsetup
.dleqc		call	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp	0			;(hl) <= (de)
		jp	z,cmpfin
		cp	$255
		jp	z,cmpfin
		xor	a
		jp	stkequcmp

