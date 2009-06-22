;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: deq.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		deq
		XDEF		deqc

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.deq	call	fsetup
        call    firmware
.deqc	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      0			;(hl) != (de)
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

