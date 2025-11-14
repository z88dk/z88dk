
; ===============================================================
; Jun 2007
; ===============================================================
;
; uchar zx_aaddr2py(void *attraddr)
;
; Attribute address to pixel y coordinate. 
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddr2py

asm_zx_aaddr2py:

   ; enter : hl = valid attribute address
   ;
   ; exit  :  l = pixel y coordinate of topmost pixel in attr square
   ;
   ; uses  : af, hl
   
   ld a,l
   and $e0
   
   srl h
   rra
   srl h
   rra
   
   ld l,a

IF __SCCZ80
   ld h,0
ENDIF

   ret
