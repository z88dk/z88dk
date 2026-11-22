
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__calcs

EXTERN mm48__ac1, mm48__getncix, mm48__getcix
EXTERN mm48_fpmul, mm48_fpadd, mm48_fpdiv

mm48__calcs:

; enter :  a  = loop count
;         AC' = Z
;
; exit  : AC' = result
;
; uses  : af, bc, de, hl, af', bc', de', hl'


;CALCS udregner en potensraekke af formen:
;U=(((((Z+K1)*Z+K2)*Z+K3)....)*Z+Kn)/Kn,
;hvor Z er i AC, n er i A, og adressen paa
;konstanterne (minus 6) i IX.

   call mm48__ac1              ;Start med resultat=1
   exx

mm48__calc1:

   ; AC = Z
   ; AC'= result

   push af                     ;save loop count
   
   call mm48_fpmul             ;AC' *= Z
   
   push bc                     ;save Z
   push de
   push hl
   
   call mm48__getncix          ;AC = next constant
   call mm48_fpadd             ;AC' += AC
   
   pop hl                      ;AC = Z
   pop de
   pop bc
   
   pop af                      ;a = loop count
   
   dec a
   jr nz, mm48__calc1
   
   call mm48__getcix           ;Kn
   jp mm48_fpdiv               ;AC'= result
