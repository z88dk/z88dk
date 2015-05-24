
SECTION code_fp_math48

PUBLIC mm48_mul10

EXTERN mm48__sright, mm48__right, mm48_error_erange_pinfc, mm48__retzero

mm48_mul10:

   ; multiply by 10 and make positive
   ; AC' = abs(AC') * 10
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : success
   ;
   ;            AC'= abs(x) * 10
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'= double_max
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   exx
   
   ; AC = x
   
   ld a,l
   or a
   jp z, mm48__retzero         ; if zero
   
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
   jp z, mm48_error_erange_pinfc + 1

mm48__m10a:

   ld a,l
   add a,3
   jp c, mm48_error_erange_pinfc + 1
   ld l,a
   
   res 7,b
   exx
   ret
