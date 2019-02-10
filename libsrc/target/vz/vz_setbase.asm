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
EXTERN base_graphics


.vz_setbase
._vz_setbase

   ld (base_graphics),hl
   ret

 
