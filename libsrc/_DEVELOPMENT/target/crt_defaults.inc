
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; crt configuration

   defc DEF__crt_org_code              = 0
   defc DEF__crt_org_data              = 0
   defc DEF__crt_org_bss               = 0

   defc DEF__crt_model                 = 0
   
   defc DEF__register_sp               = 0
   
   defc DEF__crt_initialize_bss        = 0
   
   defc DEF__crt_enable_commandline    = 1
   defc DEF__crt_enable_restart        = 0
   defc DEF__crt_enable_close          = 1
   
   defc DEF__crt_enable_rst            = 0
   defc DEF__crt_enable_nmi            = 0
   
   ; clib defaults
   
   defc DEF__clib_exit_stack_size      = 32
   defc DEF__clib_quickexit_stack_size = 32
   
   defc DEF__clib_malloc_heap_size     = 1024
   defc DEF__clib_stdio_heap_size      = 256
   
   defc DEF__clib_balloc_table_size    = 0
   
   defc DEF__clib_fopen_max            = 8
   defc DEF__clib_open_max             = 8

;; end crt defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
