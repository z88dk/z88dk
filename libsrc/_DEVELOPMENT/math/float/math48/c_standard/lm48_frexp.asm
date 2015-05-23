
; double frexp(double value, int *exp)

SECTION code_fp_math48

PUBLIC lm48_frexp

EXTERN mm48__zero

lm48_frexp:

   ; return normalized fraction part of value and store
   ; power of 2 exponent of value in exp
   ;
   ; enter : AC'(BCDEHL') = double value
   ;                  HL  = int *exp
   ;
   ; exit  : AC'(BCDEHL') = normalized fraction part of value
   ;                 *HL  = power of two exponent of value
   ;
   ; uses  : af, l'

   exx
   
   ld a,l
   or a
   call z, mm48__zero          ; make sure the mantissa is zero
   jr z, zero
   
   ld l,$80                    ; AC' = normalized fraction (exponent = 0)
   sub $80                     ; subtract bias from exponent

zero:

   exx
   
   ld (hl),a
   inc hl
   
   ld a,0
   sbc a,a
   
   ld (hl),a
   dec hl
   
   ret
