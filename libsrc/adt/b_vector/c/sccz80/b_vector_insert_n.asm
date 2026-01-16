
; size_t b_vector_insert_n(b_vector_t *v, size_t idx, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_insert_n

EXTERN asm_b_vector_insert_n

b_vector_insert_n:

   pop ix
   pop de
   ld a,e
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push de
   push ix

   jp asm_b_vector_insert_n

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_insert_n
defc _b_vector_insert_n = b_vector_insert_n
ENDIF

