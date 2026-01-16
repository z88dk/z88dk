
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dfix64
PUBLIC am48_dfix64_0

EXTERN error_llznc, am48_derror_erange_longlongc
EXTERN l_lsr_dehldehl, l_neg_64_dehldehl

am48_dfix64:

   ; double to signed 64-bit integer (truncates)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            dehl'dehl = (long long)(x)
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
   
   jp z, error_llznc           ; if x == 0 return 0
   
   sub $81                     ; a = exponent - 1 (remove bias + 1)
   jp c, error_llznc           ; if exponent <= 0, return 0
   
am48_dfix64_0:

   cpl
   add a,63                    ; a = 63 - exponent = number of shifts - 1
   
   jp m, am48_derror_erange_longlongc  ; if number too large (exponent >= 64)
   
   inc a                       ; a = number of shifts
   or a                        ; clear carry

   bit 7,b
   push af                     ; save sign
   set 7,b                     ; restore mantissa bit

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
   
   pop af                      ; z flag set if positive
   ret z
   
   jp l_neg_64_dehldehl
