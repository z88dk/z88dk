;       Startup Code for pacman machine
;
;	B. Leperchey 2012
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

	INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

	EXTERN    _main		;main() is always external to crt0 code
	EXTERN	_irq_handler	;Interrupt handlers
	PUBLIC    l_dcal          ;jp(hl)





	org    ROM_Start
; reset
	di
	ld sp,Stack_Top		; setup stack
	jp start		; jump to start




	defs	INT_Start-ASMPC
; irq
	di			; disable processor interrupts
	push	af
	push	bc
	push	de
	push	hl
	call	_irq_handler
	pop	hl
	pop	de
	pop	bc
	pop	af
	ei			; enable processor interrupts
	reti			; return from interrupt routine




	defs	NMI_Start-ASMPC
; nmi
	reti

start:
	ld a,$ff		; set up the interrupt vector (0x38)
	out ($00),a
        ld a, #0x01		; fill register 'a' with 0x01
        ld (irqen), a		; enable the external interrupt mechanism
	xor a			; reset watchdog timer
	ld hl,watchdog
	ld (hl),a
; Clear static memory
	ld	hl,RAM_Start
	ld	de,RAM_Start+1
	ld	bc,RAM_Length-1
	ld	(hl),0
	ldir
; enable interrupts
	im	1
	ei
; Entry to the user code
	call    _main
.endloop
	jr	endloop
l_dcal:
	jp      (hl)



