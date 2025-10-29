
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_1grow_fast(struct obstack *ob, char c)
;
; Append char c to the growing object, no bounds check made.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_1grow_fast

asm_obstack_1grow_fast:

   ; enter : hl = struct obstack *ob
   ;          a = char c
   ;
   ; exit  : hl = struct obstack *ob
   ;
   ; uses  : de

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = ob->fence
   
   ld (de),a                   ; write char
   inc de
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; ob->fence++
   
   ret
