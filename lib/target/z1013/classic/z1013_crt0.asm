;       CRT0 for the Robotron Z1013
;
;       Stefano Bodrato August 2016
;
;
; - - - - - - -
;
;       $Id: z1013_crt0.asm,v 1.2 2016-10-10 07:09:14 stefano Exp $
;
; - - - - - - -


    MODULE  Z1013_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main           ;main() is always external to crt0 code
    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


    defc    CONSOLE_ROWS = 32
    defc    CONSOLE_COLUMNS = 32

    defc    KRT_PORT = 8
    defc    KRT_ENABLE = 0x08
    defc    KRT_DISABLE = 0x09
    defc    KRT_ROWS = 32
    defc    KRT_COLUMNS = 32
    defc    KRT_ADDRESS = $ec00
    defc    KRT_BANK_SELECTOR = 0
    defc    KRT_CLS_FILL = 0xff

    PUBLIC KRT_ENABLE
    PUBLIC KRT_DISABLE
    PUBLIC KRT_PORT
    PUBLIC KRT_ROWS
    PUBLIC KRT_COLUMNS
    PUBLIC KRT_ADDRESS
    PUBLIC KRT_BANK_SELECTOR
    PUBLIC KRT_CLS_FILL

IF CLIB_DISABLE_MODE1 = 1
    PUBLIC  __krt_vpeek
    PUBLIC  __krt_printc
    PUBLIC  __krt_plot
    PUBLIC  __krt_res
    PUBLIC  __krt_xor
    PUBLIC  __krt_pointxy
    PUBLIC  __krt_pixeladdress
    PUBLIC  __krt_scrollup
    defc    __krt_vpeek = vpeek_noop
    defc    __krt_printc = noop
    defc    __krt_plot = noop
    defc    __krt_res = noop
    defc    __krt_xor = noop
    defc    __krt_pointxy = noop
    defc    __krt_pixeladdress = noop
    defc    __krt_scrollup = noop
    PUBLIC  __CLIB_DISABLE_MODE1
    defc    __CLIB_DISABLE_MODE1 = 1
ELSE
    PUBLIC  __CLIB_DISABLE_MODE1
    defc    __CLIB_DISABLE_MODE1 = 0
ENDIF


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 100h
ENDIF

    defc    TAR__no_ansifont = 1
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__register_sp = 0xdfff
    defc    TAR__clib_exit_stack_size = 32
    defc    __CPU_CLOCK = 1000000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ld      (__restore_sp_onexit+1),sp	;Save entry stack

    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    call    _main   ;Call user program

cleanup:
	push    hl
    call    crt0_exit
    pop     bc
__restore_sp_onexit:
    ld      sp,0    ;Restore stack to entry value
    jp      $F000

l_dcal:
    jp      (hl)    ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"
    SECTION code_crt_init
    ld      hl,$EC00
    ld      (base_graphics),hl

