;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dgt.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		dgt
		XDEF		dgtc

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.dgt	call	fsetup
        call    firmware
.dgtc	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      $1			;(hl) > (de)
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

