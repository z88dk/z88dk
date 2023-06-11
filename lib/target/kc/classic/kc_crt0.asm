;
;       CRT0 for the Robotron KC85/2 .. KC85/5
;
;       Stefano Bodrato October 2016
;		few hints were found on the sdcc lib by Andreas Ziermann and Bert Lange
;
;		OPTIMIZATIONS:
;		#pragma output nosound   - Save few bytes not preserving IX on tape and sound interrupts
;		#pragma output nointerrupsaving   - do not save some interrupt vectors on startup (includes nosound)
;
; - - - - - - -
;
;       $Id: kc_crt0.asm,v 1.2 2016-10-10 07:09:14 stefano Exp $
;
; - - - - - - -
;
; NB. Compiled with -IXIY so all iy references are actually ix


    MODULE  kc_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $1000
ENDIF
    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 32

    defc    TAR__fputc_cons_generic = 1
    defc	TAR__register_sp = CRT_ORG_CODE-2
    defc    TAR__clib_exit_stack_size = 32
    defc	__CPU_CLOCK = 2000000
    INCLUDE	"crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


start:
IF !DEFINED_nointerrupsaving
    ; Keyboard
    ld      hl,($01EE)
    ld      (INT01EE+7),hl
    ld      hl,INT01EE
    ld      ($01EE),hl

    ld      hl,($01E6)
    ld      (INT01E6+7),hl
    ld      hl,INT01E6
    ld      ($01E6),hl

IF !DEFINED_nosound
    ; Sound
    ld      hl,($01EC)
    ld      (INT01EC+7),hl
    ld      hl,INT01EC
    ld      ($01EC),hl

    ; Cassette input
    ld      hl,($01E4)
    ld      (INT01E4+7),hl
    ld      hl,INT01E4
    ld      ($01E4),hl

    ; Cassette output
    ld      hl,($01EA)
    ld      (INT01EA+7),hl
    ld      hl,INT01EA
    ld      ($01EA),hl
ENDIF
ENDIF

    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"	
    INCLUDE "crt/classic/crt_init_atexit.asm"	
    call    crt0_init_bss
    ld      (exitsp),sp



IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


    call    _main	;Call user program

cleanup:
    push    hl
    call    crt0_exit

IF !DEFINED_nointerrupsaving
    ; Keyboard
    ld      hl,(INT01EE+7)
    ld      ($01EE),hl

    ld      hl,(INT01E6+7)
    ld      ($01E6),hl

  IF !DEFINED_nosound
    ; Sound
    ld      hl,(INT01EC+7)
    ld      ($01EC),hl

    ; Cassette input
    ld      hl,(INT01E4+7)
    ld      ($01E4),hl

    ; Cassette output
    ld      hl,(INT01EA+7)
    ld      ($01EA),hl
  ENDIF
ENDIF

	pop	bc
__restore_sp_onexit:
    ld      sp,0    ;Restore stack to entry value
    ; use call LOOP instead of ret, works also
    ; with direct load+start on simulator
    call    $f003   ; PV1 - parameter in regs, PVnr after callPV1
    defb    $12     ;FNLOOP - returns control to CAOS without memory initialization


l_dcal:	jp	(hl)		;Used for function pointer calls

;	Interrupt table
;	01D4..01E1	free for user
;	01E2	SIO channel B (if V24 module installed)
;	01E4	PIO channel A (cassette input)
;	01E6 	PIO channel B (keyboard input)
;	01E8 	CTC channel 0 (free)
;	01EA 	CTC channel 1 (cassette output)
;	01EC 	CTC channel 2 (sound duration)
;	01EE 	CTC channel 3 (keyboard input)

IF !DEFINED_nointerrupsaving
; CTC channel 3 (keyboard input)
INT01EE:
    push    iy
    ld      iy,$01f0
    call    0
    pop     iy
    ret

; PIO channel B (keyboard input)
INT01E6:
    push    iy
    ld      iy,$01f0
    call    0
    pop     iy
    ret


IF !DEFINED_nosound
; CTC channel 2 (sound duration)
INT01EC:
    push    iy
    ld      iy,$01f0
    call    0
    pop     iy
    ret

; CTC channel 1 (cassette input)
INT01E4:
    push    iy
    ld      iy,$01f0
    call    0
    pop     iy
    ret

; CTC channel 1 (cassette output)
INT01EA:
    push    iy
    ld      iy,$01f0
    call    0
    pop     iy
    ret
ENDIF
ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"

    SECTION code_crt_init
    ld      hl,$8000
    ld      (base_graphics),hl

