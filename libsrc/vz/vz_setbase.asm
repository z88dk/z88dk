;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __FASTCALL__ vz_setbase(void *start)

SECTION code_clib
PUBLIC vz_setbase
PUBLIC _vz_setbase
PUBLIC scrbase

.vz_setbase
._vz_setbase

   ld (scrbase),hl
   ret

	SECTION bss_clib
.scrbase

   defw $7000
 
