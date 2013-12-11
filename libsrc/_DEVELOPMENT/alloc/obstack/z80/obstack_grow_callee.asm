
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

XLIB obstack_grow_callee
XDEF asm_obstack_grow

LIB asm0_obstack_blank, asm_memcpy

obstack_grow_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

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
   ;            carry set, enomem
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save data
   call asm0_obstack_blank     ; de = & allocated bytes
   pop hl                      ; hl = data
   ret c
   
   jp asm_memcpy
