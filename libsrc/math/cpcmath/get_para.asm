;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: get_para.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
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

