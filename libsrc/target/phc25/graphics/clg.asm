;
; Override for clg() on PHC-25
;
; If we're in mode 0, fill the screen with black


SECTION code_clib

PUBLIC clg
PUBLIC _clg
EXTERN __mc6847_mode
EXTERN  generic_console_cls

INCLUDE "target/phc25/def/phc25.def"

clg:
_clg:
    ld      a,(__mc6847_mode)
    and     a 
    jp      nz,generic_console_cls
    ld      hl,DISPLAY
    ld      de,DISPLAY+1
    ld      bc,512
    ld      (hl),0
    ldir
    ld      hl,DISPLAY+0x800
    ld      de,DISPLAY+0x800+1
    ld      bc,512
    ld      (hl),@10000010          ;Turn on semigraphics mode
    ldir
    ret

