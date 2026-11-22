
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_next_free(struct obstack *ob)
;
; Returns address of next available byte in the obstack.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_next_free

asm_obstack_next_free:

   ; enter : hl = struct obstack *ob
   ;
   ; exit  : hl = address of next available byte in obstack
   ;
   ; uses  : a, hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = ob->fence
   
   ret
