
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; library variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __clib_balloc_table_size > 0

   ; create balloc table
   
   SECTION data_alloc_balloc
   
   PUBLIC __balloc_array
   
   __balloc_array:             defw __balloc_table
   
   SECTION bss_alloc_balloc
   
   __balloc_table:             defs __clib_balloc_table_size * 2

ENDIF

IF __clib_malloc_heap_size > 14

   ; create implied user heap
   
   SECTION data_alloc_malloc
   
   PUBLIC __malloc_heap
   
   __malloc_heap:              defw __malloc_block
   
   SECTION bss_alloc_malloc
   
   __malloc_block:             defs __clib_malloc_heap_size
   
   SECTION code_crt_init
   
   ld hl,__malloc_heap
   ld bc,__clib_malloc_heap_size
   
   EXTERN asm_heap_init
   call asm_heap_init

ENDIF

   ; create exit stack
   
   SECTION bss_stdlib
   
   PUBLIC __exit_stack
   
   __exit_stack:               defb __exit_stack_size
                               defs __exit_stack_size * 2
   
   ; create quickexit stack
   
   SECTION bss_stdlib
   
   PUBLIC __quickexit_stack
   
   __quickexit_stack:          defb __quickexit_stack_size
                               defs __quickexit_stack_size * 2
   
   ; assign thread id
   
   SECTION data_threads
   
   PUBLIC __thrd_id
   
   __thrd_id:                  defb 1

;; end library variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
