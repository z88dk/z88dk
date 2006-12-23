;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 13/12/2006
;
;
;	$Id: textgfx.inc,v 1.1 2006-12-23 21:33:10 stefano Exp $
;

IF FORaquarius
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 72
	defc blankch	= 160
ENDIF

IF !gotgfx
	defc	maxx 	= 80
	defc	maxy 	= 72
	defc 	blankch	= 32
ELSE
	UNDEFINE gotgfx
ENDIF
