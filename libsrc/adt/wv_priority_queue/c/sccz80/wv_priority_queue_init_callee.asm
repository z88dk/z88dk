
; wv_priority_queue_t *
; wv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_init_callee

EXTERN asm_wv_priority_queue_init

wv_priority_queue_init_callee:

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

   call asm_wv_priority_queue_init
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_priority_queue_init_callee
defc _wv_priority_queue_init_callee = wv_priority_queue_init_callee
ENDIF

