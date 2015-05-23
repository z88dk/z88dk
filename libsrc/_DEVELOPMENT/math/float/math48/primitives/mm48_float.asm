
SECTION code_fp_math48

PUBLIC mm48_float

EXTERN mm48__retzero, mm48__sleft

mm48_float:

   ; 16-bit integer to floating point number
   ;
   ; enter : HL = 16-bit integer n
   ;
   ; exit  : AC = AC' (AC' saved)
   ;         AC'= (float)(n)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   ld a,h                      ;Er HL=0?
   or l
   jp z, mm48__retzero         ;Ja => ZERO

   bit 7,h                     ;Er HL negativ?
   jr z, mm48__flt1            ;Nej => FLT1

   ex de,hl                    ;Tag 2's complement
   ld hl,0
   or a
   sbc hl,de

mm48__flt1:

   ex af,af'                   ;Gem fortegn i F'
   ld b,h                      ;Saet mantissa
   ld c,l
   ld de,0
   ld hl,$80 + 16              ;Saet exponent

mm48__flt2:

   bit 7,b                     ;Normaliser
   jr nz, mm48__flt3
   call mm48__sleft
   dec l
   jr mm48__flt2

mm48__flt3:

   ex af,af'                   ;Negativt?
   jr c, exit                  ;if yes
   res 7,b                     ;Positivt
   
exit:

   exx
   ret
