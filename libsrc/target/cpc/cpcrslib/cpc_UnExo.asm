;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
;
;       set color palette, flashing is useless so we forget the second color
;
;       void __LIB__ __CALLEE__ cpc_UnExo(int src, int dst);
;
;       $Id: cpc_UnExo.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_UnExo
        PUBLIC    _cpc_UnExo
        EXTERN     asm_cpc_UnExo

.cpc_UnExo
._cpc_UnExo
;Exomizer 2 Z80 decoder
; by Metalbrain
;
; compression algorithm by Magnus Lind

;input  	hl=compressed data start
;		de=uncompressed destination start
;
;		you may change exo_mapbasebits to point to any free buffer
pop af
pop de
pop hl
push hl
push de
push af

	di
        call asm_cpc_UnExo
	ei
	ret
  
