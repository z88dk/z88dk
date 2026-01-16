
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dfix64u

EXTERN error_llznc, am48_dfix64_0, error_erange_llmc
EXTERN l_lsr_dehldehl

am48_dfix64u:

   ; double to 64-bit unsigned long long (truncates)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            dehl'dehl = (unsigned long long)(x)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            dehl'dehl = llong_max or llong_min
   ;            carry set, errno set
   ;
   ; notes : FIX(1.5)=    1=  $00000001
   ;         FIX(-1.5)=  -1=  $FFFFFFFF
   ;         FIX(0.5)=    0=  $00000000
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   exx
   
   ; AC = x

   ld a,l
   or a

   jp z, error_llznc           ; if x == 0, return 0
   
   sub $81                     ; a = exponent - 1 (remove bias + 1)
   jp c, error_llznc           ; if exponent <= 0, return 0

   bit 7,b
   jp nz, am48_dfix64_0        ; if negative do signed conversion
   set 7,b                     ; restore mantissa bit

   cpl
   add a,64                    ; a = 64 - exponent = number of shifts
   
   jp m, error_erange_llmc     ; if number too large (exponent >= 65)

   ; dehl'dehl = mantissa bits in msb position
   
   ex af,af'
   
   ld a,h
   ld l,c
   ld h,b
   ex de,hl
   
   exx
   
   ld d,a
   ld e,0
   ld h,e
   ld l,e
   
   ex af,af'                   ; a = number of shifts
   
   call l_lsr_dehldehl

   or a
   ret
