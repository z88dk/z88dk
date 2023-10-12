;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pi.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION code_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  pi
        EXTERN  fa

pi:
        ld      de, fa+1
        ld      hl, pi_value
        ld      bc, 5
        ldir
        ret

        SECTION rodata_fp

pi_value:
        defb    $a2, $da, $0f, $49, $82
