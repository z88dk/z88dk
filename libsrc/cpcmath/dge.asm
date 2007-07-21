;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dge.asm,v 1.2 2007-07-21 21:28:22 dom Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		dge
		XDEF		dgec

		LIB		fsetup
		LIB		stkequcmp
		LIB		cmpfin

.dge	call	fsetup
        call    firmware
.dgec	defw	CPCFP_FLO_CMP		; comp (hl)?(de)	
		cp      0			;(hl) <= (de)
		jp      z,cmpfin
		cp      1
		jp      z,cmpfin
		xor     a
		jp      stkequcmp

