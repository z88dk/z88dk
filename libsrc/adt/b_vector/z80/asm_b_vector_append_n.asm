
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)
;
; Append n copies of char c to the end of the vector, return
; index of new block.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_append_n

EXTERN asm_b_vector_append_block, asm_memset, error_mc

asm_b_vector_append_n:

   ; enter : hl = vector *
   ;         de = n
   ;         bc = int c
   ;
   ; exit  : success
   ;
   ;            hl = idx of bytes appended
   ;            de = & vector.data[idx]
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   push bc                     ; save char
   
   call asm_b_vector_append_block
   jp c, error_mc - 1

   ; append successful, now fill appended area

   ex de,hl
   ex (sp),hl
   ex de,hl
   
   ; bc = n
   ; de = int c
   ; hl = & vector.data[idx]
   ; stack = idx
   
   call asm_memset
   
   pop de
   ex de,hl
   
   ret
