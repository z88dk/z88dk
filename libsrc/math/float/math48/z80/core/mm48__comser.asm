
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__comser

EXTERN mm48_equal, mm48_fpmul, mm48__calcs

mm48__comser:

; enter :  a  = loop count
;         AC' = X
;
; exit  : AC' = result
;         AC  = X
;
; uses  : af, bc, de, hl, af', bc', de', hl'

;COMSER udregner en potensraekke af formen:
;T=X*((((X^2+K1)*X^2+K2)....)*X^2+Kn)/Kn,
;hvor X er i AC, n er i A, og adressen paa
;konstanterne (minus 6) i IX.

   exx
   
   push bc                     ;save X
   push de
   push hl
   
   push af                     ;save loop count
   
   call mm48_equal
   call mm48_fpmul
   
   pop af                      ;restore loop count
   
   ; AC = X
   ; AC'= X*X
   
   call mm48__calcs            ;AC'= result
   
   pop hl
   pop de
   pop bc                      ;AC = X
   
   jp mm48_fpmul
