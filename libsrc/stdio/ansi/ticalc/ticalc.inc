;
;       TI calc defines
;	used by VT 100/ANSI code
;
;       Define for char size and number of columns
;	+ specific display metrics
;
;
;	$Id: ticalc.inc,v 1.4 2001-04-13 14:13:59 stefano Exp $
;

	defc columns	= 32

IF FORti82
	defc row_bytes	= 12
	defc char_dots	= 3
	defc TIALPHAKEY	= $30

	;ROM key handler
	;defc getkey	= $01D4

	;CRASH key handler
	defc getkey	= $8D91
ENDIF

IF FORti83
	defc row_bytes	= 12
	defc char_dots	= 3
	defc TIALPHAKEY	= $30
	defc getkey	= $4CFE
ENDIF

IF FORti83p
	defc row_bytes	= 12
	defc char_dots	= 3
	defc TIALPHAKEY	= $30	; To be checked
	defc getkey	= $4972
ENDIF

; TI 85 and TI 86 can go up to 42 columns if char_dots is set to 3

IF FORti85
	defc row_bytes	= 16
	defc char_dots	= 4
	defc TIALPHAKEY	= $30
	defc getkey	= $01BE	
ENDIF

IF FORti86
	defc row_bytes	= 16
	defc char_dots	= 4
	defc TIALPHAKEY	= $30 ;;??  To be checked.
	defc getkey	= $55AA
ENDIF
