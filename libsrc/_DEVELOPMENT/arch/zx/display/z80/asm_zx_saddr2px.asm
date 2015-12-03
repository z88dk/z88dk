
; ===============================================================
; Jun 2007
; ===============================================================
;
; uint zx_saddr2px(void *saddr)
;
; Pixel x coordinate corresponding to the leftmost pixel at
; of the screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddr2px

asm_zx_saddr2px:

   ; enter : hl = screen address
   ;
   ; exit  : hl = pixel x coordinate of leftmost pixel in byte
   ;              at screen address
   ;
   ; uses  : af, hl

   ld a,l
   add a,a
   add a,a
   add a,a
   
   ld l,a
   ld h,0
   
   ret
