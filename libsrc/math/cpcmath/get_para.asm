;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: get_para.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;

		INCLUDE		"cpcfp.def"

		PUBLIC		get_para

		EXTERN		fa

.get_para	
        ld      hl,4
		add     hl,sp
		ld      de,fa		;(fa) <- (hl)
		ld      bc,6
		ldir
		ld      hl,fa+1
		ret

