;
;	Embedded C Library
;
;	fputc_cons
;
;	Daniel Wallner - Mar. 2002
;

	INCLUDE "ns16450.def"

	PUBLIC  fputc_cons_native

.fputc_cons_native
	ld      bc,UART_BASE + LSR
loop:
	in      a,(c)
	and     a,$20
	jr      z,loop
	ld      hl,2
	add     hl,sp
	ld      a,(hl)
	ld      bc,UART_BASE
	out     (c),a
	ret
