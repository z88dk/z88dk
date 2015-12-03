
; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_init

EXTERN asm_wa_priority_queue_init

_wa_priority_queue_init:

   pop af
   pop hl
   pop de
   pop bc
   pop ix
   
   push ix
   push bc
   push de
   push hl
   push af

   jp asm_wa_priority_queue_init
