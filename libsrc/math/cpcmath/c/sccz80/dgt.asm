;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dgt.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  dgt
        PUBLIC  dgtc

        EXTERN  fsetup
        EXTERN  stkequcmp
        EXTERN  cmpfin

dgt:
        call    fsetup
dgtc:
        FPCALL  (CPCFP_FLO_CMP)
        cp      $1                      ;(hl) > (de)
        jp      z, cmpfin
        xor     a
        jp      stkequcmp

