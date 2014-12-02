
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls(uchar attr)
;
; Clear screen using attibute.
;
; ===============================================================

SECTION seg_code_arch

PUBLIC asm_zx_cls

EXTERN asm_memset

asm_zx_cls:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl
   
   ld a,l

   ; pixels
   
   ld e,0
   ld hl,$4000
   ld bc,6144

   ; attributes
   
   ld e,a
   ld hl,$5800
   ld bc,768
   
   jp asm_memset
