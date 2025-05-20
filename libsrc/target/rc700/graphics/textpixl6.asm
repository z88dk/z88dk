;
;
;	Support char table (pseudo graph symbols) for the RC700
;	Version for the 2x3 graphics symbols
;	Sequence: blank, top-left, top-right, top-half, medium-left, top-left + medium-left, etc..
;
;	$Id: textpixl6.asm $
;
;

    SECTION rodata_clib
    PUBLIC  textpixl


textpixl:
    defb    $20, $21, $22, $23, $24, $25, $26, $27
    defb    $28, $29, $2A, $2B, $2C, $2D, $2E, $2F
    defb    $30, $31, $32, $33, $34, $35, $36, $37
    defb    $38, $39, $3A, $3B, $3C, $3D, $3E, $3F
	
    defb    $60, $61, $62, $63, $64, $65, $66, $67
    defb    $68, $69, $6A, $6B, $6C, $6D, $6E, $6F
    defb    $70, $71, $72, $73, $74, $75, $76, $77
    defb    $78, $79, $7A, $7B, $7C, $7D, $7E, $7F


