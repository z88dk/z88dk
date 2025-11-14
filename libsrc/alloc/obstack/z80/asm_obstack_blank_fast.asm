
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_blank_fast(struct obstack *ob, int size)
;
; Resize the currently growing object by signed size bytes.  If
; the object grows, the extra space is uninitialized.
;
; No boundary checks are made.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_blank_fast

asm_obstack_blank_fast:

   ; enter : hl = struct obstack *ob
   ;         bc = int size
   ;
   ; exit  : hl = struct obstack *ob
   ;         de = old ob->fence (if growing, where new space in object begins)
   ;
   ; uses  : f, de
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = ob->fence
   
   push de                     ; save old ob->fence
   
   ex de,hl
   add hl,bc                   ; fence += size
   ex de,hl
   
   ld (hl),d
   dec hl
   ld (hl),e
   
   pop de                      ; de = old fence
   ret
