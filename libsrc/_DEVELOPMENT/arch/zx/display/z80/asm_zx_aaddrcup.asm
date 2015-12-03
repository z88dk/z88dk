
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_aaddrcup(void *aaddr)
;
; Modify attribute address to move up one character square.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddrcup

asm_zx_aaddrcup:

   ; enter : hl = attribute address
   ;
   ; exit  : hl = attribute address up one character
   ;         carry set if new attribute address is off screen
   ;
   ; uses  : af, hl

   ld a,l
   sub $20
   ld l,a
   ret nc
   
   dec h
   
   ld a,h
   cp $58
   ret
