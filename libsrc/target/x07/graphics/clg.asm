


    SECTION code_clib

    PUBLIC  clg
    PUBLIC  _clg

    EXTERN  __x07_buffer

    INCLUDE "target/x07/def/x07.h"

clg:
_clg:
    ld      a,SUB_CLS
    jp      SUB_EXEC_CMD

