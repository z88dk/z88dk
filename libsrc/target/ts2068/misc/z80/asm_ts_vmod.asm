; ===============================================================
; 2017
; ===============================================================
; 
; void ts_vmod(unsigned char mode)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_ts_vmod

asm_ts_vmod:

   ; change video mode
   ;
   ; enter : l = mode
   ;
   ; uses  : af, l
   
   ld a,l
   xor $38
   and $3f
   ld l,a
   
   in a,($ff)
   and $c0
   or l
   out ($ff),a
   
   ret
