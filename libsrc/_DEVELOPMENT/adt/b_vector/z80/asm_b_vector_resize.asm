
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_resize(b_vector_t *v, size_t n)
;
; Attempt to resize the vector to n bytes.
;
; If n <= vector.size, vector.size = n and any elements in
; the vector.array at positions >= n are ignored.
;
; If n > vector.size, vector.data is grown and if that
; is successfully done, new elements are zeroed. 
;
; Carry set on failure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_resize

EXTERN __array_expand, asm0_b_array_resize, __vector_realloc_grow, error_zc

asm_b_vector_resize:

   ; enter : hl = vector *
   ;         de = n = desired size in bytes
   ;
   ; exit  : success
   ;
   ;            hl = non-zero
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail if insufficient memory or lock not acquired
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   inc hl
   inc hl                      ; hl = & vector.size
   
   call __array_expand
   jp nc, asm0_b_array_resize
   
   ; realloc required
   
   ; hl = & vector.size + 1b
   ; de = n
   ; bc = old_size = vector.size

   push bc
   
   ld c,e
   ld b,d                      ; bc = n
   
   dec hl
   dec hl
   dec hl                      ; hl = vector *
   
   call __vector_realloc_grow
   jp c, error_zc - 1          ; if realloc failed
   
   ld e,c
   ld d,b                      ; de = n

   pop bc                      ; bc = old_size
   
   inc hl
   inc hl
   inc hl                      ; hl = & vector.size + 1b

   ld a,1
   jp asm0_b_array_resize
