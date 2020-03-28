;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- int vz_getch(void)

SECTION code_clib
PUBLIC vz_getch
PUBLIC _vz_getch

.vz_getch
._vz_getch

   call $0049                ; wait for keyboard
   ld l,a
   rla                       ; sign extend into h
   sbc a,a
   ld h,a
   ret
