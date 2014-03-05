
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

LIB __vector_resize, l_ex_bc_hl, error_mnc, asm_memset

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
   inc hl                      ; hl = & vector.size
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.size = old_size

   push de                     ; save old_size

   ; hl = & vector.size + 1b
   ; bc = size_t n = new_size
   ; stack = old_size

   call __vector_resize
   jp c, error_zc - 1          ; if resize failed

   ex de,hl
   
   ; bc = new_size
   ; hl = & vector.size + 1b
   ; stack = old_size
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; vector.size = new_size
   
   ; bc = new_size
   ; hl = & vector.size
   ; stack = old_size
   
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = vector.array
   
   ld l,c
   ld h,b                      ; hl = new_size
   
   pop bc                      ; bc = old_size
   
   sbc hl,bc                   ; hl = new_size - old_size
   jp c, error_mnc             ; if new_size < old_size, indicate success
   
   ; size grew, must zero newly appended bytes
   
   call l_ex_bc_hl
   
   ; de = vector.array
   ; hl = old_size
   ; bc = num bytes to zero

   add hl,de                   ; hl = & vector.array[old_size]

   ld e,0
   jp asm_memset
