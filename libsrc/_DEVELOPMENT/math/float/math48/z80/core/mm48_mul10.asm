
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_mul10

EXTERN mm48__sright, mm48__right, mm48__retzero, am48_derror_erange_pinfc

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
   ;            AC'= +inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc', de', hl'

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
   
   ld a,3
   jr nc, mm48__m10a
   
   call mm48__right
   inc a

mm48__m10a:

   add a,l
   ld l,a
   jp c, am48_derror_erange_pinfc + 1
   
   res 7,b
   exx
   ret
