
; bv_priority_queue_t *
; bv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_init_callee

EXTERN asm_bv_priority_queue_init

bv_priority_queue_init_callee:

   pop af
   exx
   pop hl
   exx
   pop hl
   pop bc
   pop de
   push af
   push ix
   exx
   push hl
   pop ix
   exx

   call asm_bv_priority_queue_init
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_priority_queue_init_callee
defc _bv_priority_queue_init_callee = bv_priority_queue_init_callee
ENDIF

