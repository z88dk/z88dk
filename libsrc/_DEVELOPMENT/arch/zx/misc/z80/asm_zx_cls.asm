
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls(uchar attr)
;
; Clear screen using attibute.
;
; ===============================================================

PUBLIC asm_zx_cls

EXTERN asm_memset

asm_zx_cls:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl
   
   ; attributes
   
   ld e,l
   ld hl,$5800
   ld bc,768
   
   call asm_memset
   
   ; pixels
   
   ld e,0
   ld hl,$4000
   ld bc,6144
   
   jp asm_memset
