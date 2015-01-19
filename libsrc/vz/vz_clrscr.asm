;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void vz_clrscr(void)

PUBLIC vz_clrscr

.vz_clrscr                   ; almost same as clg() except ROM call might behave differently
                             ;  for text mode and won't set graphics mode
   jp $01c9                  ; clear screen
