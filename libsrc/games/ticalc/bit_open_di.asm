; $Id: bit_open_di.asm,v 1.2 2001-10-31 11:25:22 stefano Exp $
;
; TI calculator "Infrared port" 1 bit sound functions stub
;
; (Open sound port) and disable interrupts for exact timing
;
; Stefano Bodrato - 24/10/2001
;

    XLIB     bit_open_di
    XREF     tidi
    
.bit_open_di
	di
	
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

	ret

