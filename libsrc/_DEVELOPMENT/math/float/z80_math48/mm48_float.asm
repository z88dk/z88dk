
SECTION code_fp_math48

PUBLIC mm48_float

EXTERN mm48__zero, mm48__sleft

mm48_float:

;     Convert 16-bit integer to a floating point number
;     -------------------------------------------------
;
;
;     NAME:      FLOAT
;     FUNCTION:  AC=FLOAT(HL). Convert the 16-bit 2's complement
;                integer in HL to floating point number format
;                and save the result in AC.
;     OFFSET:    3FH
;     STACK:     2 bytes.
;     EXAMPLE:   FLOAT(0001H)=1
;                FLOAT (FFFFH)=-1

   ld a,h                      ;Er HL=0?
   or l
   jp z, mm48__zero            ;Ja => ZERO

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
   ret c                       ;Ja => Retur
   res 7,b                     ;Positivt
   ret
