;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: deq.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		deq
		XDEF		deqc

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.deq		call	fsetup
.deqc		call	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp	0			;(hl) != (de)
		jp	z,cmpfin
		xor	a
		jp	stkequcmp

