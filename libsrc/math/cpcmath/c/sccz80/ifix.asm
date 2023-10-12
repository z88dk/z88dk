;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: ifix.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  ifix
        PUBLIC  ifixc
        EXTERN  fa
        EXTERN  l_neg_dehl

ifix:
        ld      hl, fa+1
ifixc:
        FPCALL  (CPCFP_FLO_BINFIX2)
        ld      hl, (fa+1)
        ld      de, (fa+3)
        bit     7, b
        call    nz, l_neg_dehl
        ret
