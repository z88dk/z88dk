;
;
;	Support char table (pseudo graph symbols) for the Heath/Zenith H19 terminal
;	Version for the 1x3 graphics symbols
;	Sequence: blank, top, half, top+half, bottom, etc..
;
;	NOTE: there's no point really to use a table on the TRS80,
;	      it is only a very quick way to get the result.
;
;	$Id: textpixl3.asm $
;
;


	PUBLIC	textpixl


.textpixl
		defb	' '
		defb	'z', 'a', 'p'  ; '{'+128
		defb	'{', 'a'+128, 'p'+128  ; 'z'+128
		defb	' '+128

