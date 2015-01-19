;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- int vz_getch(void)

PUBLIC vz_getch

.vz_getch

   call $0049                ; wait for keyboard
   ld l,a
   rla                       ; sign extend into h
   sbc a,a
   ld h,a
   ret
