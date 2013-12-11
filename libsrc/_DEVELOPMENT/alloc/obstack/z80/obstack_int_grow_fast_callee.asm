
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_int_grow_fast(struct obstack *ob, int data)
;
; Append int to the growing object, no bounds check is made.
;
; ===============================================================

XLIB obstack_int_grow_fast_callee
XDEF asm_obstack_int_grow_fast

obstack_int_grow_fast_callee:

   pop hl
   pop bc
   ex (sp),hl

asm_obstack_int_grow_fast:

   ; enter : hl = struct obstack *ob
   ;         bc = int data
   ;
   ; exit  : hl = struct obstack *ob
   ;
   ; uses  : de
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = ob->fence
   
   ex de,hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; append int to object
   inc hl
   
   ex de,hl
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; ob->fence += 2
   
   ret
