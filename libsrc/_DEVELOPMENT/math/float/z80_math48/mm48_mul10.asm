
SECTION code_fp_math48

PUBLIC mm48_mul10

EXTERN mm48__sright, mm48__right

mm48_mul10:

;     Multiply AC by 10
;     -----------------
;
;     NAME:      MUL10
;     FUNCTION:  AC=ABS(AC)*10. AC is set equal to the absolute value
;                of AC multiplied by 10.
;     OFFSET:    39H
;     OUTPUT:    CF=0: OK.
;                CF=1: Overflow.
;     STACK:     6 bytes.

   ld a,l
   or a
   ret z
   set 7,b
   push bc
   push de
   ld a,h
   call mm48__sright
   call mm48__sright
   add a,h
   ld h,a
   ex (sp),hl
   adc hl,de
   ex de,hl
   pop hl
   ex (sp),hl
   adc hl,bc
   ld b,h
   ld c,l
   pop hl
   jr nc, mm48__m10a
   call mm48__right
   inc l
   scf
   ret z

mm48__m10a:

   ld a,l
   add a,3
   ld l,a
   res 7,b
   ret
