
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48__dtoa_base16

am48__dtoa_base16:

   ; enter : AC'= double x, x positive
   ;
   ; exit  : HL'= mantissa *
   ;         DE'= stack adjust
   ;          C = max number of significant hex digits (10)
   ;          D = base 2 exponent e
   ;
   ; uses  : af, c, d, hl, bc', de', hl'

   exx
   
   pop af
   
   set 7,b                     ; push mantissa onto the stack
   push bc
   push de
   push hl
   
   push af
   
   ld a,l
   
   ld hl,7
   add hl,sp                   ; hl = mantissa *
   
   ld de,6
   
   exx
   
   sub $80
   ld d,a                      ; d = base 2 exponent
   
   ld c,10                     ; max 10 hex digits
   ret
