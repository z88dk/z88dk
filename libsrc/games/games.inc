;
;       Game functions parameters
;
;       Written by Stefano Bodrato  1/10/2001
;	based on the Dominic's sound routines
;
;
;	$Id: games.inc,v 1.3 2001-10-22 09:33:55 stefano Exp $
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

