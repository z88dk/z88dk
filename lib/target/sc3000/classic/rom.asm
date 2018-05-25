;       CRT0 (rom) stub for the SEGA SC-3000/SG-1000
;
;       Stefano Bodrato - Jun 2010
;
;	$Id: sc3000_crt0.asm,v 1.18 2016-07-13 22:12:25 dom Exp $
;

	; Constants for ROM mode (-startup=2)
	
	defc	ROM_Start  = $0000
	defc	RAM_Start  = $C000
	defc	RAM_Length = $0800
	defc	Stack_Top  = $c400

	defc    CRT_ORG_CODE  = ROM_Start
        defc    TAR__register_sp = Stack_Top
        defc    TAR__clib_exit_stack_size = 0
	defc	__CPU_CLOCK = 3580000
	INCLUDE	"crt/classic/crt_rules.inc"

	EXTERN	msx_set_mode

        org     CRT_ORG_CODE

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif
	di
        jp      program

        defs    $0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart08

        defs    $0010-ASMPC
if (ASMPC<>$0010)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart10

        defs    $0018-ASMPC
if (ASMPC<>$0018)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart18

        defs    $0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart20

    defs        $0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart28
        defs    $0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart30

        defs    $0038-ASMPC
if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif
; IM1 interrupt routine
int_RASTER:
	push	hl
	
;	ld	a, ($BF)
;	or	a
;	jp	p, int_not_VBL	; Bit 7 not set
;	jr	int_VBL

int_not_VBL:
	pop	hl
	reti
	
int_VBL:
	ld	hl, timer
	ld	a, (hl)
	inc	a
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	adc	a, 1
	ld	(hl), a		;Increments the timer
	
	ld	hl, raster_procs
	call	int_handler
	pop	hl
	reti

        defs    $0066 - ASMPC
if (ASMPC<>$0066)
        defs    CODE_ALIGNMENT_ERROR
endif
nmi:
int_PAUSE:
	push	hl
	
	ld	hl, _pause_flag
	ld	a, (hl)
	xor	a, 1
	ld	(hl), a
	
	ld	hl, pause_procs
	call	int_handler
	pop	hl
	retn

int_handler:
	push	af
	push	bc
	push	de
int_loop:
	ld	a, (hl)
	inc	hl
	or	(hl)
	jr	z, int_done
	push	hl
	ld	a, (hl)
	dec	hl
	ld	l, (hl)
	ld	h, a
	call	call_int_handler
	pop	hl
	inc	hl
	jr	int_loop
int_done:
	pop	de
	pop	bc
	pop	af
	ret

call_int_handler:
	jp	(hl)


restart10:
restart08:
restart18:
restart20:
restart28:
restart30:
        ret

program:
; Make room for the atexit() stack
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"

	call	crt0_init_bss
	ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


	; Initialise mode 2 by default
	ld	hl,2
	call	msx_set_mode
	
	im	1
;	ei

; Entry to the user code
	call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF CRT_ENABLE_STDIO = 1
	EXTERN 	closeall
	call	closeall
ENDIF

endloop:
	jr	endloop


	defc	__crt_org_bss = RAM_Start
        ; If we were given a model then use it
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF
