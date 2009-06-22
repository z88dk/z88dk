;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: cmpfin.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfp.def"

		XLIB		cmpfin

		LIB		stkequcmp


.cmpfin		ld	a,1
		jp	stkequcmp
