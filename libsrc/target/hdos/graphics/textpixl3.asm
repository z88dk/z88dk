;
;
;	Support char table (pseudo graph symbols) for the Heath/Zenith H19 terminal
;	To be used with the "generic console" implementation the 1x3 graphics symbols
;	Sequence: blank, top, half, top+half, bottom, etc..

;
;	$Id: textpixl3.asm $
;
;


    PUBLIC  textpixl


textpixl:
    defb  32
    defb  156, 131, 146
    defb  157, 131+64, 146+64
    defb  32+64
