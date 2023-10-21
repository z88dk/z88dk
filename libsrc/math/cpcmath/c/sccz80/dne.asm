;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dne.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  dne
        PUBLIC  dnec

        EXTERN  fsetup
        EXTERN  stkequcmp
        EXTERN  cmpfin

dne:
        call    fsetup
dnec:
        FPCALL  (CPCFP_FLO_CMP)
        cp      0                       ;(hl) != (de)
        jp      z, stkequcmp
        xor     a
        jp      cmpfin

