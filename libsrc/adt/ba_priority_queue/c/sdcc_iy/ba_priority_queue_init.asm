
; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_init

EXTERN asm_ba_priority_queue_init

_ba_priority_queue_init:

   pop af
   pop hl
   pop de
   pop bc
   pop ix

   push hl
   push bc
   push de
   push hl
   push af

   jp asm_ba_priority_queue_init
