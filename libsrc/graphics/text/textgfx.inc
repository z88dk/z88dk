;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Define for graphics and other standard library functions
;
;
;	$Id: textgfx.inc,v 1.3 2002-04-17 21:30:25 dom Exp $
;

IF FORc128
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 50
	defc blankch	= 32
ENDIF

IF FORaquarius
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 48
	defc blankch	= 32
ENDIF

IF !gotgfx
	defc	maxx 	= 80
	defc	maxy 	= 48
	defc 	blankch	= 32
ELSE
	UNDEFINE gotgfx
ENDIF
