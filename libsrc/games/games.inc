;
;       Game functions parameters
;
;       Written by Stefano Bodrato  1/10/2001
;	based on the Dominic's sound routines
;
;
;	$Id: games.inc,v 1.5 2001-12-24 13:16:20 stefano Exp $
;

IF FORzx
	defc sndbit_port   = 254
	defc sndbit_bit    = 4
	defc sndbit_mask   = 16		; (2^sndbit_bit)
ENDIF

IF FORz88
	defc sndbit_port   = $B0
	defc sndbit_bit    = 6
	defc sndbit_mask   = 64
ENDIF

IF FORjupiter
	defc sndbit_port   = $FE
	defc sndbit_bit    = 0
	defc sndbit_mask   = 1
ENDIF

IF FORaquarius
	defc sndbit_port   = $FC
	defc sndbit_bit    = 0
	defc sndbit_mask   = 1
ENDIF

IF FORti82
	defc sndbit_port   = 0
	defc sndbit_bit    = 2
	defc sndbit_mask   = @00111100
ENDIF

IF FORti83
	defc sndbit_port   = 0
	defc sndbit_bit    = 0
	defc sndbit_mask   = 3
ENDIF

IF FORti83p
	defc sndbit_port   = 0
	defc sndbit_bit    = 0
	defc sndbit_mask   = 3
ENDIF

IF FORti85
	defc sndbit_port   = 7
	defc sndbit_bit    = 2
	defc sndbit_mask   = @00111100
ENDIF


IF FORti86
	defc sndbit_port   = 7
	defc sndbit_bit    = 2
	defc sndbit_mask   = @00111100
ENDIF

