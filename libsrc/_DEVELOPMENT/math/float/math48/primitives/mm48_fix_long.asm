
SECTION code_fp_math48

PUBLIC mm48_fix_long

EXTERN error_lznc, mm48_error_erange_longc, l_lsr_dehl, l_neg_dehl

mm48_fix_long:

   ; floating point number to signed 32-bit integer (truncates)
   ;
   ; enter : AC'(BCDEHL') = float x
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
   jp p, error_lznc            ; if exponent < 0, return 0
   
   bit 7,b
   ex af,af'                   ; save sgn(x)
   set 7,b                     ; set msb

   ld a,$80 + 30
   sub l
   inc a
   inc a                       ; a = amount to shift right
   
   jp c, mm48_error_erange_longc - 1  ; if number too large
   
   ld l,c
   ld h,b
   ex de,hl                    ; dehl = most significant bits
   
   call l_lsr_dehl             ; logical shift right by amount a
   
   ex af,af'                   ; z flag set if positive
   
   ret z
   jp l_neg_dehl
