;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: ddiv.asm,v 1.4 2016-06-22 19:50:48 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"


        PUBLIC  ddiv
        PUBLIC  ddivc

        EXTERN  fsetup
        EXTERN  stkequ
        EXTERN  fa

; (fa+1)=(sp+3)/(fa+1)
ddiv:
        call    fsetup
ddivc:
        FPCALL  (CPCFP_FLO_DIV)         ; (hl)=(hl)/(de)
        jp      stkequ
