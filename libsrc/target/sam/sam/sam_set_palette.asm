

     MODULE  sam_set_palette
     SECTION code_clib

     PUBLIC  sam_set_palette
     PUBLIC  _sam_set_palette

     EXTERN  SAM_PALETTE_VALUES

     INCLUDE "target/sam/def/sam.def"

; void sam_set_palette(int index, int value)
sam_set_palette:
_sam_set_palette:
     ld      hl,2
     add     hl,sp
     ld      e,(hl)
     inc     hl
     inc     hl
     ld      a,(hl)
     and     15
     ld      b,a
     ld      c,CLUT
     out     (c),e
     ld      hl,SAM_PALETTE_VALUES
     ld      c,b
     ld      b,0
     add     hl,bc
     ld      (hl),e
     ret

