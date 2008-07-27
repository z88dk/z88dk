;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dlt.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		dlt
		XDEF		dltc

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.dlt	call	fsetup
        call    firmware
.dltc	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      $FF			;(hl) < (de)
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

