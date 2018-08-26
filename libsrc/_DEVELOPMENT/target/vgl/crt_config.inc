
;;;;;;;;;;;;;;;;;;;;;;
;; crt target defaults ;;
;;;;;;;;;;;;;;;;;;;;;;

IF __CRTCFG = -1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; CRTCFG=-1: user supplied crt defaults (crt_cfg.inc) ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   INCLUDE "crt_cfg.inc"

ENDIF

IF __CRTCFG = 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; CRTCFG=0: RAM payload defaults ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0xd000       ; Should be in RAM range
   defc TAR__crt_org_data              = -1
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 0
   
   defc TAR__register_sp               = 0
   defc TAR__crt_stack_size            = 512
      
   defc TAR__crt_initialize_bss        = 0
   
   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0
   defc TAR__crt_interrupt_mode        = -1
   defc TAR__crt_interrupt_mode_exit   = -1

   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 0
   defc TAR__crt_enable_close          = 1
   
   defc TAR__crt_enable_eidi           = 0x13
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

IF __CRTCFG = 1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; CRTCFG=1: ROM cartridge defaults ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defc TAR__crt_org_code              = 0x8000
   defc TAR__crt_org_data              = 0xc400    ; MODEL4000: c000 is too low, c200?, c400 works
   defc TAR__crt_org_bss               = -1

   defc TAR__crt_model                 = 1
   
   defc TAR__register_sp               = 0xdff0    ; MODEL4000: ld sp, 0dff0h; z88 default is 0
   defc TAR__crt_stack_size            = 512
      
   defc TAR__crt_initialize_bss        = 1
   
   defc TAR__crt_include_preamble      = 0

   defc TAR__crt_org_vector_table      = 0
   defc TAR__crt_interrupt_mode        = -1
   defc TAR__crt_interrupt_mode_exit   = -1
   
   defc TAR__crt_enable_commandline    = 0
   defc TAR__crt_enable_commandline_ex = 0
   defc TAR__crt_enable_restart        = 0
   defc TAR__crt_enable_close          = 1

   defc TAR__crt_enable_eidi           = 0x13
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

;; end crt target defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
