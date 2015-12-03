
; ===============================================================
; Jun 2007
; ===============================================================
;
; uint zx_aaddr2cy(void *attraddr)
;
; Attribute address to character y coordinate. 
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddr2cy

asm_zx_aaddr2cy:

   ; enter : hl = valid attribute address
   ;
   ; exit  : hl = character y coordinate of attr square
   ;
   ; uses  : af, hl

   add hl,hl
   add hl,hl
   add hl,hl
   
   ld a,h
   and $1f
   
   ld l,a
   ld h,0
   
   ret
