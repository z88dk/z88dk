;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dmul.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  dmul
        PUBLIC  dmulc

        EXTERN  fsetup
        EXTERN  stkequ

; (fa+1)=(fa+1)*(sp+3)
dmul:
        call    fsetup
dmulc:
        FPCALL  (CPCFP_FLO_MUL)
        jp      stkequ

