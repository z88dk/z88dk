
   IFNDEF CRT_INITIALIZE_BSS
      defc CRT_INITIALIZE_BSS = 1
   ENDIF

   IFDEF REGISTER_SP
      defc __register_sp = REGISTER_SP
   ELSE
      IFDEF STACKPTR
         defc __register_sp = STACKPTR
      ELSE
         IFDEF TAR__register_sp
            defc __register_sp = TAR__register_sp
         ELSE
            defc __register_sp = DEF__register_sp
         ENDIF
      ENDIF
   ENDIF

   IFNDEF CRT_ENABLE_STDIO
       defc CRT_ENABLE_STDIO = 1
   ENDIF

   IFDEF CLIB_EXIT_STACK_SIZE
      defc __clib_exit_stack_size = CLIB_EXIT_STACK_SIZE
   ELSE
      IFDEF TAR__clib_exit_stack_size
         defc __clib_exit_stack_size = TAR__clib_exit_stack_size
      ELSE
         defc __clib_exit_stack_size = DEF__clib_exit_stack_size
      ENDIF
   ENDIF

   ; For each bank call we save 2 words on the temporary stack
   ; this controls the depth of calls we can make safely
   IFNDEF CLIB_BANKING_STACK_SIZE
      PUBLIC CLIB_BANKING_STACK_SIZE
      IFDEF TAR__clib_banking_stack_size
         defc CLIB_BANKING_STACK_SIZE = TAR__clib_banking_stack_size
      ELSE
         defc CLIB_BANKING_STACK_SIZE = 100
      ENDIF
   ENDIF


   PUBLIC __CRT_KEY_DEL
   IFDEF CRT_KEY_DEL
     defc __CRT_KEY_DEL = CRT_KEY_DEL
   ELSE
     defc __CRT_KEY_DEL = 8
   ENDIF

   PUBLIC __CRT_KEY_CAPS_LOCK
   IFDEF CRT_KEY_CAPS_LOCK
     defc __CRT_KEY_CAPS_LOCK  = CRT_KEY_CAPS_LOCK
   ELSE
     defc __CRT_KEY_CAPS_LOCK = 6
   ENDIF

   PUBLIC __CPU_CLOCK
   IFNDEF __CPU_CLOCK
     defc __CPU_CLOCK = 3500000
   ENDIF

   PUBLIC __CLIB_CONIO_NATIVE_COLOUR
   IFDEF CLIB_CONIO_NATIVE_COLOUR
     defc __CLIB_CONIO_NATIVE_COLOUR = CLIB_CONIO_NATIVE_COLOUR
   ELSE
     defc __CLIB_CONIO_NATIVE_COLOUR = 0
   ENDIF

   ; When using the firmware printer we may need to disable the soft
   ; cursor created by fgets_cons()
   PUBLIC __CLIB_DISABLE_FGETS_CURSOR
   IFDEF CLIB_DISABLE_FGETS_CURSOR
     defc __CLIB_DISABLE_FGETS_CURSOR = CLIB_DISABLE_FGETS_CURSOR
   ELSE
     defc __CLIB_DISABLE_FGETS_CURSOR = 0
   ENDIF

   ; Delay when entering fgetc_cons()
   ; 50ms stops rogue repeats nicely, but may need tuning
   PUBLIC __CLIB_FGETC_CONS_DELAY
   IFDEF CLIB_FGETC_CONS_DELAY
     defc __CLIB_FGETC_CONS_DELAY = CLIB_FGETC_CONS_DELAY
   ELSE
     defc __CLIB_FGETC_CONS_DELAY = 50
   ENDIF

   ; Some ports (looking at you tiki100) need to have graphics routines stored out
   ; of paging harm. Normally we'd just use code_driver and keep the routines close
   ; the start of the address space. However for tiki100, we need them at the end,
   ; (in this case > 32768)
   IF DEFINED_CRT_ORG_GRAPHICS
       defc __crt_org_graphics = CRT_ORG_GRAPHICS
   ENDIF

   ; If 32 bit floats are defined, then we need to indicate to the library
   ; that they are in use (mainly for printf/scanf)
   PUBLIC CLIB_32BIT_FLOATS
   IF !DEFINED_CLIB_32BIT_FLOATS
       defc CLIB_32BIT_FLOATS = 0
   ENDIF
   PUBLIC CLIB_64BIT_FLOATS
   IF !DEFINED_CLIB_64BIT_FLOATS
       defc CLIB_64BIT_FLOATS = 0
   ENDIF

   ; Some targets startup in different screen modes depending on the environment:
   ; eg native = 40columns, CP/M = 80 columns. These should be explicitly defined
   ; if needed. So default to an unused value if not
   PUBLIC CLIB_DEFAULT_SCREEN_MODE
   IF !DEFINED_CLIB_DEFAULT_SCREEN_MODE
       defc CLIB_DEFAULT_SCREEN_MODE = 0
   ENDIF
      

   ; Custom memory map
   IF DEFINED_MMAP
       defc __MMAP = MMAP
   ELSE
       defc __MMAP = 0
   ENDIF
