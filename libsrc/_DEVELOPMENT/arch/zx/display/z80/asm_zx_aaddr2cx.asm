
; ===============================================================
; Jun 2007
; ===============================================================
;
; uint zx_aaddr2cx(void *attraddr)
;
; Attribute address to character x coordinate. 
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddr2cx

asm_zx_aaddr2cx:

   ; enter : hl = valid attribute address
   ;
   ; exit  : hl = character x coordinate of attr square
   ;
   ; uses  : af, hl

   ld a,l
   and $1f
   
   ld l,a
   ld h,0
   
   ret
