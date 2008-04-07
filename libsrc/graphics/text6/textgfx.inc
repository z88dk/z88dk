;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 13/12/2006
;
;
;	$Id: textgfx.inc,v 1.3 2008-04-07 17:43:30 stefano Exp $
;

IF FORtrs80
	DEFINE gotgfx
	defc maxx	= 128
	defc maxy	= 48
	defc blankch	= 128
ENDIF

IF FORaquarius
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 72
	defc blankch	= 160
ENDIF

IF FORnascom
	DEFINE gotgfx
	defc maxx	= 96
	defc maxy	= 48
	defc blankch	= $C0
ENDIF

IF !gotgfx
	defc	maxx 	= 80
	defc	maxy 	= 72
	defc 	blankch	= 32
ELSE
	UNDEFINE gotgfx
ENDIF
