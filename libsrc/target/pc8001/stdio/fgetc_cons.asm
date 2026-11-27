;
;	NEC PC8001 Library
;
;	getkey() Wait for keypress
;
;
;
;

    SECTION code_clib
    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons

    EXTERN  getk



fgetc_cons:
_fgetc_cons:
    push    ix
	;call	CHGET
wkey:
;	call 3241h
;	jr nc,wkey
    call    getk
    and     a
    jr      nz, wkey
wkey1:
    call    getk
    and     a
    jr      z, wkey1

    pop     ix

  IF    STANDARDESCAPECHARS
    cp      13
    jr      nz, not_return
    ld      a, 10
not_return:
  ENDIF

    ld      l, a
    ld      h, 0
    ret
