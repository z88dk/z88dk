;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __FASTCALL__ vz_color(int n)

PUBLIC vz_color

.vz_color

   ld a,l
   and $07
   ld ($ffff),a
   ret

