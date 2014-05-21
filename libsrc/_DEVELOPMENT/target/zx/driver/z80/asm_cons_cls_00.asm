
PUBLIC asm_cons_cls_00

; full screen cls
; * attribute value comes from _cons_attr_p

EXTERN _cons_attr_p, asm_memset

asm_cons_cls_00:

   ; attributes

   ld a,(_cons_attr_p)

   ld hl,$5800
   ld bc,768
   ld e,a
   
   call asm_memset
   
   ; pixels
   
   ld e,0
   ld hl,$4000
   ld bc,6144
   
   jp asm_memset
