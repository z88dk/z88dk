;
;	Sharp MZ-800 Routines
;
;	getk() Read key status: the code of a key that is down, 0 if none
;
    SECTION code_clib
    PUBLIC  getk
    PUBLIC  _getk
    EXTERN  in_Inkey

getk:
_getk:
    call    in_Inkey
    ld      a, l
    jr      nc, got_key
    xor     a
got_key:
    cp      13                          ; was it ENTER ?
    jr      nz, noenter
  IF    STANDARDESCAPECHARS
    ld      a, 10
  ENDIF
noenter:
    ld      l, a
    ld      h, 0
    ret
