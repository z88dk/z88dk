;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __FASTCALL__ vz_color(int n)

SECTION code_clib
PUBLIC vz_color
PUBLIC _vz_color

.vz_color
._vz_color

   ld a,l
   and $07
   ld ($ffff),a
   ret

