
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dfix16, am48_dfix16_0

EXTERN error_znc, am48_derror_erange_intc, l_lsr_hl, l_neg_hl

am48_dfix16:

   ; double to 16-bit integer (truncates)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = AC (AC saved in EXX set)
   ;
   ;         success
   ;
   ;            HL = (int)(x)
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

am48_dfix16_0:

   cpl
   add a,15                    ; a = 15 - exponent = number of shifts - 1

   jp m, am48_derror_erange_intc  ; if number too large (exponent >= 16)

   inc a                       ; a = number of shifts
   or a                        ; clear carry
   
   bit 7,b
   push af                     ; save sign
   set 7,b                     ; restore mantissa bit
   
   ld l,c
   ld h,b                      ; hl = most significant bits
   
   call l_lsr_hl               ; logical shift right by amount A
   
   pop af                      ; z flag reset if positive
   ret z
   
   jp l_neg_hl
