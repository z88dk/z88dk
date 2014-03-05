
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)
;
; Append n copies of char c to the end of the vector, return
; index of new block.
;
; ===============================================================

XLIB asm_b_vector_append_n

LIB asm_b_vector_append_block, asm_memset, error_mc

asm_b_vector_append_n:

   ; enter : hl = b_vector_t *
   ;         bc = size_t n
   ;         de = int c
   ;
   ; exit  : success
   ;
   ;            hl = idx of bytes appended
   ;            de = & vector.array[idx]
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            bc = size_t n
   ;            de = int c
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save char
   
   call asm_b_vector_append_block

   ex de,hl
   ex (sp),hl
   ex de,hl
   
   ; bc = size_t n
   ; de = int c
   ; hl = & vector.array[idx]
   ; stack = idx

   jp c, error_mc - 1          ; if vector growth failed
   
   call asm_memset             ; fill appended bytes

   pop de
   ex de,hl
   
   ret
