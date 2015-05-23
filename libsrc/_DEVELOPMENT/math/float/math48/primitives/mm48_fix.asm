
SECTION code_fp_math48

PUBLIC mm48_fix

EXTERN mm48__sright, mm48_error_erange_intc, error_znc

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
   ; uses  : af, bc, de, hl, af'

   exx
   
   ; AC' active

   or a

   bit 7,l                     ;is exponent < 0 ?
   jp z, error_znc             ;if yes return zero

   bit 7,b                     ;Gem fortegn
   ex af,af'
   set 7,b                     ;Saet MSB

mm48__fix1:

   ld a,$80 + 15               ;Test exponent
   cp l
   jp c, mm48_error_erange_intc - 1  ;EXP>15 => overflow
   jr z, mm48__fix2            ;EXP=15 => FIX2
   call mm48__sright           ;EXP<15 => roter til
   inc l                       ;hoejre og laeg 1 til
   jr mm48__fix1               ;exponent

mm48__fix2:

   call mm48__sright           ;Roter til hoejre
   ex af,af'                   ;Negativt fortegn?
   jr z, mm48__fix3            ;Nej => INT2
   ld hl,0                     ;Tag 2's complement
   sbc hl,bc
   or a                        ;Nulstil carry
   ret

mm48__fix3:

   ld h,b                      ;Hent tallet
   ld l,c
   ret
