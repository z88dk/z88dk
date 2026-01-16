
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_int

EXTERN mm48__zero, mm48__retzero, mm48__right, mm48__add10

mm48_int:

   ; floating point integer part
   ; AC' = integer_part(AC')
   ;
   ; if AC'>=0: AC is set equal to the nearest integer that is
   ;               less than or equal to the number in AC.
   ;
   ; if AC'< 0:  AC is set equal to the nearest integer that is
   ;                larger than or equal to the number in AC.
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : AC'(BCDEHL') = integer part of x
   ;
   ; note  : INT( 3.7)= 3
   ;         INT(-3.7)=-3
   ;
   ; uses  : af, af', bc', de', hl'

   exx
   
   ; AC = x

   ld a,l                      ;Er exponent mindre
   sub $80+1                   ;end nul?
   jp c, mm48__retzero         ;Ja => Resultat nul
   inc a

   exx
   
   cp 40
   ret nc                      ; if shifts >= 40, all integer
   
   ; AC' = x
   
   push bc                     ;save AC
   push de
   push hl
   
   ex af,af'
   call mm48__zero             ;AC = 0
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

   jp mm48__add10              ;result in AC'
