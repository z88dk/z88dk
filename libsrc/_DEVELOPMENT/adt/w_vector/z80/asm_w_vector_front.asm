
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_front(w_vector_t *v)
;
; Return word stored at front of vector.
;
; ===============================================================

XLIB asm_w_vector_front

LIB asm_w_array_front

asm_w_vector_front:

   jp asm_w_array_front

;defc asm_w_vector_front = asm_w_array_front

   ; enter : hl = vector *
   ;
   ; exit  : de = vector.data
   ;         bc = vector.size in bytes
   ;
   ;         success
   ;
   ;            hl = word at front of vector
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
