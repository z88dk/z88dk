
SECTION code_fp_math48

PUBLIC mm48_fix

EXTERN error_znc, mm48_error_erange_intc, l_lsr_hl, l_neg_hl

mm48_fix:

   ; floating point number to 16-bit integer (truncates)
   ;
   ; enter : AC'(BCDEHL') = float x
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
   jp p, error_znc             ; if exponent < 0, return 0

   bit 7,b                     ;Gem fortegn
   ex af,af'
   set 7,b                     ;Saet MSB

   ld a,$80 + 14
   sub l
   inc a                       ; a = amount to shift right
   
   jp c, mm48_error_erange_intc - 1  ; if number too large
   
   ld l,c
   ld h,b                      ; hl = most significant bits
   
   call l_lsr_hl               ; logical shift right by amount a
   
   ex af,af'                   ; z flag set if positive
   
   ret z
   jp l_neg_hl
