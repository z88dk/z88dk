;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: stkequcmp.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;

		INCLUDE		"cpcfp.def"

		PUBLIC		stkequcmp


.stkequcmp
	        pop     de      ;return address
	        pop     bc      ;dump number..
	        pop     bc
	        pop     bc
	        push    de      ;put it back
	        ld      l,a
	        ld      h,0
	        ret		

