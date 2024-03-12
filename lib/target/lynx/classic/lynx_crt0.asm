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




;--------
; Set an origin for the application (-zorg=) default to $7000
;--------

IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $7000
ENDIF

    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc    __CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"
    org     CRT_ORG_CODE

start:

    ld      hl,0
    add     hl,sp
    ld      (__restore_sp_onexit+1),hl
    INCLUDE "crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
__Exit:
    push    hl
    call    crt0_exit
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
    ret

		
l_dcal:
    jp      (hl)



    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE	"crt/classic/crt_section.inc"

