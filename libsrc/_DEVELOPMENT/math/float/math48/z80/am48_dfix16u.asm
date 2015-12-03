
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dfix16u

EXTERN error_znc, error_erange_mc, l_lsr_hl, am48_dfix16_0

am48_dfix16u:

   ; double to 16-bit unsigned integer (truncates)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = AC (AC saved in EXX set)
   ;
   ;         success
   ;
   ;            HL = (unsigned int)(x)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            HL = int_max or int_min
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

   jp z, error_znc             ; if x == 0, return 0
   
   sub $81                     ; a = exponent - 1 (remove bias + 1)
   jp c, error_znc             ; if exponent <= 0, return 0

   bit 7,b
   jp nz, am48_dfix16_0        ; if negative do signed conversion
   set 7,b                     ; restore mantissa bit

   cpl
   add a,16                    ; a = 16 - exponent = number of shifts
   
   jp m, error_erange_mc       ; if number too large (exponent >= 17)

   ld l,c
   ld h,b                      ; hl = most significant bits
   
   call l_lsr_hl               ; logical shift right by amount A

   or a                        ; clear carry
   ret
