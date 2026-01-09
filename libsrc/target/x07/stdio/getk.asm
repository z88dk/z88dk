;
;	Keyboard routines for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

    SECTION code_clib
    PUBLIC  getk
    PUBLIC  _getk

    INCLUDE "target/x07/def/x07.h"

getk:
_getk:
    xor     a
    call    $C90A
    ld      hl,0
    ret     z
    ld      l,a
    push    hl
    ld      a,SUB_KBD_CLEAR
    call    SUB_EXEC_CMD
    pop     hl
    ret
