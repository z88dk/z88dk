; $Id: fsync.asm,v 1.4 2016-03-06 21:39:54 dom Exp $

        SECTION code_clib

        PUBLIC  fsync
        PUBLIC  _fsync

fsync:
_fsync:
        ld      hl, -1                  ;return -1
        ld      d, h
        ld      e, l
        ret

