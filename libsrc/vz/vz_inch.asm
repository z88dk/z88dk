;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- int vz_inch(void)

PUBLIC vz_inch

.vz_inch                     ; almost same as getk() except for the sign extension

   call $2ef4
   ld l,a
   rla                       ; sign extend into h
   sbc a,a
   ld h,a
   ret
