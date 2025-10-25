;       Memotech MTX CRT0 stub
;
;       $Id: mtx_crt0.asm,v 1.15 2016-07-15 21:03:25 dom Exp $
;


    MODULE  mtx_crt0

        
;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN  _main           ; main() is always external to crt0 code

    PUBLIC  __Exit         ; jp'd to by exit()
    PUBLIC  l_dcal          ; jp(hl)


    ; SEGA and MSX specific
    PUBLIC  msxbios


;--------
; Set an origin for the application (-zorg=) default to 32768
;--------

IF !DEFINED_CRT_ORG_CODE
    IF (startup=2)                 ; Attempt to use 48k on the MTX512
        defc    CRT_ORG_CODE  = 16384+19
    ELSE
        defc    CRT_ORG_CODE  = 32768+19
    ENDIF
ENDIF

IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF

    defc	CONSOLE_COLUMNS = 80
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -0xfa96
    defc    __CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"

    PUBLIC  __IO_SN76489_PORT
    defc    __IO_SN76489_PORT = $06
    PUBLIC  __IO_SN76489_LATCH_PORT
    defc    __IO_SN76489_LATCH_PORT = $03

IF !DEFINED_CLIB_RS232_PORT_B
    IF !DEFINED_CLIB_RS232_PORT_A
        defc DEFINED_CLIB_RS232_PORT_A = 1
    ENDIF
ENDIF
    INCLUDE	"target/mtx/def/mtxserial.def"

    org     CRT_ORG_CODE


start:

    ld      (__restore_sp_onexit+1),sp   ; Save entry stack

    INCLUDE "crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_init.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main           ; Call user program
__Exit:
    push    hl              ; return code
    call    crt0_exit
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_exit.inc"
    pop     bc          ; return code (still not sure it is teh right one !)
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0         ;Restore stack to entry value
    ret


l_dcal: jp      (hl)            ;Used for function pointer calls



; ---------------
; MSX specific stuff
; ---------------

; Safe BIOS call
msxbios:
    push    ix
    ret


    INCLUDE "crt/classic/crt_runtime_selection.inc"

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_disable.inc"

    INCLUDE "crt/classic/crt_section.inc"

