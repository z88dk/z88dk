;       Startup Code for pacman machine
;
;	B. Leperchey 2012
;
;          -startup=2  --> provide an IRQ handler (now required for the Tetris game)
;
;	$Id:$
;


	DEFC	ROM_Start  = $0000
	DEFC	INT_Start  = $0038
	DEFC	NMI_Start  = $0066
	DEFC	CODE_Start = $0100
	DEFC	VRAM_Start = $4000
	DEFC	VRAM_Length= $0400
	DEFC	CRAM_Start = $4400
	DEFC	CRAM_Length= $0400
	DEFC	RAM_Start  = $4C00
	DEFC	RAM_Length = $0400
	DEFC	Stack_Top  = $4ff0


	DEFC	irqen	= $5000
	DEFC	snden	= $5001
	DEFC	watchdog= $50c0

	MODULE  pacman_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

	;defc 	DEFINED_nostreams = 1
	defc    crt0 = 1
	
	INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

	EXTERN    _main		;main() is always external to crt0 code
IF (startup=2)
	EXTERN	_irq_handler	;Interrupt handlers
ENDIF
	PUBLIC    cleanup
	PUBLIC    l_dcal          ;jp(hl)


IF !DEFINED_CRT_ORG_BSS
	defc CRT_ORG_BSS =  RAM_Start   ; Static variables are kept in RAM
	defc DEFINED_CRT_ORG_BSS = 1
ENDIF
	defc	__crt_org_bss = CRT_ORG_BSS


	org    ROM_Start
	

; reset
	di
	ld sp,Stack_Top		; setup stack
	call	crt0_init_bss
	jp start		; jump to start


; IRQ code starts at location $0038, (56 decimal).
	defs	INT_Start-ASMPC

	di			; disable processor interrupts
	push	af
	push	bc
	push	de
	push	hl

	ld	hl,(FRAMES)
	inc	hl
	ld	(FRAMES),hl
	ld	a,h
	or	l
	jr	nz,irq_hndl
	ld	hl,(FRAMES+2)
	inc	hl
	ld	(FRAMES+2),hl
irq_hndl:

IF (startup=2)
 	call	_irq_handler
ENDIF

	xor a			; reset watchdog timer
	ld hl,watchdog
	ld (hl),a

	pop	hl
	pop	de
	pop	bc
	pop	af
	ei			; enable processor interrupts
	reti			; return from interrupt routine


	defs	NMI_Start-ASMPC
; nmi
	retn

start:
	ld a,$ff		; set up the interrupt vector (0x38)
	out (0),a
        ld a, 1		; fill register 'a' with 0x01
        ld (irqen), a		; enable the external interrupt mechanism
	xor a			; reset watchdog timer
	ld hl,watchdog
	ld (hl),a
; Clear static memory
	;ld	hl,RAM_Start
	;ld	de,RAM_Start+1
	;ld	bc,RAM_Length-1
	;ld	(hl),0
	;ldir
; enable interrupts
	im	1
	ei
; Entry to the user code
	call    _main
cleanup:
endloop:
	jr	endloop
	
l_dcal:
	jp      (hl)


   defm    "Small C+ PacMan"   ;Unnecessary file signature
		
	; If we were given a model then use it
	IF DEFINED_CRT_MODEL
	  defc __crt_model = CRT_MODEL
	ELSE
	  defc __crt_model = 1
	ENDIF

	INCLUDE "crt0_runtime_selection.asm"
	INCLUDE "crt0_section.asm"


SECTION bss_crt

PUBLIC  FRAMES
FRAMES: defw    0  ; 4 bytes timer counter
        defw	0
		 

SECTION code_crt_init
	ld	hl,$4000
	ld	(base_graphics),hl
