;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Define for graphics and other standard library functions
;
;
;	$Id: textgfx.inc,v 1.4 2008-12-11 16:42:22 stefano Exp $
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
	defc	maxx 	= 80	; 40*2
	defc	maxy 	= 48	; 24*2
	defc 	blankch	= 32	; SPACE
ENDIF
