;
;	Sharp MZ-800 Routines
;
;	fgetc_cons() Wait for a key: its code (as getk, after the key has been let go of)
;
    SECTION code_clib
    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons
    EXTERN  in_Inkey

fgetc_cons:
_fgetc_cons:
wait_up:
    call    in_Inkey                    ; (a key still down from before: wait for it to go)
    jr      nc, wait_up
wait_down:
    call    in_Inkey
    jr      c, wait_down
    ld      a, l
    cp      13                          ; was it ENTER ?
    jr      nz, noenter
  IF    STANDARDESCAPECHARS
    ld      a, 10
  ENDIF
noenter:
    ld      l, a
    ld      h, 0
    ret
