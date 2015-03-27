
SECTION code_fp_math48

PUBLIC mm48__calcs

EXTERN mm48__ac1, mm48__gtncix, mm48__getcix
EXTERN mm48_fpmul, mm48_fpadd, mm48_fpdiv

mm48__calcs:

;CALCS udregner en potensraekke af formen:
;U=(((((Z+K1)*Z+K2)*Z+K3)....)*Z+Kn)/Kn,
;hvor Z er i AC, n er i A, og adressen paa
;konstanterne (minus 6) i IX.

   exx                         ;Gem Z i AC'
   call mm48__ac1              ;Start med resultat=1

mm48__calc1:

   push af                     ;Gang med Z
   call mm48_fpmul
   pop af
   push af
   exx
   push bc                     ;Gem Z
   push de
   push hl
   call mm48__gtncix           ;Hent naeste konstant
   call mm48_fpadd             ;Laeg til resultat
   exx                         ;Hent Z
   pop hl
   pop de
   pop bc
   exx
   pop af                      ;Faerdig?
   dec a
   jr nz, mm48__calc1          ;Nej => CALC1
   exx
   call mm48__getcix
   exx
   jp mm48_fpdiv
