
SECTION code_fp_math48

PUBLIC mm48_fpmul
PUBLIC mm48__mul5, mm48__mul5a

EXTERN mm48__zero, mm48__expsgn, mm48__addac
EXTERN mm48__right, mm48__left

mm48_fpmul:

;     Multiplication
;     --------------
;
;     NAME:      FPMUL
;     FUNCTION:  AC=AC*AC'. The number in AC is multiplied by
;                the number in AC' and the result is placed in AC.
;     OFFSET:    06H
;     OUTPUT:    CF=0: OK.
;                CF=1: Overflow.
;     STACK:     16 bytes.

   exx                         ;Er AC' nul?
   ld a,l
   or a
   exx
   jp z, mm48__zero            ;Ja => Resultat 0

   ld a,l                      ;Er AC nul?
   or a
   ret z                       ;Ja => Retur

   exx                         ;Adder exponenter
   add a,l
   exx                         ;Juster exponent og
   call mm48__expsgn           ;udregn fortegn

   push bc                     ;Gem AC
   push de
   push hl
   add ix,sp                   ;Peg IX til AC

   call mm48__zero             ;Nulstil resultat
   exx                         ;5 bytes
   ld l,5
   exx

mm48__mul1:

   ld a,8                      ;Bittaeller lig 8
   inc ix                      ;Hent ny byte
   ld l,(ix+0)

mm48__mul2:

   ex af,af'                   ;Gem taeller
   rr l                        ;Roter byte til hoejre
   jr nc, mm48__mul3           ;Hvis carry saa laeg
   call mm48__addac            ;AC' til resultatet

mm48__mul3:

   call mm48__right            ;Roter res. til hoejre
   ex af,af'                   ;Hent taeller
   dec a                       ;Byte faerdig?
   jr nz, mm48__mul2           ;Nej => MUL2
   exx                         ;5 bytes klaret?
   dec l
   exx
   jr nz, mm48__mul1           ;Nej => MUL1

   ld l,(ix-5)                 ;Hent exponent
   bit 7,b                     ;Normaliseret?
   jr nz, mm48__mul4           ;Ja => MUL4

   ex af,af'                   ;Hent sidste carry
   call mm48__left             ;Roter res. til venstre
   inc l                       ;Traek 1 fra exponent
   dec l
   jr z, mm48__mul4
   dec l

mm48__mul4:

   pop af                      ;Fjern workspace
   pop af
   pop af

mm48__mul5:

   or a                        ;Status = OK

mm48__mul5a:

   ex af,af'                   ;Gem status
   pop af                      ;Hent res. fortegn
   exx
   pop bc                      ;Hent AC' fortegn
   pop hl                      ;Hent AC' exponent
   exx
   pop ix                      ;Hent IX
   res 7,b                     ;Erstat MSB i AC med
   or b                        ;fortegn
   ld b,a
   ex af,af'                   ;Hent status
   inc l
   dec l
   jp z, mm48__zero
   ret
