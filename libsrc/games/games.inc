;
;       Game functions parameters
;
;       Written by Stefano Bodrato  1/10/2001
;	based on the Dominic's sound routines
;
;
;	$Id: games.inc,v 1.1 2001-10-16 18:03:03 dom Exp $
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

