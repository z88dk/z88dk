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


IF FORti82
	defc row_bytes	= 12
	defc maxx	= 95
	defc maxy	= 63
ENDIF

IF FORti83
	defc row_bytes	= 12
	defc maxx	= 95
	defc maxy	= 63
ENDIF

IF FORti83p
	defc row_bytes	= 12
	defc maxx	= 95
	defc maxy	= 63
ENDIF

IF FORti85
	defc row_bytes	= 16
	defc maxx	= 127
	defc maxy	= 63
ENDIF

IF FORti86
	defc row_bytes	= 16
	defc maxx	= 127
	defc maxy	= 63
ENDIF


IF FORvz
	defc maxx	= 127
	defc maxy	= 63
ENDIF


IF FORzx81
	defc maxx	= 95 ; emulated (64 real dots)
	defc maxy	= 63 ; emulated (48 real dots)
ENDIF

IF FORjupiter
	defc maxx	= 95 ; emulated (64 real dots)
	defc maxy	= 63 ; emulated (48 real dots)
ENDIF


IF FORzx
	defc maxx	= 255
	defc maxy	= 191
ENDIF


IF FORz88

	defc	maxy 	= 63

IF !APPZ88
        defc    map_seg = 192
        defc    map_bk  = $4D3
ELSE
        defc    map_seg = 64     
        defc    map_bk = $4D1
ENDIF


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
