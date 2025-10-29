
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
   ;; rom model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0
   defc TAR__crt_org_data              = 0xC000
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 3

   defc TAR__register_sp               = __BIOS_SP
   defc TAR__crt_stack_size            = 256

   defc TAR__crt_initialize_bss        = 1

   defc TAR__crt_include_preamble      = 1

   defc TAR__crt_org_vector_table      = 0xFFE0
   defc TAR__crt_io_vector_base        = 0x00

   defc TAR__crt_interrupt_mode        = 1
   defc TAR__crt_interrupt_mode_exit   = -1

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 1
   defc TAR__crt_enable_close          = 1

   defc TAR__crt_enable_eidi           = 0x13
   defc TAR__crt_on_exit               = 0x10001

   defc TAR__crt_enable_rst            = 0x0080
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
   ;; application with yabios driver model ;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0x0100
   defc TAR__crt_org_data              = 0
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 0

   defc TAR__register_sp               = -__BANK_SP
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

   defc TAR__crt_enable_eidi           = 0x02
   defc TAR__crt_on_exit               = _exit_far

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

IF __CRTCFG = 2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; cp/m ram model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0x100
   defc TAR__crt_org_data              = 0
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 0
   
   defc TAR__register_sp               = -0x0006
   defc TAR__crt_stack_size            = 256
      
   defc TAR__crt_initialize_bss        = 1
   
   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_interrupt_mode        = -1
   defc TAR__crt_interrupt_mode_exit   = -1

   defc TAR__crt_enable_commandline    = 3
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 0
   defc TAR__crt_enable_close          = 1
   
   defc TAR__crt_enable_eidi           = 0
   defc TAR__crt_on_exit               = 0x0000
   
   defc TAR__crt_enable_rst            = 0
   defc TAR__crt_enable_nmi            = 0
   
   ; clib defaults
   
   defc TAR__clib_exit_stack_size      = 0
   defc TAR__clib_quickexit_stack_size = 0
   
   defc TAR__clib_malloc_heap_size     = -1
   defc TAR__clib_stdio_heap_size      = 256
   
   defc TAR__clib_balloc_table_size    = 0
   
   defc TAR__clib_fopen_max            = 0
   defc TAR__clib_open_max             = 0

ENDIF

IF __CRTCFG = 3

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; no drivers model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0x0100
   defc TAR__crt_org_data              = 0
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 0

   defc TAR__register_sp               = -__BANK_SP
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

   defc TAR__crt_enable_eidi           = 0x11
   defc TAR__crt_on_exit               = _exit_far

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
