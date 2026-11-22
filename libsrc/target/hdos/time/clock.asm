;
;	clock()
;

    SECTION code_clib
    PUBLIC  clock
    PUBLIC  _clock

clock:
_clock:
    ld      hl, ($201B) ; 2ms tick counter
    ld      de, 0
    ret
