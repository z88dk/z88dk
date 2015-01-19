;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: outvdc.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
;

;set vdc register

        PUBLIC    outvdc
        EXTERN     outvdc_callee
        EXTERN    ASMDISP_OUTVDC_CALLEE 

outvdc:
        pop     bc              ;return address
        pop     de              ;data
        pop     hl              ;vdc register to write
        push    hl
        push    de
        push    bc
        jp outvdc_callee + ASMDISP_OUTVDC_CALLEE
