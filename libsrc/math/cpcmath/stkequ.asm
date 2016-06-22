;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: stkequ.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfp.def"

		PUBLIC		stkequ

		EXTERN		fa

.stkequ							
		ld      de,fa+1			; (fa+1)<-(sp+3)
		ld      hl,3
		add     hl,sp
		ld      bc,5
		ldir		
	    pop     hl			;ret to program
	    pop     bc			;get rid of fp number
        pop     bc
        pop     bc
       	jp      (hl)		;outa here back to program


