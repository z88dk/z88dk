;
;       Z88 Graphics Functions - Small C+ stubbs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;       Define for graphics and other standard library functions

IF FORvz200
	defc	maxy	= 64
ENDIF

IF FORzx
	defc	maxy	= 192
ENDIF

IF FORz88

	defc	maxy 	= 64

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
