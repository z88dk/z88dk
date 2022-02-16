;       CRT0 for the Robotron Z9001, KC85/1, KC87
;
;       Stefano Bodrato August 2016
;
;
; - - - - - - -
;
;       $Id: z9001_crt0.asm,v 1.3 2016-10-10 07:09:14 stefano Exp $
;
; - - - - - - -


    MODULE  z9001_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 1000h
ENDIF


    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 24


    defc    KRT_PORT = 0xb8
    defc    KRT_ENABLE = 0x08
    defc    KRT_DISABLE = 0x00
    defc    KRT_ROWS = 24
    defc    KRT_COLUMNS = 40
    defc    KRT_ADDRESS = $ec00
    defc    KRT_BANK_SELECTOR = 0x08
    defc    KRT_CLS_FILL = 0x00

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

    defc    TAR__no_ansifont = 1
    defc    TAR__register_sp = CRT_ORG_CODE - 2
    defc    TAR__clib_exit_stack_size = 32
    defc    __CPU_CLOCK = 2457600
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ld      (__restore_sp_onexit+1),sp

    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp


IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    ; Copy variables from "text graphics mem" to "video graphics mem page 0"
    ld      hl,$efc0
    ld      b,64
copy_loop:
    ld      a,0
    out     (KRT_PORT),a
    ld      c,(hl)
    ld      a,KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    ld      (hl),c
    inc     hl
    djnz    copy_loop

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

