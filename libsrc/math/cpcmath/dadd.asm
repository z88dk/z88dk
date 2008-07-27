;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dadd.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		dadd
		XDEF		daddc

		LIB		fsetup
		LIB		stkequ
		XREF		fa

.dadd						; (fa+1)=(fa+1)+(sp+3)
		call    fsetup
        call    firmware
.daddc  defw    CPCFP_FLO_ADD		; (hl)=(hl)+(de)
		jp stkequ		


