;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: float.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  float
        EXTERN  int_inv_sgn
        PUBLIC  floatc
        EXTERN  fa
        EXTERN  asm_labs

float:
        ld      a, d
        push    af
        call    asm_labs
        pop     af
        push    de
        push    de
        push    hl
        ld      hl, 0
        add     hl, sp
floatc:
        FPCALL  (CPCFP_BIN_2_FLO)
        ld      hl, 0
        add     hl, sp
        ld      de, fa+1
        ld      bc, 5
        ldir
        pop     bc
        pop     bc
        pop     bc
        ret


