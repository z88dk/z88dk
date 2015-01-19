;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __FASTCALL__ vz_setbase(void *start)

PUBLIC vz_setbase
PUBLIC scrbase

.vz_setbase

   ld (scrbase),hl
   ret

.scrbase

   defw $7000
 