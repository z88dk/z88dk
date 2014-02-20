
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
; If n > vector.size, vector.array is grown and if that
; is successfully done, new elements are zeroed. 
;
; Carry set on failure.
;
; ===============================================================

XLIB asm_b_vector_resize

LIB l_neg_de, l_ex_bc_de, asm0_b_vector_append_block, asm_memset

asm_b_vector_resize:

   ; enter : hl = b_vector_t *
   ;         bc = size_t n = desired size in bytes
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
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ex de,hl                    ; hl = vector.size
   
   or a
   sbc hl,bc                   ; hl = vector.size - n
   
   ex de,hl
   jr c, size_growing          ; if vector.size < n

size_shrinking:

   ; vector size is shrinking
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; set vector.size = n
   
   ret

size_growing:

   call l_neg_de

   ; hl = & vector.size + 1b
   ; bc = size_t n = new_size
   ; de = num_bytes_being_added

   inc hl
   call l_ex_bc_de
   
   call asm0_b_vector_append_block
   ret c                       ; if growth fails
   
   ; hl = & bytes added to vector.array
   ; bc = num bytes added
   
   ld e,0
   jp asm_memset
