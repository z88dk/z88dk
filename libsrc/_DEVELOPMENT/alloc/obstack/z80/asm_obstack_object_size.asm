
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_object_size(struct obstack *ob)
;
; Return the size in bytes of the currently growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_object_size

asm_obstack_object_size:

   ; enter : hl = struct obstack *ob
   ;
   ; exit  : hl = size of currently growing object
   ;         z flag set if there is no growing object
   ;
   ; uses  : af, de, hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = ob->fence
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = ob->object
   
   ex de,hl

   or a
   sbc hl,de
   ret
