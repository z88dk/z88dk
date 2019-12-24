
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt target defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __CRTCFG = -1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; user supplied crt defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   INCLUDE "crt_cfg.inc"

ENDIF

IF __CRTCFG = 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; hbios ram model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0x0100
   defc TAR__crt_org_data              = 0
   defc TAR__crt_org_bss               = 0x8000

   defc TAR__crt_model                 = 0
   
   defc TAR__register_sp               = 0xF000
   defc TAR__crt_stack_size            = 256
      
   defc TAR__crt_initialize_bss        = 1

   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0
   defc TAR__crt_io_vector_base        = -1

   defc TAR__crt_interrupt_mode        = -1
   defc TAR__crt_interrupt_mode_exit   = -1

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 0
   defc TAR__crt_enable_close          = 1
   
   defc TAR__crt_enable_eidi           = 0
   defc TAR__crt_on_exit               = 0x0000
   
   defc TAR__crt_enable_rst            = 0
   defc TAR__crt_enable_nmi            = 0
   defc TAR__crt_enable_trap           = 0
   
   ; clib defaults
   
   defc TAR__clib_exit_stack_size      = 0
   defc TAR__clib_quickexit_stack_size = 0
   
   defc TAR__clib_malloc_heap_size     = -1
   defc TAR__clib_stdio_heap_size      = 256
   
   defc TAR__clib_balloc_table_size    = 0
   
   defc TAR__clib_fopen_max            = 0
   defc TAR__clib_open_max             = 0

ENDIF

IF __CRTCFG = 1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;; rom with no drivers model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0x0100
   defc TAR__crt_org_data              = 0
   defc TAR__crt_org_bss               = 0x8000

   defc TAR__crt_model                 = 0

   defc TAR__register_sp               = -1
   defc TAR__crt_stack_size            = 256

   defc TAR__crt_initialize_bss        = 1

   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0
   defc TAR__crt_io_vector_base        = -1

   defc TAR__crt_interrupt_mode        = -1
   defc TAR__crt_interrupt_mode_exit   = -1

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 0
   defc TAR__crt_enable_close          = 1

   defc TAR__crt_enable_eidi           = 0
   defc TAR__crt_on_exit               = 0x0000

   defc TAR__crt_enable_rst            = 0
   defc TAR__crt_enable_nmi            = 0
   defc TAR__crt_enable_trap           = 0

   ; clib defaults

   defc TAR__clib_exit_stack_size      = 0
   defc TAR__clib_quickexit_stack_size = 0

   defc TAR__clib_malloc_heap_size     = -1
   defc TAR__clib_stdio_heap_size      = 128

   defc TAR__clib_balloc_table_size    = 0

   defc TAR__clib_fopen_max            = 0
   defc TAR__clib_open_max             = 0

ENDIF

;; end crt target defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
