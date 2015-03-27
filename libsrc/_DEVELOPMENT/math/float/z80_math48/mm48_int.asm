
SECTION code_fp_math48

PUBLIC mm48_int

EXTERN mm48__zero, mm48__right, mm48__add10

mm48_int:

;     Integer
;     -------
;
;     NAME:      INT
;     FUNCTION:  AC>=0: AC is set equal to the nearest integer that is
;                       less than or equal to the number in AC.
;                AC<0:  AC is set equal to the nearest integer that is
;                       larger than or equal to the number in AC.
;     OFFSET:    30H
;     STACK:     8 bytes.
;     EXAMPLE:   INT(3.7)=3
;                INT(-3.7)=-3

   ld a,l                      ;Er exponent mindre
   sub $80+1                   ;end nul?
   jp c, mm48__zero            ;Ja => Resultat nul
   inc a

   exx                         ;Gem AC'
   push bc
   push de
   push hl
   ex af,af'
   call mm48__zero             ;Nulstil AC'
   ex af,af'

mm48__int1:

   scf                         ;Saet alle bits der har
   call mm48__right            ;en exponent stoerre
   dec a                       ;end eller lig nul
   jr nz, mm48__int1

   exx                         ;Nulstil alle bits i AC
   ld a,h                      ;der har en exponent
   exx                         ;mindre end 0
   and h
   exx
   ld h,a
   ld a,e
   exx
   and e
   exx
   ld e,a
   ld a,d
   exx
   and d
   exx
   ld d,a
   ld a,c
   exx
   and c
   exx
   ld c,a
   ld a,b
   exx
   and b
   exx
   ld b,a
   
mm48__int2:

   jp mm48__add10              ;Hent AC'
