;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void vz_clrscr(void)

SECTION code_clib
PUBLIC vz_clrscr
PUBLIC _vz_clrscr

.vz_clrscr                   ; almost same as clg() except ROM call might behave differently
._vz_clrscr
                             ;  for text mode and won't set graphics mode
   jp $01c9                  ; clear screen
