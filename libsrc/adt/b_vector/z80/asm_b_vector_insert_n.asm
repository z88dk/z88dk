
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_insert_n(b_vector_t *v, size_t idx, size_t n, int c)
;
; Insert n bytes before vector.data[idx], fill that area with
; char c and return the index of the first char inserted.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_insert_n

EXTERN asm_b_vector_insert_block, asm_memset, error_mc

asm_b_vector_insert_n:

   ; enter : hl = vector *
   ;         de = n
   ;         bc = idx
   ;          a = char c
   ;
   ; exit  : success
   ;
   ;            de = & vector.data[idx]
   ;            hl = idx of first char inserted
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   push bc                     ; save idx
   push af                     ; save char
   push de                     ; save n
   
   call asm_b_vector_insert_block

   pop bc                      ; bc = n
   pop de
   ld e,d                      ; e = char c
   
   jp c, error_mc - 1
   
   call asm_memset             ; fill inserted block
   
   pop de                      ; de = idx
   ex de,hl

   ret
