
	module altair8800_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ;main() is always external to crt0 code
    EXTERN    asm_im1_handler

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 0xfd00
    defc	CRT_KEY_DEL = 127
    defc	__CPU_CLOCK = 2000000

    ; Default to some "sensible" values
    IF !CONSOLE_ROWS
        defc CONSOLE_ROWS = 25
    ENDIF
    IF !CONSOLE_ROWS
        defc CONSOLE_COLUMNS = 80
    ENDIF

    defc TAR__crt_enable_eidi = $02     ;enable on start
    defc TAR__crt_enable_rst = $8080
    EXTERN asm_im1_handler
    defc _z80_rst_38h = asm_im1_handler

    INCLUDE "crt/classic/crt_rules.inc"

IF      !DEFINED_CRT_ORG_CODE
        defc CRT_ORG_CODE = 0x0000
ENDIF

    org     CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000

  if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
  endif

    jp      program

    INCLUDE "crt/classic/crt_z80_rsts.inc"
ENDIF

program:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ld      hl,0
    push    hl	;argv
    push    hl	;argc
    call    _main
    pop     bc
    pop     bc
__Exit:
    rst     0

l_dcal: jp      (hl)            ;Used for function pointer calls


IFNDEF CRT_ORG_BSS
    defc    CRT_ORG_BSS = $C000   ; Ram variables are kept in RAM in high memory
ENDIF
    defc    __crt_org_bss = CRT_ORG_BSS

    ; If we were given a model then use it
    IFDEF CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE	"crt/classic/crt_section.inc"

