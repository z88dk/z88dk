;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dne.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		dne
		XDEF		dnec

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.dne		call	fsetup
.dnec		call	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp	0			;(hl) != (de)
		jp	z,stkequcmp
		xor	a
		jp	cmpfin

