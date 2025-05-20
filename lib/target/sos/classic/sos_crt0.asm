;
;       Startup for S-OS (The Sentinel) Japanese OS
;
;       Stefano Bodrato - Winter 2013
;
;       $Id: sos_crt0.asm,v 1.16 2016-07-15 21:38:08 dom Exp $


    MODULE  sos_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN    _main		;main() is always external to crt0

    PUBLIC    __Exit		;jp'd to by exit()
    PUBLIC    l_dcal		;jp(hl)


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $3000
ENDIF

    IF !DEFINED_CRT_COMMANDLINE_REDIRECTION
        define  DEFINED_CRT_COMMANDLINE_REDIRECTION
        defc    TAR__CRT_COMMANDLINE_REDIRECTION = 0
    ENDIF
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -0x1f6a	;;Upper limit of the user area
    defc    __CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.inc"
    dec     sp
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/crt_init_heap.inc"


; Push pointers to argv[n] onto the stack now
; We must start from the end 
    ld      hl,0	;NULL pointer at end, just in case
    push    hl
    ld      b,h     ; parameter counter
    ld      c,h     ; character counter
    ld      hl,($1F76)	; #KBFAD

; Program is entered with a 'J' (jump command) at location 3000
; so the command name will be always 3000, we skip eventual balnks,
; so "J3000" and "J  3000" will have the same effect
skipblank:
    inc     hl
    inc     hl
    ld      a,(hl)
    cp      ' '
    jr      z,skipblank
    ld      a,(hl)
    and     a
    jp      z,argv_done
    dec     hl
find_end:
    inc     hl
    inc     c
    ld      a,(hl)
    and     a
    jr      nz,find_end
    dec     hl
    ; now HL points to the end of command line
    ; and C holds the length of args buffer
    ld      b,0
    INCLUDE	"crt/classic/crt_command_line.inc"

    INCLUDE "crt/classic/crt_init_eidi.inc"

    push    hl      ;argv
    push    bc      ;argc
    call    _main		;Call user code
    pop     bc	;kill argv
    pop     bc	;kill argc

__Exit:
    push    hl
    call    crt0_exit
    pop     bc      ;Get exit() value into bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0		;Pick up entry sp
    jp      $1FFA	; HOT boot

l_dcal:
    jp  (hl)		;Used for call by function ptr

    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE "crt/classic/crt_section.inc"


