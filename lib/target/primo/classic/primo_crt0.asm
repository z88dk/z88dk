;
;	Startup for Primo A-XX/B-XX models
;
;

	module primo_crt0


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
    EXTERN	__primo_screen_base

    PUBLIC  __Exit         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


    ; We use the generic driver by default
    defc    TAR__fputc_cons_generic = 0

    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__register_sp = -1		; SP left untouched
    defc	CRT_KEY_DEL = 12
    defc	__CPU_CLOCK = 2500000
    ; These CONSOLE_* are used by generic console code
    defc    CONSOLE_COLUMNS = 32
    defc    CONSOLE_ROWS = 24
    INCLUDE "crt/classic/crt_rules.inc"

IF !DEFINED_CRT_ORG_CODE
    defc CRT_ORG_CODE = 0x4400 ; BASIC area starts at $43EA, 0000-3FFF is ROM, 4000-43E9 system variables/buffers etc...
ENDIF
    org     CRT_ORG_CODE

program:
    ld      (__sp),sp
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    ; Entry stack is is ~ $e800 for 64k
    ;		      $a800 for 48k?
    ;		      $6800 for 32k
    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ld      hl,($0013)
    ld      (__primo_screen_base),hl
    ld      hl,0
    push    hl	;argv
    push    hl	;argc
    call    _main
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    ld      sp,(__sp)
    ret

l_dcal: jp      (hl)            ;Used for function pointer calls

__sp:	defw    0


    INCLUDE "target/primo/def/maths_mbf.def"

    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE	"crt/classic/crt_section.inc"
