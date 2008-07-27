;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: cmpfin.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		cmpfin

		LIB		stkequcmp


.cmpfin		ld	a,1
		jp	stkequcmp
