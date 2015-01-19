;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: outvdc_callee.asm,v 1.3 2015-01-19 01:32:42 pauloscustodio Exp $
;

;set vdc register

        PUBLIC    outvdc_callee
        PUBLIC    ASMDISP_OUTVDC_CALLEE

outvdc_callee:
        pop hl
        pop de
        ex (sp),hl
        
asmentry:
        ld      a,l
        ld      bc,0d600h       ;vdc status port
        out     (c),a           ;set reg to read
test7:
        in      a,(c)           ;repeat
        bit     7,a             ;  test bit 7
        jr      z,test7            ;until bit 7 high
        inc     bc              ;vdc data register
        out     (c),e           ;set data
        ret

;void outvdc(uchar RegNum, uchar RegVal)
;{
;  outp(vdcStatusReg,RegNum);                  /* internal vdc register to write */
;  while ((inp(vdcStatusReg) & 0x80) == 0x00); /* wait for status bit to be set */
;  outp(vdcDataReg,RegVal);                    /* write register */
;}

DEFC ASMDISP_OUTVDC_CALLEE = # asmentry - outvdc_callee
