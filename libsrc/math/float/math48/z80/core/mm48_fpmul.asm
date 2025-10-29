
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_fpmul, mm48__mul5, mm48__mul5a

EXTERN mm48__zero, mm48__retzero, mm48__expsgn, mm48__addac
EXTERN mm48__right, mm48__left, am48_derror_erange_infc

mm48_fpmul:

   ; floating point multiply
   ; AC' = AC' * AC
   ;
   ; enter : AC (BCDEHL ) = float a
   ;         AC'(BCDEHL') = float b
   ;
   ; exit  : AC (BCDEHL ) unchanged
   ;
   ;         success
   ;
   ;            AC'(BCDEHL') = a * b
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   ; AC active

   ld a,l                      ;is AC zero?
   or a
   
   exx
   
   ; AC' active
   
   jp z, mm48__zero            ;Ja => Resultat 0 (AC = AC' = 0)

   ld a,l                      ;is AC' zero?
   or a
   
   exx
   
   ; AC active
   
   ret z                       ;yes return 0
   
   add a,l                     ;add exponent
   
   exx                         ;Juster exponent og

   ; AC' active
   
   call mm48__expsgn           ;udregn fortegn

   push bc                     ;Store AC'
   push de
   push hl
   add ix,sp                   ;Point IX at AC'

   call mm48__zero             ;Nulstil resultat
   exx                         ;5 bytes
   ld l,5
   exx

   ; AC' active

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
   pop bc                      ;Hent AC fortegn
   pop hl                      ;Hent AC exponent
   exx
   pop ix                      ;Hent IX
   res 7,b                     ;Erstat MSB i AC med
   or b                        ;fortegn
   ld b,a
   ex af,af'                   ;Hent status
   inc l
   dec l
   jp z, mm48__retzero
   
   exx                         ;result in AC'
   ret nc                      ;if no overflow
   
   jp am48_derror_erange_infc
