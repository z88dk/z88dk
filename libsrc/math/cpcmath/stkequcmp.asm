;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: stkequcmp.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		stkequcmp


.stkequcmp
	        pop     de      ;return address
	        pop     bc      ;dump number..
	        pop     bc
	        pop     bc
	        push    de      ;put it back
	        ld      l,a
	        ld      h,0
	        ret		

