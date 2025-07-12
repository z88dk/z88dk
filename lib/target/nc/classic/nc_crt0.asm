; Startup for Amstrad NC100/NC200



    MODULE  nc100_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN    _main

    PUBLIC    __Exit
    PUBLIC    l_dcal

    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc    CRT_KEY_DEL = 12
    defc	__CPU_CLOCK = 4606000
    INCLUDE "crt/classic/crt_rules.inc"


IF (startup=2)
    ;; Loadable from BASIC
    defc    CRT_ORG_CODE  = $8C00
    org     CRT_ORG_CODE
    jp      start
ELIF startup  = 3
    ;; Bootable floppy

    ;; We're on an nc200 for this mode, so export the VRAM settings
    defc NC_VRAM = 0xc000 + $2000
    defc NC_VRAM_YSIZE = 128
    defc NC_VRAM_SEGMENT = 3

    defc CONSOLE_COLUMNS = 60
    defc CONSOLE_ROWS = 16

    PUBLIC  CONSOLE_ROWS
    PUBLIC  CONSOLE_COLUMNS

    PUBLIC  NC_VRAM
    PUBLIC  NC_VRAM_YSIZE
    PUBLIC  NC_VRAM_SEGMENT

    defc    CRT_ORG_CODE = 0x4000
    org     CRT_ORG_CODE

    ; Turn off disk motor   
    ld      c, 0x30 ; r_finish
    call    0xba5e ;diskservice

    ; Re-enable all interrupts (we enter with keyboard IRQ disabled)
    ld      a, 0x7f
    out     (0x60), a
ELSE
    ;; PCMCIA Card
    defc    CRT_ORG_CODE  = $C000
    org     CRT_ORG_CODE
    jp      start

IF DEFINED_CRT_HEAP_AMALLOC || CLIB_MALLOC_HEAP_SIZE > 0 || CRT_STACK_SIZE > 0
;EXTERN ASMTAIL
PUBLIC _heap
; We have 509 bytes we can use here..
_heap:
    defw    0
    defw    0
_mblock:
    defs    505		; Few bytes for malloc() stuff
ELSE
	defs    509		; Waste 509 bytes of space
ENDIF

;--------
; Card header
;--------
    defm    "NC100PRG"	
    defb    0,0,0,0,0,0,0,0
    jp      start			;c210
    defm    "z88dk NC100"
    defb    0,0

ENDIF


start:
    ld      (__restore_sp_onexit+1),sp   ;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
    INCLUDE "crt/classic/crt_init_heap.inc"
IF DEFINED_CRT_HEAP_AMALLOC || CLIB_MALLOC_HEAP_SIZE > 0 || CRT_STACK_SIZE > 0
  IF startup == 1
    ; Add in an extra 505 bytes to the heap
    ld      hl,_mblock
    push    hl	; data block
    ld      hl,505
    push    hl	; area size
    EXTERN  sbrk_callee
    call    sbrk_callee
  ENDIF
ENDIF

    INCLUDE "crt/classic/crt_init_eidi.inc"
    call    _main		;Call user code

__Exit:
    push    hl
    call    crt0_exit
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:	jp	(hl)

    INCLUDE "crt/classic/crt_runtime_selection.inc"
IF startup == 1
    UNDEFINE DEFINED_CRT_HEAP_AMALLOC
ENDIF
    INCLUDE "crt/classic/crt_section.inc"

IF startup = 3
    INCLUDE "target/nc/classic/nc200_boot.inc"
ENDIF
