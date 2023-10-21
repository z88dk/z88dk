; Dummy file libs
;

        SECTION code_clib
        PUBLIC  rename
        PUBLIC  _rename
        PUBLIC  ___rename

rename:
_rename:
___rename:
        ld      hl, -1                  ;error
        ret
