        SECTION code_clib

        PUBLIC  fsync
        PUBLIC  _fsync

fsync:
_fsync:
        ld      hl, -1                  ;return -1
        ret

