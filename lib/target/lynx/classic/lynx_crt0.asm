;       CRT0 stub for the Camputers Lynx
;
;       Stefano Bodrato - 2014
;
;	$Id: lynx_crt0.asm,v 1.11 2016-07-15 21:03:25 dom Exp $
;


    MODULE  lynx_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    defc	CONSOLE_COLUMNS = 32
    defc	CONSOLE_ROWS = 32


    EXTERN    _main
    PUBLIC    __Exit
    PUBLIC    l_dcal



IF      !DEFINED_CRT_ORG_CODE
    IF      startup = 2
        defc    CRT_ORG_CODE  = $0000
    ELSE
        defc    CRT_ORG_CODE  = $7000
    ENDIF
ENDIF

    defc    TAR__clib_exit_stack_size = 32
IF      startup = 2
    defc    TAR__register_sp = $fff0
    defc    TAR__crt_on_exit = 0x10001      ; (halt: there is nothing to return to)
ELSE
    defc    TAR__register_sp = -1
ENDIF
    defc    __CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"
    org     CRT_ORG_CODE

IF      startup = 2
    IF      CRT_ORG_CODE = 0
        jp      start
        INCLUDE "crt/classic/crt_z80_rsts.inc"
    ENDIF
ENDIF
start:

IF      startup = 2
    di
    xor     a
    out     ($80),a                         ; the control port: cassette and the rest off (they would stop the video RAM being written)
    ld      a,$08
    out     ($82),a                         ; the bank port: the user RAM is read and written
ELSE
    ld      hl,0
    add     hl,sp
    ld      (__restore_sp_onexit+1),hl
ENDIF
    INCLUDE "crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
__Exit:
    push    hl
    call    crt0_exit
IF      startup = 2
    INCLUDE "crt/classic/crt_terminate.inc"
ELSE
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
    ret
ENDIF

		
l_dcal:
    jp      (hl)



    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE	"crt/classic/crt_section.inc"

IF      startup = 2
    INCLUDE "target/lynx/classic/bootstrap.asm"
ENDIF
