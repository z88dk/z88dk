;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dadd.asm,v 1.4 2016-06-22 19:50:48 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  dadd
        PUBLIC  daddc

        EXTERN  fsetup
        EXTERN  stkequ
        EXTERN  fa

; (fa+1)=(fa+1)+(sp+3))
dadd:
        call    fsetup
daddc:
        FPCALL  (CPCFP_FLO_ADD)         ; (hl)=(hl)+(de)
        jp      stkequ

