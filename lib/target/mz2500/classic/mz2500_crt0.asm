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

;--------
; The RAM pages the IPL loads besides the program (the bank list in the directory entry, which appmake builds from <name>_BANK_<n>.bin).  A section BANK_n is
; RAM page n, linked at (n << 16) | CRT_ORG_BANK_n; the program puts its code, read-only data and data in CODE_n, RODATA_n and DATA_n (-pragma codeseg CODE_n,
; zcc --codeseg CODE_n, or SECTION in assembler) and maps the page where it is linked itself.  A bank of more than 8 KB goes on into the next page(s) of the
; file.  CRT_ORG_BANK_n is $4000 (windows 2-3) unless defined.  Pages below 8 cannot be used (the IPL does not run a program with them in its list).
;--------
IF DEFINED_CRT_MZ2500_IPL_DISABLED
    ; RAM page 12 is at $8000 and always mapped: the BOOTSTRAP stub (bootstrap.asm) is put by appmake in the first 32 bytes
    IFNDEF CRT_ORG_BANK_12
        defc CRT_ORG_BANK_12 = 0x8000
    ENDIF
    SECTION BANK_12
    org 0xc0000 + CRT_ORG_BANK_12
    defs 32
    SECTION CODE_12
    SECTION RODATA_12
    SECTION DATA_12
    SECTION BANK_12_END
ENDIF

    IFNDEF CRT_ORG_BANK_18
        defc CRT_ORG_BANK_18 = 0x4000
    ENDIF
    SECTION BANK_18
    org 0x120000 + CRT_ORG_BANK_18
    SECTION CODE_18
    SECTION RODATA_18
    SECTION DATA_18
    SECTION BANK_18_END

    IFNDEF CRT_ORG_BANK_19
        defc CRT_ORG_BANK_19 = 0x4000
    ENDIF
    SECTION BANK_19
    org 0x130000 + CRT_ORG_BANK_19
    SECTION CODE_19
    SECTION RODATA_19
    SECTION DATA_19
    SECTION BANK_19_END

    IFNDEF CRT_ORG_BANK_20
        defc CRT_ORG_BANK_20 = 0x4000
    ENDIF
    SECTION BANK_20
    org 0x140000 + CRT_ORG_BANK_20
    SECTION CODE_20
    SECTION RODATA_20
    SECTION DATA_20
    SECTION BANK_20_END

    IFNDEF CRT_ORG_BANK_21
        defc CRT_ORG_BANK_21 = 0x4000
    ENDIF
    SECTION BANK_21
    org 0x150000 + CRT_ORG_BANK_21
    SECTION CODE_21
    SECTION RODATA_21
    SECTION DATA_21
    SECTION BANK_21_END

    IFNDEF CRT_ORG_BANK_22
        defc CRT_ORG_BANK_22 = 0x4000
    ENDIF
    SECTION BANK_22
    org 0x160000 + CRT_ORG_BANK_22
    SECTION CODE_22
    SECTION RODATA_22
    SECTION DATA_22
    SECTION BANK_22_END

    IFNDEF CRT_ORG_BANK_23
        defc CRT_ORG_BANK_23 = 0x4000
    ENDIF
    SECTION BANK_23
    org 0x170000 + CRT_ORG_BANK_23
    SECTION CODE_23
    SECTION RODATA_23
    SECTION DATA_23
    SECTION BANK_23_END

    IFNDEF CRT_ORG_BANK_24
        defc CRT_ORG_BANK_24 = 0x4000
    ENDIF
    SECTION BANK_24
    org 0x180000 + CRT_ORG_BANK_24
    SECTION CODE_24
    SECTION RODATA_24
    SECTION DATA_24
    SECTION BANK_24_END

    IFNDEF CRT_ORG_BANK_25
        defc CRT_ORG_BANK_25 = 0x4000
    ENDIF
    SECTION BANK_25
    org 0x190000 + CRT_ORG_BANK_25
    SECTION CODE_25
    SECTION RODATA_25
    SECTION DATA_25
    SECTION BANK_25_END

    IFNDEF CRT_ORG_BANK_26
        defc CRT_ORG_BANK_26 = 0x4000
    ENDIF
    SECTION BANK_26
    org 0x1a0000 + CRT_ORG_BANK_26
    SECTION CODE_26
    SECTION RODATA_26
    SECTION DATA_26
    SECTION BANK_26_END

    IFNDEF CRT_ORG_BANK_27
        defc CRT_ORG_BANK_27 = 0x4000
    ENDIF
    SECTION BANK_27
    org 0x1b0000 + CRT_ORG_BANK_27
    SECTION CODE_27
    SECTION RODATA_27
    SECTION DATA_27
    SECTION BANK_27_END

    IFNDEF CRT_ORG_BANK_28
        defc CRT_ORG_BANK_28 = 0x4000
    ENDIF
    SECTION BANK_28
    org 0x1c0000 + CRT_ORG_BANK_28
    SECTION CODE_28
    SECTION RODATA_28
    SECTION DATA_28
    SECTION BANK_28_END

    IFNDEF CRT_ORG_BANK_29
        defc CRT_ORG_BANK_29 = 0x4000
    ENDIF
    SECTION BANK_29
    org 0x1d0000 + CRT_ORG_BANK_29
    SECTION CODE_29
    SECTION RODATA_29
    SECTION DATA_29
    SECTION BANK_29_END

    IFNDEF CRT_ORG_BANK_30
        defc CRT_ORG_BANK_30 = 0x4000
    ENDIF
    SECTION BANK_30
    org 0x1e0000 + CRT_ORG_BANK_30
    SECTION CODE_30
    SECTION RODATA_30
    SECTION DATA_30
    SECTION BANK_30_END

    IFNDEF CRT_ORG_BANK_31
        defc CRT_ORG_BANK_31 = 0x4000
    ENDIF
    SECTION BANK_31
    org 0x1f0000 + CRT_ORG_BANK_31
    SECTION CODE_31
    SECTION RODATA_31
    SECTION DATA_31
    SECTION BANK_31_END

