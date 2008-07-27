;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: get_para.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		get_para

		XREF		fa

.get_para	
        ld      hl,4
		add     hl,sp
		ld      de,fa		;(fa) <- (hl)
		ld      bc,6
		ldir
		ld      hl,fa+1
		ret

