
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dfix32u

EXTERN error_lznc, error_erange_lmc, l_lsr_dehl, am48_dfix32_0

am48_dfix32u:

   ; double to 32-bit unsigned long (truncates)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = AC (AC saved in EXX set)
   ;
   ;         success
   ;
   ;            DEHL = (unsigned long)(x)
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

   bit 7,b
   jp nz, am48_dfix32_0        ; if negative do signed conversion
   set 7,b                     ; restore mantissa bit

   cpl
   add a,32                    ; a = 32 - exponent = number of shifts
   
   jp m, error_erange_lmc      ; if number too large (exponent >= 33)

   ld l,c
   ld h,b
   ex de,hl                    ; dehl = most significant bits
   
   call l_lsr_dehl             ; logical shift right by amount A

   or a                        ; clear carry
   ret
