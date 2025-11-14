
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_fpdiv

EXTERN mm48__expsgn, mm48__sleft, mm48__left, am48_derror_edom_infc
EXTERN mm48__cmpac, mm48__subac, mm48__mul5, mm48__mul5a

mm48_fpdiv:

   ; floating point divide
   ; AC' = AC' / AC
   ;
   ; enter : AC (BCDEHL ) = float a
   ;         AC'(BCDEHL') = float b
   ;
   ; exit  : AC (BCDEHL ) unchanged
   ;
   ;         success
   ;
   ;            AC'(BCDEHL') = b / a
   ;            carry reset
   ;
   ;         fail if divide by zero
   ;
   ;            AC'(BCDEHL') = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   ; AC active

   inc l
   dec l                       ;is AC zero?
   
   jp z, am48_derror_edom_infc ;if divide by zero

   exx
   
   ; AC' active
   
   ld a,l                      ;is AC' zero?
   or a
   
   exx
   
   ; AC active
   
   ret z                       ;yes return 0

   sub l                       ;subtract exponent
   
   exx
   
   ; AC' active
   
   ccf                         ;Juster exponent og
   call mm48__expsgn           ;udregn fortegn

   push hl                     ;Opret 6 bytes work-
   push hl                     ;space
   push hl
   add ix,sp

   exx                         ;5 bytes
   ld l,5
   exx
   ld a,8                      ;Med hver 8 bits

mm48__divi1:

   ex af,af'                   ;Gem taeller
   call mm48__cmpac            ;Er MANT>MANT'
   jr c, mm48__divi2           ;Nej => DIVI2
   call mm48__subac            ;Traek AC' fra AC

mm48__divi2:

   ccf                         ;Komplementer carry
   rl l                        ;Roter ind i resultat
   ex af,af'                   ;Hent bittaeller
   dec a                       ;Byte faerdig?
   jr nz, mm48__divi3          ;Nej => DIVI3

   ld (ix+5),l                 ;Gem byte i buffer
   dec ix                      ;Peg til naeste
   exx                         ;Er 5 bytes klaret?
   dec l
   exx
   jr z, mm48__divi4           ;Ja => DIVI4
   ld a,8                      ;8 bits

mm48__divi3:

   call mm48__sleft            ;Skift AC til venstre
   jr nc, mm48__divi1          ;Ingen carry => DIVI1

   ex af,af'                   ;Gem taeller
   call mm48__subac            ;MANT=MANT-MANT'
   or a                        ;Nulstil carry
   jr mm48__divi2

mm48__divi4:

   call mm48__sleft            ;Udregn afrundingsbit
   jr c, mm48__divi5
   call mm48__cmpac
   ccf

mm48__divi5:

   pop hl                      ;Hent resultat
   pop de
   pop bc
   bit 7,b                     ;Normaliseret?
   jr nz, mm48__divi6          ;Ja => DIVI6

   call mm48__left             ;Roter afrundingsbit
   jp mm48__mul5               ;ind i resultatet

mm48__divi6:

   inc l                       ;Laeg 1 til exponent
   jp nz, mm48__mul5
   dec l
   scf
   jp mm48__mul5a
