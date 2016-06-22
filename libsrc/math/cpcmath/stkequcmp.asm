;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: stkequcmp.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
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

