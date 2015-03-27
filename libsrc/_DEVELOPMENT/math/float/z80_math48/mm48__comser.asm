
SECTION code_fp_math48

PUBLIC mm48__comser

EXTERN mm48_equal, mm48_fpmul, mm48__calcs

mm48__comser:

;COMSER udregner en potensraekke af formen:
;T=X*((((X^2+K1)*X^2+K2)....)*X^2+Kn)/Kn,
;hvor X er i AC, n er i A, og adressen paa
;konstanterne (minus 6) i IX.

   push bc                     ;Gem X
   push de
   push hl
   push af                     ;Gem laengde
   call mm48_equal             ;Udregn Z=X^2
   call mm48_fpmul
   pop af                      ;Hent laengde
   call mm48__calcs            ;Udregn raekken
   exx                         ;Hent X
   pop hl
   pop de
   pop bc
   jp mm48_fpmul               ;Gang med X
