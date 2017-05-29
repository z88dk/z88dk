; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrcdown(void *aaddr)
;
; Modify attribute address to move down one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrcdown

asm_tshc_aaddrcdown:

   ; enter : hl = attribute address
   ;
   ; exit  : hl = attribute address down one character
   ;         carry set if new attribute address is off screen
   ;
   ; uses  : af, hl

   ld a,l
   add a,$20
   ld l,a
   ret nc
   
   ld a,h
   add a,$08
   ld h,a
   
   cp $78
   ccf
   ret

