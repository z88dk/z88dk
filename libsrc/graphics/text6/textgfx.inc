;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 13/12/2006
;
;
;	$Id: textgfx.inc,v 1.4 2008-12-11 16:42:22 stefano Exp $
;


IF FORaquarius
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 72
	defc blankch	= 160
ENDIF

IF FORgal
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 48
	defc blankch	= 32
ENDIF

IF FORnascom
	DEFINE gotgfx
	defc maxx	= 96
	defc maxy	= 48
	defc blankch	= 32
ENDIF

IF FORtrs80
	DEFINE gotgfx
	defc maxx	= 128
	defc maxy	= 48
	defc blankch	= 128
ENDIF

IF !gotgfx
	defc	maxx 	= 80	; 40*2
	defc	maxy 	= 72	; 24*3
	defc 	blankch	= 32	; SPACE
ENDIF
