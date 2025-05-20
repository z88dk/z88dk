;
;      Startup for the s1mp3 players
;


    GLOBAL  _main
    PUBLIC  __Exit

    ;	defc	CRT_ORG_BSS = 0x7000
    defc    CRT_ORG_CODE = 0x0000

    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0x4000
    defc    TAR__crt_on_exit = 0x10001 ; Loop forever

    defc    CONSOLE_COLUMNS = 16
    defc    CONSOLE_ROWS = 4

    INCLUDE	"zcc_opt.def"

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

header:
    DEFW    0x0050                          ; header id
    DEFW    0x4757                          ;
    DEFW    0x9719                          ;
    DEFW    0x0003                          ;
    DEFW    0x0600                          ; text fileoffset (lo)
    DEFW    0                               ; text fileoffset (hi)
    DEFW    0                               ; Entry point (will be fixed by conv.exe)
    DEFW    Application_Start               ; text address
    DEFW    0                               ; data fileoffset (lo)
    DEFW    0                               ; data fileoffset (hi)
    DEFW    0                               ; data length
    DEFW    0                               ; data address
    DEFW    0                               ; bss length
    DEFW    0                               ; bss address
    DEFW    program                         ; entry point
    DEFB    0                               ; entry bank
    DEFB    0                               ; number of banks


    ; Interrupt vectors are here to improve emulator compatibility
        defs    $0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart20

    defs        $0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart28

        defs    $0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart30

        defs    $0038-ASMPC
if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif
        reti

restart08:
restart10:
restart18:
restart20:
restart28:
restart30:
        ret


        defs    $0600-ASMPC
if (ASMPC<>$0600)
        defs    CODE_ALIGNMENT_ERROR
endif
Application_Start:
program:
    di
    xor     a
    out     (0x27), a       ; MINT_ENABLE_REG
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


l_dcal: jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE "crt/classic/crt_section.inc"
