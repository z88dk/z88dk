;
;       Z88 Graphics Functions - Small C+ stubbs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;       Define for graphics and other standard library functions
;
;
;	$Id: grafix.inc,v 1.15 2007-12-18 13:35:51 stefano Exp $
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


IF FORvz
	DEFINE gotgfx
	defc maxx	= 128
	defc maxy	= 64
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
	defc bcolor	= 0
	defc fcolor	= 2
	defc row_bytes  = 64
ENDIF

IF FORmsx
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
	defc fcolor	= 15
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

IF FORnascom
	DEFINE gotgfx
	defc maxx	= 96
	defc maxy	= 48
ENDIF

IF FORc128
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 50
ENDIF

IF FORaquarius
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 72
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

; Catch all to sort things out

IF !gotgfx
	defc	maxx = 256
	defc	maxy = 192
ELSE
	UNDEFINE gotgfx
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
