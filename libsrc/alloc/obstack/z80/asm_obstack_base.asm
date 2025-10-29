
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_base(struct obstack *ob)
;
; Returns the address of the currently growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_base

asm_obstack_base:

   ; enter : hl = struct obstack *ob
   ;
   ; exit  : hl = address of currently growing object
   ;
   ; uses  : a, hl
   
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = ob->object
   
   ret
