
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; library variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __clib_balloc_table_size > 0

   ; create balloc table
   
   SECTION data_clib
   SECTION data_alloc_balloc
   
   PUBLIC __balloc_array
   
   __balloc_array:             defw __balloc_table
   
   SECTION bss_clib
   SECTION bss_alloc_balloc
   
   __balloc_table:             defs __clib_balloc_table_size * 2

ENDIF

IF __clib_malloc_heap_size = -1

   ; place malloc heap between bss section and bottom of the stack
   
   SECTION data_clib
   SECTION data_alloc_malloc
   
   PUBLIC __malloc_heap

   EXTERN __BSS_END_tail

   __malloc_heap:              defw __BSS_END_tail
   
   SECTION code_crt_init
      
   ld hl,-1                    ; ensure sp == 0 is accepted
   add hl,sp                   ; hl = top of the stack
   
   ld de,__BSS_END_tail
   
   xor a
   sbc hl,de                   ; hl = space between top of stack and end of bss - 1

   jp c, __Exit                ; if stack overlaps bss, this is a fatal error
   
   ld bc,__crt_stack_size + 14 ; amount of space reserved by stack + minimum heap size - 1
   sbc hl,bc                   ; hl = max heap size - 15
   
   jp c, __Exit                ; if no room for heap, this is a fatal error
   
   ld bc,15
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = available heap size
   
   ex de,hl                    ; hl = __BSS_END_tail = start of heap
   
   EXTERN asm_heap_init
   call asm_heap_init
   
ENDIF

IF __clib_malloc_heap_size > 14

   ; create malloc heap in bss section
   
   SECTION data_clib
   SECTION data_alloc_malloc
   
   PUBLIC __malloc_heap
   
   __malloc_heap:              defw __malloc_block
   
   SECTION bss_clib
   SECTION bss_alloc_malloc
   
   __malloc_block:             defs __clib_malloc_heap_size
   
   SECTION code_crt_init
   
   ld hl,__malloc_block
   ld bc,__clib_malloc_heap_size
   
   EXTERN asm_heap_init
   call asm_heap_init

ENDIF

   ; create exit stack
   
   SECTION bss_clib
   SECTION bss_stdlib
   
   PUBLIC __exit_stack
   
   __exit_stack:               defb 0
                               defs __exit_stack_size * 2
   
   ; create quickexit stack
   
   SECTION bss_clib
   SECTION bss_stdlib
   
   PUBLIC __quickexit_stack
   
   __quickexit_stack:          defb 0
                               defs __quickexit_stack_size * 2
   
   ; assign thread id
   
   SECTION data_clib
   SECTION data_threads
   
   PUBLIC __thrd_id
   
   __thrd_id:                  defb 1

;; end library variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
