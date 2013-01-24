;
;       Z88 Graphics Functions - Small C+ stubbs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;       Define for graphics and other standard library functions
;       See also text/textgfx.inc and text6/textgfx.inc
;
;
;	$Id: grafix.inc,v 1.32 2013-01-24 15:31:38 stefano Exp $
;


IF FORti82
	DEFINE gotgfx
	defc row_bytes	= 12
	defc maxx	= 96
	defc maxy	= 64
ENDIF

IF FORti83
	DEFINE gotgfx
	defc row_bytes	= 12
	defc maxx	= 96
	defc maxy	= 64
ENDIF

IF FORti83p
	DEFINE gotgfx
	defc row_bytes	= 12
	defc maxx	= 96
	defc maxy	= 64
ENDIF

IF FORti85
	DEFINE gotgfx
	defc row_bytes	= 16
	defc maxx	= 128
	defc maxy	= 64
ENDIF

IF FORti86
	DEFINE gotgfx
	defc row_bytes	= 16
	defc maxx	= 128
	defc maxy	= 64
ENDIF

IF FORpc6001
	DEFINE gotgfx
	defc maxx	= 128
	defc maxy	= 192
ENDIF

IF FORvz
	DEFINE gotgfx
	defc maxx	= 128
	defc maxy	= 64
ENDIF

IF FORzx80
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 48
ENDIF

IF FORzx81
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 48
ENDIF

IF FORzx81hr64
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 64
ENDIF

IF FORzx81hr192
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
ENDIF

IF FORzx81mt192
	DEFINE gotgfx
	defc maxx	= 248
	defc maxy	= 192
ENDIF

IF FORjupiter
	DEFINE gotgfx
	defc maxx	= 96 ; emulated (64 real dots)
	defc maxy	= 64 ; emulated (48 real dots)
ENDIF

IF FORzx
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
ENDIF

IF FORcpc
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
	; Possible colors: 0 (blue), 1 (yellow), 2 (cyan), 3 (red)
	defc bcolor	= 0
	defc fcolor	= 2
	defc row_bytes  = 64
ENDIF

IF FOReinstein
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
	defc fcolor	= 1
ENDIF

IF FORmsx
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
	defc fcolor	= 1
ENDIF

IF FORsvi
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
	defc fcolor	= 1
ENDIF

IF FORsam
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
ENDIF

IF FORoz
	DEFINE gotgfx
	defc row_bytes	= 30
	defc maxx	= 239
	defc maxy	= 80
ENDIF

IF FORosca
	DEFINE gotgfx
	defc maxx	= 320
	defc maxy	= 200
	; untested 240 lines resolution, see 'libsrc/graphics/osca'
	;defc maxy	= 240
ENDIF

IF FORc128hr
	DEFINE gotgfx
	defc maxx	= 640
	defc maxy	= 200
ENDIF

IF FORc128hr480
	DEFINE gotgfx
	defc maxx	= 640
	defc maxy	= 480
ENDIF

IF FORgfx2068hr
	DEFINE gotgfx
	defc maxx       = 512
	defc maxy       = 192
ENDIF

IF FORenterprise
	DEFINE gotgfx
	defc maxx       = 336
	defc maxy       = 243
ENDIF

IF FORenterprisehr
	DEFINE gotgfx
	defc maxx       = 672
	defc maxy       = 243
ENDIF

IF FORz88
	DEFINE gotgfx
	defc	maxx	= 256
	defc	maxy 	= 64
   IF !APPZ88
        defc    map_seg	= 192
        defc    map_bk	= $4D3
   ELSE
        defc    map_seg	= 64     
        defc    map_bk	= $4D1
   ENDIF
ENDIF


; === Definitions copied from textgfx.inc ===

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

IF FORc128
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 50
	defc blankch	= 32
ENDIF

; =============================================


; Catch all to sort things out

IF !gotgfx
	defc	maxx = 256
	defc	maxy = 192
ENDIF


;       Structure for open window       struct *window

DEFVARS 0
{
        windnum ds.b    1
        wind_x  ds.b    1
        wind_y  ds.b    1
        wind_w  ds.b    1       ;width/map width
        wind_d  ds.b    1       ;
        type    ds.b    1       ;
        graph   ds.b    1       ;0=text 1=graphics
}
