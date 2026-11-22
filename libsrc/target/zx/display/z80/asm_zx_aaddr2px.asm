
; ===============================================================
; Jun 2007
; ===============================================================
;
; uchar zx_aaddr2px(void *attraddr)
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
   ; exit  :  l = pixel x coordinate of leftmost pixel in attr square
   ;
   ; uses  : af, l

   ld a,l
   
   add a,a
   add a,a
   add a,a
   
   ld l,a

IF __SCCZ80
   ld h,0
ENDIF

   ret
