;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pow.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  pow
        PUBLIC  powc


        EXTERN  fa

pow:
        ld      hl, 8
        add     hl, sp
        ld      de, fa                  ; (fa)<-(hl)
        ld      bc, 6
        ldir
        ld      hl, 3
        add     hl, sp
        ex      de, hl
        ld      hl, fa+1
powc:
        FPCALL  (CPCFP_FLO_POW)
        ret
