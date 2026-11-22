;	Casio FP-1100


    MODULE  fp1100_crt0

        
;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    __Exit         ; jp'd to by exit()
    PUBLIC    l_dcal          ; jp(hl)


;--------
; Set an origin for the application (-zorg=) default to 32768
;--------

IFNDEF CRT_ORG_CODE
    IF startup = 1
        defc    CRT_ORG_CODE = 0xb000
    ELSE
        defc    CRT_ORG_CODE = 0x0000
    ENDIF
ENDIF

; A program below $9000 is an all-RAM one: the ROM's routines (RAM copies at $0000-$8FFF) are overwritten by it, so it makes no ROM calls, and the bootstrap loads it with a
; RAM loader (BOOTSTRAP2, see bootstrap.asm).  It is started at CRT_ORG_CODE by that loader, and has the whole machine: the stack at the top of RAM (-pragma-define:REGISTER_SP=n).
IF CRT_ORG_CODE < $9000
    defc    FP1100_ALLRAM = 1
ELSE
    defc    FP1100_ALLRAM = 0
ENDIF

IF startup = 2
    defc    CONSOLE_ROWS = 25
    defc    CRT_KEY_DEL = 12            ; (what the all-RAM getk returns for BS and DEL; the erase itself is still 8, space, 8)
    defc    TAR__register_sp = 0xfff0
ELSE
    defc    CONSOLE_ROWS = 24
    defc    CRT_KEY_DEL = 8
    defc    TAR__register_sp = -1
ENDIF
    defc    CONSOLE_COLUMNS = 40
    PUBLIC  GRAPHICS_CHAR_SET
    PUBLIC  GRAPHICS_CHAR_UNSET
    defc    GRAPHICS_CHAR_SET = 0x87
    defc    GRAPHICS_CHAR_UNSET = 0x32



    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0

    defc    __CPU_CLOCK = 4000000 
    INCLUDE "crt/classic/crt_rules.inc"

    INCLUDE "target/fp1100/def/fp1100.def"
	
    org     CRT_ORG_CODE

    jp      start
IF CRT_ORG_CODE = 0
    INCLUDE "crt/classic/crt_z80_rsts.inc"      ; (the usual rst and NMI vectors: an all-RAM program at 0 owns them)
ENDIF
start:
IF startup = 1
    ld      (__restore_sp_onexit+1),sp   ; Save entry stack
ENDIF
    INCLUDE "crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"


    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

IF startup = 1
    ld      a,SUB_BEEPOFF
    call    TRNC1
ENDIF


    call    _main           ; Call user program
__Exit:
    push    hl              ; return code
    call    crt0_exit
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
IF startup = 2
__halt:
    halt                    ; (there is nothing to return to)
    jr      __halt
ELSE
__restore_sp_onexit:
    ld      sp,0            ;Restore stack to entry value
    ret
ENDIF


l_dcal: jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE "crt/classic/crt_section.inc"

    INCLUDE	"target/fp1100/classic/bootstrap.asm"
