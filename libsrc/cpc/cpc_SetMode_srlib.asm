;
;       Amstrad CPC library
;       Set mode directly (no firmware)
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_SetMode_srlib.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SetMode
        PUBLIC    _cpc_SetMode
        
        EXTERN firmware

        INCLUDE "target/cpc/def/cpcfirm.def"              


.cpc_SetMode
._cpc_SetMode
  ld a,l
  LD BC,$7F00          ;Gate array port
  LD D,@10001100	   ;Mode  and  rom  selection  (and Gate Array function)
  ADD D
  OUT (C),A  
  RET

