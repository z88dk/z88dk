;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Define for graphics and other standard library functions
;
;
;	$Id: textgfx.inc,v 1.1 2002-01-30 10:11:13 stefano Exp $
;

IF FORc128
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 50
	defc blankch	= 32
ENDIF

IF !gotgfx
	defc	maxx 	= 80
	defc	maxy 	= 48
	defc 	blankch	= 32
ELSE
	UNDEFINE gotgfx
ENDIF
