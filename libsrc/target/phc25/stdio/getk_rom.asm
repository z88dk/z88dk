;
;	stdio - Sanyo PHC-25
;
;	getk_rom(), Read key status
;
;
;	$Id: getk_rom.asm $
;

    SECTION code_clib
    PUBLIC  getk_rom
    PUBLIC  _getk_rom

getk_rom:
_getk_rom:
    ld      h, 0
    ld      a, ($F95C)
    ld      l, a

  IF    STANDARDESCAPECHARS
    cp      13
    jr      nz, not_return
    ld      l, 10
not_return:
  ENDIF

    cp      29
    jr      nz, nobs
    ld      l, 8
nobs:

    xor     a
    ld      ($F95C), a
    ret
