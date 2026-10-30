;
;	CRT0 for the Sharp MZ-2500
;
;    $Id: mz2500_crt0.asm $
;

    MODULE mz2500_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main
    EXTERN    _mz2500_printf

    PUBLIC    __Exit 
    PUBLIC    l_dcal


;--------
; ORG at 0x8000, to leave space for video memory
;--------
IF !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 32768
ENDIF
    defc    TAR__register_sp = -1

    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 24

    defc	TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__crt_on_exit = $10001       ;loop forever
    defc	__CPU_CLOCK = 6000000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE
    EXTERN  __size

IF CRT_ORG_CODE = 0x0000
    jp      start
    INCLUDE "crt/classic/crt_z80_rsts.inc"
ENDIF


;--------
; Execution starts here
;--------
start:
    DI

; -pragma-define:CRT_MZ2500_IPL_DISABLED=1: the program has its own memory map (set up by the loader, e.g. the BOOTSTRAP stub below) and its own screen, so
; start-up neither resets the windows to the IPL's map (RAM page 0 in window 0) nor calls the IPL's text clear, which needs that map
IF !DEFINED_CRT_MZ2500_IPL_DISABLED
    XOR     A
    OUT     (0B4h), A
    OUT     (0B5h), A

    xor     a
    rst     18h
    defb    70h     ; clear text
ENDIF


    INCLUDE	"crt/classic/crt_init_sp.inc"
	
;	im 2
;	ei


    call    crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

; INIT math identify platform

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

    INCLUDE	"crt/classic/crt_section.inc"

; A program linked at $0000 needs appmake's first stage in the page at $8000
IF DEFINED_CRT_MZ2500_IPL_DISABLED
    INCLUDE "target/mz2500/classic/bootstrap.asm"
ENDIF
