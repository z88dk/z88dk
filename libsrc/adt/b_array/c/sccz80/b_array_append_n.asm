
; size_t b_array_append_n(b_array_t *a, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_append_n

EXTERN asm_b_array_append_n

b_array_append_n:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_b_array_append_n

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_append_n
defc _b_array_append_n = b_array_append_n
ENDIF

