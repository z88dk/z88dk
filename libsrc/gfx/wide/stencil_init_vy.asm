;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;	Set/Reset the couple of vectors being part of a "stencil"
;	Basic concept by Rafael de Oliveira Jannone (calculate_side)
;
;		This version uses 'wide' sized vectors but allocates a variable space on SP
;		depending on getmaxy()
;
;       Stefano Bodrato - 13/3/2009
;
;
;	$Id: stencil_init_vy.asm $
;

  IF    !__CPU_INTEL__
        INCLUDE "graphics/grafix.inc"
        SECTION code_graphics

        PUBLIC  stencil_init
        PUBLIC  _stencil_init

        EXTERN  getmaxy


stencil_init:
_stencil_init:
		; __FASTCALL__ means no need to pick HL ptr from stack

        push    hl

        call    getmaxy
        inc     hl                      ; maxy+1 = vector size for one side
        add     hl, hl                  ; HL = total stencil size

        pop     de
        push    hl                      ; maxy*2

        ld      h, d                    ; hl=de=vector ptr
        ld      l, e
        inc     de

        ld      (hl), 127               ; big enough but stay in the positive range !
        pop     bc                      ; maxy*2
        push    bc
        ldir


        ld      (hl), 0                 ; right side vector follows
        pop     bc
        dec     bc                      ; (maxy*2)-1
        ldir
        ret
  ENDIF
