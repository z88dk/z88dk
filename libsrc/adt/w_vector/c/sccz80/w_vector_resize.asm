
; int w_vector_resize(w_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_resize

EXTERN asm_w_vector_resize

w_vector_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_w_vector_resize

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_resize
defc _w_vector_resize = w_vector_resize
ENDIF

