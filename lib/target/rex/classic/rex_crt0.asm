;       Startup Code for Xircom Rex 6000
;
;	djm 6/3/2001
;
;       $Id: rex_crt0.asm,v 1.27 2016-07-13 22:12:25 dom Exp $
;

    MODULE rex_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope declarations
;--------

    EXTERN	_main		;main() is always external to crt0

IF (startup=2)                 ; Library ?
    EXTERN	_LibMain
ENDIF

    PUBLIC	l_dcal		;jp(hl) instruction
    PUBLIC	cleanup


;	defm	"ApplicationName:Addin",10,13
;	defm	"[program name - 10 chars?]",10,13
;	defb	0
;	defw	endprof-begprog
;	defb	0,0
; Prior to $8000 we have a 40x32 icon

;--------
; Main code starts here
;--------

    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 65535
    defc    __CPU_CLOCK = 4300000
    INCLUDE "crt/classic/crt_rules.inc"

    org    $8000


    jp  start           ;addin signature jump

	
	
IF (startup=2)                 ; Library ?

signature:
    defm    "XXX"
lib:
    ld      hl,farret
    push    hl
    jp      _LibMain
start:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp	;Store atexit() stack
    ; Entry to the user code
    call    _main		;Call the users code
cleanup:
    ld      de,$42	;DS_ADDIN_TERMINATE
    ld      ($c000),de
    rst     $10		;Exit the addin
endloop:
    jr  endloop
l_dcal:
    jp  (hl)        ;Used for call by function pointer
farret:             ;Used for farcall logic
    pop     bc
    ld      a,c
    jp	    $26ea

ELSE

start:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    ld      (exitsp),sp	;Store atexit() stack
    ; Entry to the user code
    call    _main		;Call the users code
cleanup:
    ld      de,$42	;DS_ADDIN_TERMINATE
    ld      ($c000),de
    rst     $10		;Exit the addin
endloop:
    jr      endloop
l_dcal:	jp	(hl)		;Used for call by function pointer

ENDIF


;	INCLUDE	"crt/classic/crt_runtime_selection.asm"
    defc	__crt_org_bss = $f033
    INCLUDE	"crt/classic/crt_section.asm"


