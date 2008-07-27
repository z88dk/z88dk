;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: fsetup.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		fsetup

		XREF		fa

.fsetup
		ld      hl,fa+1			; de=fa+1
		ex      de,hl
		ld      hl,5
		add     hl,sp			; hl=sp+5
		ret


