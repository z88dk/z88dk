;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dlt.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		dlt
		XDEF		dltc

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.dlt		call	fsetup
.dltc		call	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp	$FF			;(hl) < (de)
		jp	z,cmpfin
		xor	a
		jp	stkequcmp

