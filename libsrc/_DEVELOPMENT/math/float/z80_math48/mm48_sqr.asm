
SECTION code_fp_math48

PUBLIC mm48_sqr

EXTERN mm48_equal, mm48_fpdiv, mm48_fpadd, mm48_fpsub, mm48__add10

mm48_sqr:

;     Square Root
;     -----------
;
;     NAME:      SQR
;     FUNCTION:  AC=SQR(AC). AC is set equal to the square root
;                of AC.
;     OFFSET:    15H
;     OUTPUT:    CF=0: OK.
;                CF=1: AC<0.
;     STACK:     31 bytes.

;Kvadratroden beregnes med Newton-Raphson
;iterationsmetoden. Et gaet udregnes ud fra
;det foregaaende gaet efter formelen:
;I(n+1)=(X/I(n)+I(n))/2.
;Som foerste gaet halveres X's exponent.
;Der fortsaettes indtil ABS(I(n+1)-I(n)) er
;mindre end den halve exponent af X minus 20.

   ld a,l                      ;Er AC nul?
   or a
   ret z                       ;Ja => Returer

   bit 7,b                     ;Er AC negativ?
   scf                         ;Saet carry
   ret nz                      ;Ja => Returner

   exx                         ;Gem AC'
   push bc
   push de
   push hl
   exx
   call mm48_equal             ;AC'=AC
   ld a,l                      ;Foerste iteration:
   add a,$80                   ;halver exponenten
   sra a
   add a,$80
   ld l,a                      ;Sammenligningsvaerdi
   sub 20                      ;er den halve exponent
   push af                     ;Gem s.vaerdi
   exx

mm48__sqr1:

   push bc                     ;Gem tallet
   push de
   push hl
   call mm48_fpdiv             ;Divider med og adder
   call mm48_fpadd             ;forrige gaet
   dec l                       ;Halver
   push bc                     ;Gem dette gaet
   push de
   push hl
   call mm48_fpsub             ;Udregn forskellen mel-
   ld a,l                      ;lem de to gaet
   pop hl                      ;Hent det nye gaet
   pop de
   pop bc
   exx
   pop hl                      ;Hent tallet
   pop de
   pop bc
   ex (sp),hl                  ;Hent s.vaerdi ind i H
   cp h
   ex (sp),hl                  ;Fortsaet indtil forsk.
   jr nc, mm48__sqr1           ;er lille nok

   pop af                      ;Fjern s.vaerdi
   exx
   or a                        ;Nulstil carry

mm48__sqr2:

   jp mm48__add10              ;Hent AC'
