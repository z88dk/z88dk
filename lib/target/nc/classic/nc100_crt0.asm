;       Kludgey startup for nc100
;
;       djm 17/4/2000
;
; 	I've never used one of these brutes so I dunno if it's
;	correct at all, this is all taken from the file nciospec.doc
;	on nvg.unit.no, I assume that the PCMCIA RAM card is an
;	actual fact addressable RAM and we can overwrite variables
;	etc NB. Values of static variables are not reinitialised on
;	future entry.
;
;       $Id: nc100_crt0.asm,v 1.17+ (now on GIT) $
;



    MODULE  nc100_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN    _main		;main() is always external to crt0 code

    PUBLIC    __Exit		;jp'd to by exit()
    PUBLIC    l_dcal		;jp(hl)

    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc	__CPU_CLOCK = 4606000
    INCLUDE "crt/classic/crt_rules.inc"


    IF (startup=2)
    defc    CRT_ORG_CODE  = $8C00
    org     CRT_ORG_CODE
    jp      start
ELSE

    defc    CRT_ORG_CODE  = $C000
    org     CRT_ORG_CODE
    jp      start

IF DEFINED_CRT_HEAP_AMALLOC || CLIB_MALLOC_HEAP_SIZE > 0 || CRT_STACK_SIZE > 0
;EXTERN ASMTAIL
PUBLIC _heap
; We have 509 bytes we can use here..
_heap:
    defw    0
    defw    0
_mblock:
    defs    505		; Few bytes for malloc() stuff
ELSE
	defs    509		; Waste 509 bytes of space
ENDIF

;--------
; Card header
;--------
    defm    "NC100PRG"	
    defb    0,0,0,0,0,0,0,0
    jp      start			;c210
    defm    "z88dk NC100"
    defb    0,0

ENDIF


start:
    ;Entry point at $c2220
    ld      (__restore_sp_onexit+1),sp   ;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
    INCLUDE "crt/classic/crt_init_heap.inc"
IF DEFINED_CRT_HEAP_AMALLOC || CLIB_MALLOC_HEAP_SIZE > 0 || CRT_STACK_SIZE > 0
    ; Add in an extra 505 bytes to the heap
    ld      hl,_mblock
    push    hl	; data block
    ld      hl,505
    push    hl	; area size
    EXTERN  sbrk_callee
    call    sbrk_callee
ENDIF

    INCLUDE "crt/classic/crt_init_eidi.inc"
    call    _main		;Call user code

__Exit:
    push    hl
    call    crt0_exit
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:	jp	(hl)

    INCLUDE "crt/classic/crt_runtime_selection.inc"
    UNDEFINE DEFINED_CRT_HEAP_AMALLOC
    INCLUDE "crt/classic/crt_section.inc"
