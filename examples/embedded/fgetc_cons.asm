;
;	Embedded C Library
;
;	fgetc_cons
;
;	Daniel Wallner - Mar. 2002
;

	INCLUDE "ns16450.def"

	PUBLIC	fgetc_cons

.fgetc_cons
	ld      bc,UART_BASE + LSR
loop:
	in      a,(c)
	and     a,$1
	jr      z,loop
	ld      bc,UART_BASE
	in      a,(c)
	ld      l,a
	ret
