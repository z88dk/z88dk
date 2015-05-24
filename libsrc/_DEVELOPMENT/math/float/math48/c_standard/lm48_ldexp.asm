
; double ldexp(double x, int exp)

SECTION code_fp_math48

PUBLIC lm48_ldexp

EXTERN mm48__retzero, mm48_error_erange_infc

lm48_ldexp:

   ; multiply x by power of two
   ;
   ; enter : AC'(BCDEHL') = double x
   ;                 HL   = exp
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = x * 2^(exp)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, hl, bc', de', hl'
   
   exx

   ld a,l
   or a

   exx
   ret z                       ; if x == 0 return 0
   
   add a,l
   ld l,a
   jr nc, ASMPC+3
   inc h
   
   ld a,h
   or a
   
   ld a,l
   
   exx
   
   jp m, mm48__retzero               ; if exponent small
   jp nz, mm48_error_erange_infc + 1 ; if exponent large
   
   ld l,a
   
   exx
   ret
