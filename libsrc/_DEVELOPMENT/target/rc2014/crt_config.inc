
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
   ;;;; rom with acia driver model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0
   defc TAR__crt_org_data              = 0x8000
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 3

   defc TAR__register_sp               = 0
   defc TAR__crt_stack_size            = 256

   defc TAR__crt_initialize_bss        = 1

   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0
   defc TAR__crt_interrupt_mode        = 1
   defc TAR__crt_interrupt_mode_exit   = -1

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 1
   defc TAR__crt_enable_close          = 1

   defc TAR__crt_enable_eidi           = 0x12
   defc TAR__crt_on_exit               = 0x10001

   defc TAR__crt_enable_rst            = 0x80
   defc TAR__crt_enable_nmi            = 0

   ; clib defaults

   defc TAR__clib_exit_stack_size      = 0
   defc TAR__clib_quickexit_stack_size = 0

   defc TAR__clib_malloc_heap_size     = -1
   defc TAR__clib_stdio_heap_size      = 128

   defc TAR__clib_balloc_table_size    = 0

   defc TAR__clib_fopen_max            = 0
   defc TAR__clib_open_max             = 0

ENDIF

IF __CRTCFG = 1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;; rom with 8085 acia driver model ;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0
   defc TAR__crt_org_data              = 0x8000
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 1

   defc TAR__register_sp               = 0
   defc TAR__crt_stack_size            = 256

   defc TAR__crt_initialize_bss        = 1

   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 1
   defc TAR__crt_enable_close          = 1

   defc TAR__crt_enable_eidi           = 0x12
   defc TAR__crt_on_exit               = 0x10001

   defc TAR__crt_enable_rst            = 0
   defc TAR__crt_enable_rst40h         = 0

   defc TAR__crt_enable_trap           = 0
   defc TAR__crt_enable_int55          = 0
   defc TAR__crt_enable_int65          = 1
   defc TAR__crt_enable_int75          = 0

   ; clib defaults

   defc TAR__clib_exit_stack_size      = 0
   defc TAR__clib_quickexit_stack_size = 0

   defc TAR__clib_malloc_heap_size     = -1
   defc TAR__clib_stdio_heap_size      = 128

   defc TAR__clib_balloc_table_size    = 0

   defc TAR__clib_fopen_max            = 0
   defc TAR__clib_open_max             = 0

ENDIF

IF __CRTCFG = 2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;; rom with sio driver model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0
   defc TAR__crt_org_data              = 0x8000
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 3

   defc TAR__register_sp               = 0xFFF0
   defc TAR__crt_stack_size            = 256

   defc TAR__crt_initialize_bss        = 1

   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0xFFF0
   defc TAR__crt_interrupt_mode        = 2
   defc TAR__crt_interrupt_mode_exit   = -1

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 1
   defc TAR__crt_enable_close          = 1

   defc TAR__crt_enable_eidi           = 0x12
   defc TAR__crt_on_exit               = 0x10001

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
   ;;;; application with romwbw hbios driver model ;;;;;;;;;;;;
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

IF __CRTCFG = 4

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;; application with ms basic driver model ;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0x9000
   defc TAR__crt_org_data              = 0
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 0

   defc TAR__register_sp               = 0
   defc TAR__crt_stack_size            = 256

   defc TAR__crt_initialize_bss        = 1

   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0
   defc TAR__crt_interrupt_mode        = -1
   defc TAR__crt_interrupt_mode_exit   = 1

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 0
   defc TAR__crt_enable_close          = 1

   defc TAR__crt_enable_eidi           = 0x20
   defc TAR__crt_on_exit               = 0x10002

   defc TAR__crt_enable_rst            = 0
   defc TAR__crt_enable_nmi            = 0

   ; clib defaults

   defc TAR__clib_exit_stack_size      = 0
   defc TAR__clib_quickexit_stack_size = 0

   defc TAR__clib_malloc_heap_size     = -1
   defc TAR__clib_stdio_heap_size      = 128

   defc TAR__clib_balloc_table_size    = 0

   defc TAR__clib_fopen_max            = 0
   defc TAR__clib_open_max             = 0

ENDIF


IF __CRTCFG = 5

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;; application with 8085 ms basic driver model ;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0x9000
   defc TAR__crt_org_data              = 0
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 0

   defc TAR__register_sp               = 0
   defc TAR__crt_stack_size            = 256

   defc TAR__crt_initialize_bss        = 1

   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 0
   defc TAR__crt_enable_close          = 1

   defc TAR__crt_enable_eidi           = 0x20
   defc TAR__crt_on_exit               = 0x10002

   defc TAR__crt_enable_rst            = 0
   defc TAR__crt_enable_rst40h         = 0

   defc TAR__crt_enable_trap           = 0
   defc TAR__crt_enable_int55          = 0
   defc TAR__crt_enable_int65          = 0
   defc TAR__crt_enable_int75          = 0

   ; clib defaults

   defc TAR__clib_exit_stack_size      = 0
   defc TAR__clib_quickexit_stack_size = 0

   defc TAR__clib_malloc_heap_size     = -1
   defc TAR__clib_stdio_heap_size      = 128

   defc TAR__clib_balloc_table_size    = 0

   defc TAR__clib_fopen_max            = 0
   defc TAR__clib_open_max             = 0

ENDIF

IF __CRTCFG = 6

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;; application with cp/m ram model ;;;;;;;;;;;;;;;;;;;;;;;
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

IF __CRTCFG = 7

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;; rom with no drivers model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0x9000
   defc TAR__crt_org_data              = 0
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 0

   defc TAR__register_sp               = 0
   defc TAR__crt_stack_size            = 256

   defc TAR__crt_initialize_bss        = 1

   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0
   defc TAR__crt_interrupt_mode        = -1
   defc TAR__crt_interrupt_mode_exit   = -1

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 0
   defc TAR__crt_enable_close          = 1

   defc TAR__crt_enable_eidi           = 0x11
   defc TAR__crt_on_exit               = 0x10001

   defc TAR__crt_enable_rst            = 0
   defc TAR__crt_enable_nmi            = 0

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
