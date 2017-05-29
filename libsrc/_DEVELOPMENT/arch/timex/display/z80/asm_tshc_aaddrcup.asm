; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrcup(void *saddr)
;
; Modify attribute address to move up one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrcup

asm_tshc_aaddrcup:

   ; enter : hl = attribute address
   ;
   ; exit  : hl = attribute address one character up
   ;         carry set if new attribute address is off screen
   ;
   ; uses  : af, hl

   ld a,l
   sub $20
   ld l,a
   ret nc
   
   ld a,h
   sub $08
   ld h,a
   
   cp $60
   ret
