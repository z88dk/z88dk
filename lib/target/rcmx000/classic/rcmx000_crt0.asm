;       CRT0 for the Rabbit Control Module
;
;       If an error occurs (eg. out if screen) we just drop back to BASIC
;
; - - - - - - -
;
;       $Id: rcmx000_crt0.asm,v 1.13 2016-06-21 20:49:06 dom Exp $
;
; - - - - - - -

	; TODO_KANIN Fix this!!!

	MODULE  rcmx000_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;-------
; Simulate unsupported z80 instructions
;-------

        EXTERN     rcmx_cpd
        EXTERN     rcmx_cpdr
        EXTERN     rcmx_cpi
        EXTERN     rcmx_cpir
        EXTERN     rcmx_rld
        EXTERN     rcmx_rrd

;-------
; Some general scope declarations
;-------

    EXTERN    _main           ;main() is always external to crt0 code

    PUBLIC  __sendchar	;  Used by stdio
    PUBLIC  __recvchar

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    defc    TAR__register_sp = -1
    defc    TAR__clib_exit_stack_size = 0

    PUBLIC  __CPU_CLOCK
    defc    __CPU_CLOCK = 6000000
    INCLUDE "crt/classic/crt_rules.inc"


    org     0
start:
    ; On this platform we are king of the road and may use
    ; any register for any purpose Wheee!!
    ld      (__restore_sp_onexit),sp
    include "target/rcmx000/classic/rcmx000_boot.asm"
    call    crt0_init_bss
    call    _main	;Call user program
        
cleanup:
    push	hl
    call    crt0_exit
    pop     bc
__restore_sp_onexit:
    ld      sp,0        ;Restore stack to some sane value

    ; Puts us back into the monitor
    call    8

l_dcal:
    jp      (hl)        ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.asm"

    INCLUDE "crt/classic/crt_section.asm"

