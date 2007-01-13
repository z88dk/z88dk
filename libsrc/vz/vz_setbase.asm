;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __FASTCALL__ vz_setbase(void *start)

XLIB vz_setbase
XDEF scrbase

.vz_setbase

   ld (scrbase),hl
   ret

.scrbase

   defw $7000
 