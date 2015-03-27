
SECTION code_fp_math48

PUBLIC mm48_fix

EXTERN mm48__sright

mm48_fix:

;     Convert floating point number to a 16-bit integer
;     -------------------------------------------------
;
;     NAME:      FIX.
;     FUNCTION:  HL=FIX(AC). convert the integer part of the floating
;                number in AC to a 16-bit 2's complement integer, and
;                save the result in the HL register.
;     OFFSET:    3CH
;     OUTPUT:    CF=0: OK.
;                CF=1: ABS(INT(AC)) > 32767
;     STACK:     2 bytes.
;     EXAMPLE:   FIX(1.5)=    1=  0001H
;                FIX(-1.5)=  -1=  FFFFH
;                FIX(0.5)=    0=  0000H

   or a
   bit 7,l                     ;Exponent<0?
   jr z, mm48__fix4            ;Ja => FIX4
   bit 7,b                     ;Gem fortegn
   ex af,af'
   set 7,b                     ;Saet MSB

mm48__fix1:

   ld a,$80 + 15               ;Test exponent
   cp l
   ret c                       ;EXP>15 => overflow
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

mm48__fix4:

   ld hl,0       ;Underflow
   ret
