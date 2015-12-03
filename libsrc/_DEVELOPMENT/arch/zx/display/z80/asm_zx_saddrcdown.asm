
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddrcdown(void *saddr)
;
; Modify screen address to move down one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddrcdown

asm_zx_saddrcdown:

   ; enter : hl = screen address
   ;
   ; exit  : hl = screen address down one character
   ;         carry set if new screen address is off screen
   ;
   ; uses  : af, hl

   ld a,l
   add a,$20
   ld l,a
   ret nc
   
   ld a,h
   add a,$08
   ld h,a
   
   cp $58
   ccf
   ret
