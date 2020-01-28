; $Id: bit_open_di.asm,v 1.9 2016-06-16 20:23:52 dom Exp $
;
; TI calculator "Infrared port" 1 bit sound functions stub
;
; (Open sound port) and disable interrupts for exact timing
;
; Stefano Bodrato - 24/10/2001
;

    SECTION code_clib
    PUBLIC     bit_open_di
    PUBLIC     _bit_open_di
    EXTERN     __bit_irqstatus
    EXTERN     __snd_tick
    
.bit_open_di
._bit_open_di
        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (__bit_irqstatus),hl
        pop hl
	
IF FORti82
        ld      a,@11000000	; Set W1 and R1
        out     (0),a
        ld	a,@11010100
ENDIF

IF FORti83
        ld      a,@11010000
ENDIF

IF FORti85
        ld      a,@11000000
        out	(7),a
ENDIF

IF FORti86
        ld      a,@11000000
        out	(7),a
ENDIF

        ld   (__snd_tick),a

	ret

