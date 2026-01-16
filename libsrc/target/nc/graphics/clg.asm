;
;   CLS for the Amstrad NC
;   Stefano - 2017
;
;
;	$Id: clg.asm $
;

    SECTION code_clib
    PUBLIC  clg
    PUBLIC  _clg

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
clg:
_clg:
  IF    FORzcn
    ld      e, 1                        ; ^A
    ld      c, 2
    jp      5
  ELSE
    jp      $B824
  ENDIF


