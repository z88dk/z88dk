
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT DEFAULTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; crt configuration

   defc __crt_org_code = 0
   defc __crt_org_data = 0
   defc __crt_org_bss  = 0

   defc __crt_model    = 2  ; compress rom model
   
   defc __register_sp  = 0
   
   defc __crt_enable_commandline = 1
   defc __crt_enable_restart     = 1
   
   ; clib defaults
   
   defc __clib_exit_stack_size      = 32
   defc __clib_quickexit_stack_size = 32
   
   defc __clib_malloc_heap_size     = 1024
   defc __clib_stdio_heap_size      = 256
   
   defc __clib_balloc_table_size    = 0
   
   defc __clib_fopen_max            = 8
   defc __clib_open_max             = 8

;; END CRT DEFAULTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
