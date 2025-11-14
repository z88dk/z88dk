
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_alloc(struct obstack *ob, size_t size)
;
; Allocate an uninitialized block of size bytes from the obstack.
; Implicitly closes any growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_alloc

EXTERN asm0_obstack_blank

asm_obstack_alloc:

   ; enter : hl = struct obstack *ob
   ;         bc = size_t size
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = address of allocated memory
   ;
   ;         fail on insufficient memory
   ;
   ;            carry set
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl

   call asm0_obstack_blank     ; allocate
   ret c                       ; insufficient space
   
   ; hl = struct obstack *ob
   ; de = address of allocated memory

   ; need to close currently growing object
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = ob->fence
   inc hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; ob->object = fence
   
   ex de,hl                    ; hl = address of allocated memory
   ret
