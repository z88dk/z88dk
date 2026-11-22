;
;	CRT0 for the Sharp MZ-800: a boot disc.  The IPL reads the program to $1200, moves it to the load address and jumps to it with the IPL ROM still at $0000.
;
;    $Id: mz800_crt0.asm $
;

    MODULE mz800_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN    _main

    PUBLIC    __Exit
    PUBLIC    l_dcal

; Load address: the IPL moves the program here from $1200.  $2000 because the video RAM ($8000-$9FFF) and the character generator ($1000-$1FFF) are paged in while a library
; routine draws, so code and data must not be there (the drawing code is in section code_driver, linked first).  Programs may not extend above $CEE8 (appmake checks).
IF !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $2000
ENDIF
; The stack goes to the top of RAM: the IPL's is at $10F0, which the character generator covers while the video RAM is paged in
    defc    TAR__register_sp = 0

; Display mode written to $CE at start-up (default $00: 320x200, four pens).  -pragma-define:CRT_MZ800_DMD=n
IF !DEFINED_CRT_MZ800_DMD
    defc    CRT_MZ800_DMD = $00
ENDIF
    PUBLIC  __MZ800_DMD
    defc    __MZ800_DMD = CRT_MZ800_DMD

; The SN76489 (sound/sn76489: psg_play, PSGlib) is at port $F2
    PUBLIC  __IO_SN76489_PORT
    defc    __IO_SN76489_PORT = $f2

; The delete key's code for fgets_cons (the keyboard table gives 12 for DEL and BREAK)
    defc    CRT_KEY_DEL = 12

    defc    TAR__no_ansifont = 1
    defc    TAR__fputc_cons_generic = 1
    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 25
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__crt_on_exit = $10001       ;loop forever
    defc    __CPU_CLOCK = 3546895
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    DI
IF !DEFINED_CRT_MZ800_KEEP_ROM
    out     ($e0),a         ; RAM at $0000-$0FFF
    out     ($e1),a         ; RAM at $E000-$FFFF
ENDIF
    ld      a,CRT_MZ800_DMD
    out     ($ce),a

    INCLUDE "crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main

__Exit:
    call    crt0_exit

    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"

crt0_exit_exit:
    ret

l_dcal:
    jp      (hl)

IF !DEFINED_ansicolumns
    defc DEFINED_ansicolumns = 1
    defc ansicolumns = 40
ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.inc"

IF DEFINED_CRT_ORG_BSS
    defc    __crt_org_bss = CRT_ORG_BSS
ENDIF

    INCLUDE "crt/classic/crt_section.inc"
