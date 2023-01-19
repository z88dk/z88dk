;
;       TI calc defines
;	used by VT 100/ANSI code
;
;       Define for char size and number of columns
;	+ specific display metrics
;
;
;	$Id: ticalc.inc,v 1.8 2010-03-27 18:59:25 stefano Exp $
;

	defc columns	= 32

IF FORti82
	defc row_bytes	= 12
	defc char_dots	= 3
	defc TIALPHAKEY	= $30	; Not used !  CrASH does the job.

	;ROM key handler
	;defc getkey	= $01D4

	;CRASH key handler
	defc getkey	= $8D91
	
	defc ti_putchar = $39D2
	defc ti_scroll  = $377A
	defc ti_x_text	= $800D
	defc ti_y_text	= $800C
	defc ti_maxx_t	= 15
	defc ti_maxy_t	= 7
ENDIF

IF FORti83
	defc row_bytes	= 12
	defc char_dots	= 3
	defc TIALPHAKEY	= $30
	defc getkey	= $4CFE
	
	defc ti_putchar = $4705
	defc ti_scroll  = $473D
	defc ti_x_text	= $800D
	defc ti_y_text	= $800C
	defc ti_maxx_t	= 15
	defc ti_maxy_t	= 7
ENDIF

IF FORti83p
	defc row_bytes	= 12
	defc char_dots	= 3
	defc TIALPHAKEY	= $30
	defc getkey	= $4972

	defc ti_putchar = $4504
	defc ti_scroll  = $452E
	defc ti_x_text	= $844C
	defc ti_y_text	= $844B
	defc ti_maxx_t	= 15
	defc ti_maxy_t	= 7

	defc ti_putchar_small = $455E
	defc ti_x_text_small  = $86D7
	defc ti_y_text_small  = $86D8
	defc ti_maxx_t_small  = (95 - 5) ; subtract a margin to avoid losing chars
	defc ti_maxy_t_small  = 63
ENDIF

; TI 85 and TI 86 can go up to 42 columns if char_dots is set to 3

IF FORti85
	defc row_bytes	= 16
	defc char_dots	= 4
	defc TIALPHAKEY	= $30
	defc getkey	= $01BE
	;defc getkey	= $0168
	
	defc ti_putchar = 0
	defc ti_scroll  = 6
	defc ti_x_text	= $800D
	defc ti_y_text	= $800C
	defc ti_maxx_t	= 20
	defc ti_maxy_t	= 7
ENDIF

IF FORti86
	defc row_bytes	= 16
	defc char_dots	= 4
	defc TIALPHAKEY	= $30 ;;??  To be checked.
	defc getkey	= $55AA
	
	defc ti_putchar = $4A2B
	defc ti_scroll  = $4A5F
	defc ti_x_text	= $C010
	defc ti_y_text	= $C00F
	defc ti_maxx_t	= 20
	defc ti_maxy_t	= 7
ENDIF
