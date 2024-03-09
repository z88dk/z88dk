
    module radio86_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN  _main           ;main() is always external to crt0 code
    EXTERN  asm_im1_handler

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = -1
    defc    TAR__fputc_cons_generic = 0
    defc    TAR__crt_on_exit = $f800        ;Jump here when finished
    defc    CLIB_DISABLE_FGETS_CURSOR = 1
    defc    CRT_KEY_DEL = 127
    defc    __CPU_CLOCK = 1777000

    ; RAM trimming
    defc    DEFINED_CLIB_FOPEN_MAX = 1
    defc    CLIB_FOPEN_MAX = 3


    defc    CRT_ORG_CODE = 0x0000

    defc    TAR__crt_enable_rst = $0000

    INCLUDE "crt/classic/crt_rules.inc"
    defc    CONSOLE_COLUMNS = 64
    defc    CONSOLE_ROWS = 25

    PUBLIC  GRAPHICS_CHAR_SET
    PUBLIC  GRAPHICS_CHAR_UNSET
    defc    GRAPHICS_CHAR_SET = 127
    defc    GRAPHICS_CHAR_UNSET = 32


    org	    CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000
  if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
  endif

    jp      program
    INCLUDE	"crt/classic/crt_z80_rsts.inc"
ENDIF

program:
    INCLUDE "crt/classic/crt_init_sp.inc"
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
    ei
    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"
    ld      hl,0
    push    hl	;argv
    push    hl	;argc
    call    _main
cleanup:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal: jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE	"crt/classic/crt_section.inc"
