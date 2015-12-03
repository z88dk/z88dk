
; ===============================================================
; Jun 2007
; ===============================================================
;
; uint zx_aaddr2px(void *attraddr)
;
; Attribute address to pixel x coordinate. 
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddr2px

asm_zx_aaddr2px:

   ; enter : hl = valid attribute address
   ;
   ; exit  : hl = pixel x coordinate of leftmost pixel in attr square
   ;
   ; uses  : af, hl

   ld a,l
   
   rla
   rla
   rla
   and $f8
   
   ld l,a
   ld h,0
   
   ret
