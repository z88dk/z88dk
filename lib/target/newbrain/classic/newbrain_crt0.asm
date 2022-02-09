;
;       Grundy NewBrain startup code
;
;
;       $Id: newbrain_crt0.asm,v 1.20 2016-07-15 21:03:25 dom Exp $
;

	MODULE  newbrain_crt0
;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)



	PUBLIC	nbclockptr	;ptr to clock counter location
IF (startup=2)
	PUBLIC	oldintaddr	;made available to chain an interrupt handler
ENDIF


IF      !DEFINED_CRT_ORG_CODE
	defc    CRT_ORG_CODE  = 10000
ENDIF

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE


start:
    ld      (__restore_sp_onexit+1),sp   ;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    ld      (exitsp),sp


IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
        
IF (startup=2)
	ld	hl,(57)
	ld	(oldintaddr),hl
	ld	hl,nbckcount
	ld	(57),hl
ENDIF

        call    _main		;Call user program

cleanup:
    call    crt0_exit

IF (startup=2)
	ld	hl,(oldintaddr)
	ld	(57),hl
ENDIF

cleanup_exit:

__restore_sp_onexit:ld      sp,0            ;Restore stack to entry value
        ret

l_dcal:	jp	(hl)		;Used for function pointer calls




;-----------
; Grundy NewBrain clock handler.
; an interrupt handler could chain the "oldintaddr" value.
;-----------

IF (startup=2)

nbclockptr:	defw	$52	; ROM routine

; Useless custom clock counter (we have the ROM one).
;
;.nbclockptr	defw	nbclock
;
nbckcount:
;		push	af
;		push	hl
;		ld	hl,(nbclock)
;		inc	hl
;		ld	(nbclock),hl
;		ld	a,h
;		or	l
;		jr	nz,nomsb
;		ld	hl,(nbclock_m)
;		inc	hl
;		ld	(nbclock_m),hl
;nomsb:		pop	hl
;		pop	af

		defb	195	; JP
oldintaddr:	defw	0

nbclock:	defw	0	; NewBrain Clock
nbclock_m:	defw	0

ELSE

nbclockptr:	defb	$52	; paged system clock counter

ENDIF


        INCLUDE "crt/classic/crt_runtime_selection.asm"

        INCLUDE "crt/classic/crt_section.asm"
