
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dfix32, am48_dfix32_0

EXTERN error_lznc, am48_derror_erange_longc, l_lsr_dehl, l_neg_dehl

am48_dfix32:

   ; double to signed 32-bit integer (truncates)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = AC (AC saved in EXX set)
   ;
   ;         success
   ;
   ;            DEHL = (long)(x)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            HL = long_max or long_min
   ;            carry set, errno set
   ;
   ; notes : FIX(1.5)=    1=  $0001
   ;         FIX(-1.5)=  -1=  $FFFF
   ;         FIX(0.5)=    0=  $0000
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   exx
   
   ; AC = x

   ld a,l
   or a
   
   jp z, error_lznc            ; if x == 0, return 0
   
   sub $81                     ; a = exponent - 1 (remove bias + 1)
   jp c, error_lznc            ; if exponent <= 0, return 0

am48_dfix32_0:

   cpl
   add a,31                    ; a = 31 - exponent = number of shifts - 1

   jp m, am48_derror_erange_longc  ; if number too large (exponent >= 32)
   
   inc a                       ; a = number of shifts
   or a                        ; clear carry

   bit 7,b
   push af                     ; save sign
   set 7,b                     ; restore mantissa bit
   
   ld l,c
   ld h,b
   ex de,hl                    ; dehl = most significant bits
   
   call l_lsr_dehl             ; logical shift right by amount A
   
   pop af                      ; z flag reset if positive
   ret z
   
   jp l_neg_dehl
