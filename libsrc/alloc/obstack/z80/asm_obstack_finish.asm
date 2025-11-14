
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_finish(struct obstack *ob)
;
; Return the address of the currently growing object and close
; it.  The next use of the grow functions will create a new
; object.
;
; If no object was growing, the returned address is the next
; free byte in the obstack and this should be treated as a
; zero length block.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_finish

asm_obstack_finish:

   ; enter : hl = struct obstack *ob
   ;
   ; exit  : hl = address of currently growing object
   ;         growing object is closed
   ;
   ; uses  : bc, de, hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = ob->fence
   inc hl
   
   ld e,(hl)
   ld (hl),c
   inc hl
   ld d,(hl)                   ; de = ob->object
   ld (hl),b                   ; ob->object = ob->fence
   
   ex de,hl
   ret
