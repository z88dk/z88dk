;
;    CPM Stdio
;
;    getkey() Wait for keypress
;
;    Stefano Bodrato - Apr. 2000
;    Stefano Bodrato - Mar. 2004 - removed the BS trick
;
;
;    $Id: fgetc_cons.asm,v 1.9 2016-07-22 09:45:18 dom Exp $
;

    SECTION code_clib

    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons

    EXTERN  __bdos

.fgetc_cons
._fgetc_cons

    ld      c,6
    ld      e,255
    call    __bdos
    and     a
    jr      Z,fgetc_cons
IF STANDARDESCAPECHARS
    cp      13
    ld      hl,10
    ret     Z
    cp      10
    ld      hl,13
    ret     Z
ENDIF
    ld      l,a
    ld      h,0
    ret
