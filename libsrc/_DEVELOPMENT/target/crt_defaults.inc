
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; crt configuration

   defc DEF__crt_org_code              = 0       ;; org of code section
   defc DEF__crt_org_data              = 0       ;; org of data section (0 or -1 means follow code, -1 means generate separate binary)
   defc DEF__crt_org_bss               = 0       ;; org of bss section (0 or -1 means follow data, -1 means generate separate binary)

   defc DEF__crt_model                 = 0       ;; 0 = ram model, 1 = rom model, 2 = compressed rom model
   defc DEF__crt_enforce_snames        = 3       ;; bit 0 set = enforce BSS name, bit 1 set = enforce DATA name
   
   defc DEF__register_sp               = 0       ;; initial value of sp (-1 = do not modify (some targets may redefine meaning), 0 = top of memory)
   defc DEF__crt_stack_size            = 512     ;; minimum size reserved for stack when automatically allocating memory for the malloc heap
   
   defc DEF__crt_initialize_bss        = 0       ;; generate code to initialize bss section at startup
   
   defc DEF__crt_include_preamble      = 0       ;; if non-zero, user supplies code in file "crt_preamble.asm" that is inserted at the start of the binary

   defc DEF__crt_org_vector_table      = 0       ;; if negative and Z88DK supplies page zero code, creates a section "code_vector" aligned to a page boundary to hold int vectors
   defc DEF__crt_interrupt_mode        = -1      ;; if 0-2 crt inserts appropriate im x instruction

   defc DEF__crt_enable_commandline    = 2       ;; generate argc and argv from command line (targets without command line will get argc=1, argv[0]="", argv[1]=NULL)
   defc DEF__crt_enable_restart        = 0       ;; if non-zero, restart the program on exit (correct initialization of static variables with rom models only)
   defc DEF__crt_enable_close          = 1       ;; if non-zero, close files on exit
   
   defc DEF__crt_enable_eidi           = 0       ;; bit flags: 0x01 = di on start, 0x02 = ei on start, 0x10 = di on exit, 0x20 = ei on exit
   defc DEF__crt_on_exit               = 0x10001 ;; halt on exit (see documentation for other exit behaviours)
   
   defc DEF__crt_enable_rst            = 0       ;; if non-zero and in some crts with code org = 0, set bits indicate which rst locations are implemented with user code
   defc DEF__crt_enable_nmi            = 0       ;; if non-zero and in some crts with code org = 0, a jump to user code to service the nmi is inserted
   defc DEF__crt_enable_trap           = 0       ;; if non-zero and in some crts with code org = 0 and Z180 target, a jump to user code to service traps is inserted
   
   ; clib defaults
   
   defc DEF__clib_exit_stack_size      = 32      ;; max number of functions that can be registered with atexit()
   defc DEF__clib_quickexit_stack_size = 32      ;; max number of functions that can be registered with at_quickexit()
   
   defc DEF__clib_malloc_heap_size     = -1      ;; size of malloc heap (0 = do not create a heap, -1 = automatically place heap between end of bss section and bottom of stack)
   defc DEF__clib_stdio_heap_size      = 256     ;; size of stdio heap (0 = do not allocate bytes for opening of files)
   
   defc DEF__clib_balloc_table_size    = 0       ;; number of queues created for balloc block memory allocator
   
   defc DEF__clib_fopen_max            = 8       ;; max number of FILE*
   defc DEF__clib_open_max             = 8       ;; max number of open files

;; end crt defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
