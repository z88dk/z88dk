;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dadd.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		dadd
		XDEF		daddc

		LIB		fsetup
		LIB		stkequ
		XREF		fa

.dadd						; (fa+1)=(fa+1)+(sp+3)
		call fsetup
.daddc		call CPCFP_FLO_ADD		; (hl)=(hl)+(de)
		jp stkequ		


