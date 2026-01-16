
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int obstack_grow(struct obstack *ob, void *data, size_t size)
;
; Grow the current object by appending size bytes read from
; address data.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_grow

EXTERN asm0_obstack_blank, asm_memcpy

asm_obstack_grow:

   ; enter : hl = struct obstack *ob
   ;         bc = size_t size
   ;         de = void *data
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = non-zero
   ;            de = address of byte following grown area
   ;
   ;         fail on insufficient memory
   ;
   ;            carry set
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save data
   call asm0_obstack_blank     ; de = & allocated bytes
   pop hl                      ; hl = data
   ret c
   
   jp asm_memcpy
