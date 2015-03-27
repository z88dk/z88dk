
SECTION code_fp_math48

PUBLIC mm48_atn

EXTERN mm48__getcix, mm48__getncix, mm48__ac1, mm48__add10, mm48__comser
EXTERN mm48_cmp, mm48_fpdiv, mm48_fpadd, mm48_fpmul, mm48_acpi, mm48_fpsub

mm48_atn:

;     NAME:      ATN
;     FUNCTION:  AC=ATN(AC). AC is set equal to the arc tangent of AC.
;                The returned values lies in the interval
;                PI/2 > ATN(AC) > -PI/2.
;     OFFSET:    2AH
;     STACK:     42 bytes.
;     EXAMPLE:   ATN( 1 )=PI/4
;                ATN(-1 )=-PI/4

;Hvis X>1 udregnes ATN(X)=PI/2-ATN(1/X).
;Til beregning af ATN(X) bruges:
;Y=X^2, A=PI/24,
;ATN(X)=X(((((Y+K1)*Y+K2)*Y+K3)*Y+K4)*Y+K5)/K5,
;hvor 0<=X<A og
;K1=-11/9  K2=11/7  K3=-11/5  K4=11/3  K5=-11
;X bestemmes til at ligge i et af interv.:
;1. X<TAN(A)
;2. TAN(A)<=X<TAN(3*A)    ,K=2*A
;3. TAN(3*A)<=X<TAN(5*A)  ,K=4*A
;4. X>=TAN(5*A)           ,K=6*A
;Hvis X er i foerste interv. bruges formelen
;alene, men ellers bruges:
;Y=(X-TAN(K))/(1+X*TAN(K))
;ATN(X)=K+ATN(Y)

   ld a,l
   or a
   ret z
   exx                         ;Gem AC'
   push bc
   push de
   push hl
   push ix
   call mm48__ac1              ;AC'=1
   exx
   xor a                       ;Nulstil flagbyte
   bit 7,b                     ;Er AC positiv?
   jr z, mm48__atn1            ;Ja => ATN1

   inc a                       ;Saet negativflag
   res 7,b                     ;AC=ABS(AC)

mm48__atn1:

   push af                     ;Gem flag
   call mm48_cmp               ;Er AC>1
   jr c, mm48__atn2            ;Ja => ATN2

   exx                         ;AC=1/AC
   call mm48_fpdiv
   pop af                      ;Saet reciprokflag
   set 7,a
   push af

mm48__atn2:

   exx
   ld bc,$06CF
   ld de,$E98E
   ld hl,$4A7E
   exx
   call mm48_cmp               ;Er AC<TAN(PI/24)?
   jr nc, mm48__atn3           ;Nej => ATN3

   call mm48__arctan           ;Udregn ATN(X)
   jr mm48__atn6

mm48__atn3:

   ld ix,atnk - 18             ;Peg IX til skalerings-
   ld a,2                      ;konstanter

mm48__atn4:

   ex af,af'                   ;Gem taeller
   exx
   ld de,18                    ;Peg til naeste saet
   add ix,de
   call mm48__getcix           ;Hent oeverste endepkt.
   exx
   call mm48_cmp               ;Er X i dette interval?
   jr c, mm48__atn5            ;Ja => ATN5
   ex af,af'                   ;Hent taeller
   dec a                       ;Faerdig?
   jr nz, mm48__atn4           ;Nej => ATN4

   exx                         ;Juster IX
   ld de,12
   add ix,de
   exx

mm48__atn5:

   exx
   call mm48__gtncix           ;Hent TAN(K)
   set 7,b                     ;Udregn X-TAN(K)
   call mm48_fpadd
   push bc                     ;Gem resultat
   push de
   push hl
   call mm48__getcix           ;Hent TAN(K)
   call mm48_fpmul             ;Udregn X*TAN(K)
   exx
   call mm48__ac1              ;Laeg 1 til
   call mm48_fpadd
   exx                         ;Gem i AC'
   pop hl                      ;Hent forrige resultat
   pop de
   pop bc
   call mm48_fpdiv             ;Udregn Y
   push ix                     ;Udregn ATN(Y)
   call mm48__arctan
   pop ix
   exx
   call mm48__gtncix           ;Hent K
   call mm48_fpadd             ;Udregn K+ATN(Y)

mm48__atn6:

   pop af                      ;Hent flagbyte
   rla                         ;Var X>1?
   jr nc, mm48__atn7           ;Nej => ATN7

   push af                     ;Gem flagbyte
   exx                         ;Udregn PI/2-ATN(X)
   call mm48_acpi
   dec l
   call mm48_fpsub
   pop af                      ;Hent flagbyte

mm48__atn7:

   pop ix                      ;Hent IX
   bit 1,a                     ;Var X<0?
   jr z, mm48__atn8            ;Nej => ATN8
   set 7,b                     ;Resultat negativt

mm48__atn8:

   or a
   jp mm48__add10              ;Hent AC'

mm48__arctan:

   ld ix,arctk - 6
   ld a,5
   jp mm48__comser

;Konstanter til skalering af X under beregning
;af ATN.

atnk:

   defw $5413, $CCCF, $E77F  ;TAN(3*A)
   defw $0930, $A2F4, $F67F  ;TAN(2*A)
   defw $060A, $91C1, $6A7F  ;2*A
   defw $446F, $8A9E, $B580  ;TAN(5*A)
   defw $13CD, $3A2C, $8280  ;TAN(4*A)
   defw $060A, $91C1, $6A80  ;4*A
   defw $0000, $0000, $0081  ;TAN(6*A)
   defw $490F, $DAA2, $2180  ;6*A

;Konstanter for beregning af ATN.

arctk:

   defw $9C71, $C71C, $7281  ;K1
   defw $4924, $9249, $2581  ;K2
   defw $8CCC, $CCCC, $CD82  ;K3
   defw $6AAA, $AAAA, $AB82  ;K4
   defw $B000, $0000, $0084  ;K5
