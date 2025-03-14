; Memory map and section setup
;
; Contains the generic variables + features

;
; crt_model = 0    ; everything in RAM
; crt_model = 1    ; ROM model, data section copied
; crt_model = 2    ; ROM model, data section compressed with zx7
; crt_model = 3    ; ROM model, data section compressed with zx0

; Include the default memory map. You can override this

IF __MMAP == -1
    ; The user has supplied a memory map.
    INCLUDE  "./mmap.inc"
ELSE
    ; Include the standard memory map
    INCLUDE  "crt/classic/crt_section_standard.inc"
ENDIF


; The classic CRTs need some things setup, so do it

    SECTION code_crt_init
crt0_init:
    INCLUDE "crt/classic/crt_initialise_bss.inc"


IF CRT_ENABLE_STDIO = 1 && CLIB_FOPEN_MAX > 0
    ; Setup std* streams
    ld      hl,__sgoioblk+2
    ld      (hl),19 ;stdin
    ld      hl,__sgoioblk+12
    ld      (hl),21 ;stdout
    ld      hl,__sgoioblk+22
    ld      (hl),21 ;stderr
ENDIF
    INCLUDE "crt/classic/crt_copy_data_section.inc"


    SECTION code_crt_init_exit
    ret
    SECTION code_crt_exit
crt0_exit:
    ; Teardown code can go here
    SECTION code_crt_exit_exit
    ret


    SECTION bss_crt
IF CRT_ENABLE_STDIO = 1 && CLIB_FOPEN_MAX > 0
    PUBLIC  __sgoioblk
    PUBLIC  __sgoioblk_end
__sgoioblk:                     ;stdio control block
    defs    CLIB_FOPEN_MAX * 10
__sgoioblk_end:                 ;end of stdio control block
ENDIF

IF !DEFINED_basegraphics
    PUBLIC  base_graphics
base_graphics:
    defw    0                   ;Address of graphics map
ENDIF

IF __clib_malloc_heap_size > 0
    PUBLIC  _heap
_heap:
    defw    0,0                 ;populated by crt_heap_init.inc
__autoheap:
    defs    __clib_malloc_heap_size

ELIF DEFINED_CRT_HEAP_AMALLOC ||  __crt_stack_size > 0
    PUBLIC  _heap
_heap:
    defw 0
    defw 0
ENDIF

IF CLIB_BALLOC_TABLE_SIZE > 0
    ; create balloc table
    SECTION data_alloc_balloc
    PUBLIC  __balloc_array
__balloc_array:
    defw __balloc_table

    SECTION bss_alloc_balloc
    PUBLIC  __balloc_table
__balloc_table:
    defs CLIB_BALLOC_TABLE_SIZE * 2
ENDIF

IF __CPU_INTEL__ || __CPU_GBZ80__
    PUBLIC  saved_hl            ;Temporary store used by compiler for Intel & GB
saved_hl:
    defw    0                   ; Temp store for hl
ENDIF
