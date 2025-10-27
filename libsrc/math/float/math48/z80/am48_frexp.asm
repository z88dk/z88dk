
; double frexp(double value, int *exp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_frexp

EXTERN am48_dconst_0

am48_frexp:

   ; return normalized fraction part of value and store
   ; power of 2 exponent of value in exp
   ;
   ; enter : AC' = double value
   ;         HL  = int *exp
   ;
   ; exit  : AC' = normalized fraction part of value
   ;        *HL  = power of two exponent of value
   ;
   ; uses  : af, l'

   exx
   
   ld a,l
   or a
   call z, am48_dconst_0       ; make sure the mantissa is zero
   jr z, zero
   
   ld l,$80                    ; AC' = normalized fraction (exponent = 0)
   sub $80                     ; subtract bias from exponent

zero:

   exx
   
   ld (hl),a
   inc hl
   
   sbc a,a
   
   ld (hl),a
   dec hl
   
   ret
