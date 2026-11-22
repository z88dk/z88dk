
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_copy(struct obstack *ob, void *address, size_t size)
;
; Attempt to allocate size bytes from the obstack and initialize
; it by copying data from address.  Implicitly closes any growing
; object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_copy

EXTERN asm_obstack_alloc, asm_memcpy

asm_obstack_copy:

   ; enter : hl = struct obstack *ob
   ;         bc = size_t size
   ;         de = void *address
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

   push de                     ; save address
   push bc                     ; save size
   
   call asm_obstack_alloc      ; hl = & allocated memory

   pop bc
   pop de
   
   ret c                       ; carry if insufficient memory
   
   ex de,hl
   jp asm_memcpy               ; copy size bytes from address to allocated memory
