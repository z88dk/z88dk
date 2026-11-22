;
; Z80 fixed Q8.8 maths routines
;
; These routines have been adapted from two sources:
;
; https://learn.cemetech.net/index.php/Z80:Advanced_Math
; 
; and
; 
; https://github.com/Zeda/Z80-Optimized-Routines/tree/master/math
;
;

    SECTION code_math
    PUBLIC  asm_fix16_log


asm_fix16_log:
lognat:
;Input:  H.L needs to be on (0,128.0)
;Output: H.L if c flag set
;    returns nc if input is negative (HL not modified)
;Error:
;   The error on the outputs is as follows:
;      20592 inputs are exact
;      12075 inputs are off by 1/256
;      100 inputs are off by 2/256
;   So all 32767 inputs are within 2/256, with average error being <1/683 which is smaller than 1/256.
;Size: 177 bytes
;Speed: average speed is less than 1250 t-states

   ld a,h 
   or l
   jr nz,$+5
   ld h,80h
   ret
   dec h
   dec h
   jr nz,$+9
   inc l
   dec l
IF __CPU_R4K__ | __CPU_R5K__
   jp nz,normalizeln_pre
ELSE
   jr nz,normalizeln_pre
ENDIF
   ld l,177
   ret
   inc h
IF __CPU_R4K__ | __CPU_R5K__
   jp nz,normalizeln
ELSE
   jr nz,normalizeln
ENDIF
   ld b,h
   ld c,l
   ld e,l
   ld d,8
   add hl,hl
   add hl,hl
   add hl,de
   ex de,hl
   call HL_Div_DE
   ld h,a
   ld l,b
   sla h
   jr c,$+3
   ld l,c


   add hl,hl
   jr c,$+3
   add hl,bc
   add hl,hl
   jr c,$+3
   add hl,bc
   add hl,hl
   jr c,$+3
   add hl,bc
   add hl,hl
   jr c,$+3
   add hl,bc
   add hl,hl
   jr c,$+3
   add hl,bc
   add hl,hl
   jr c,$+3
   add hl,bc
   add hl,hl
   jr c,$+3
   add hl,bc
   rl l
   ld a,h
   adc a,b
   ld h,b
   ld l,a
   scf
   ret
HL_Div_DE:
   add hl,hl
   sbc hl,de
   jr nc,$+3
   add hl,de
   adc a,a
   add hl,hl
   sbc hl,de
   jr nc,$+3
   add hl,de
   adc a,a
   add hl,hl
   sbc hl,de
   jr nc,$+3
   add hl,de
   adc a,a
   add hl,hl
   sbc hl,de
   jr nc,$+3
   add hl,de
   adc a,a
   add hl,hl
   sbc hl,de
   jr nc,$+3
   add hl,de
   adc a,a
   add hl,hl
   sbc hl,de
   jr nc,$+3
   add hl,de
   adc a,a
   add hl,hl
   sbc hl,de
   jr nc,$+3
   add hl,de
   adc a,a
   add hl,hl
   sbc hl,de
   adc a,a
   ret

normalizeln_pre:
   inc h
normalizeln:
   xor a
   inc h
   ret m
   ld d,a
   ld e,a
   ld a,l
   jr z,toosmall
   inc e
   srl h
   rra
   jr nz,$-4
   rla
   rl h
   dec e
stepin:
   ld l,a
   push de
   call lognat
   pop de
   ;now multiply DE by 355, then divide by 2 (rounding)
   ld b,d
   ld c,e
   ld a,d
   ex de,hl
   add hl,hl
   add hl,hl   ;4
   add hl,bc   ;5
   add hl,hl   ;10
   add hl,bc   ;11
   add hl,hl   ;22
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,bc
   add hl,hl
   add hl,bc
   sra h
   rr l
   adc hl,de
   scf
   ret
toosmall:
   dec d
   dec e
   add a,a
   jr nc,$-2
   inc h
   jp stepin
