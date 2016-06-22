;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: float.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfp.def"
		INCLUDE		"cpcfirm.def"

		PUBLIC		float
		EXTERN        int_inv_sgn
		PUBLIC		floatc
		EXTERN		fa

.float  ld      a,h
		push    af
		bit     7,h
		call    nz,int_inv_sgn	; hl=-hl si nz
		pop     af
		ld      de,fa+1
        call    firmware
.floatc	defw    CPCFP_INT_2_FLO		; (fa+1)<-hl et signe=bit 7,a
		ret


