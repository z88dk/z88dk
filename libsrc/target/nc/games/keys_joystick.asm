
    SECTION rodata_clib
    PUBLIC  keys_cursor
    PUBLIC  keys_qaop
    PUBLIC  keys_vi
    PUBLIC  keys_8246

keys_cursor:
    defw    $0806, $0800, $0206, $0807, $1000, $0801, $0000, $0000

keys_qaop:
    defw    $0809, $4009, $1004, $0403, $4007, $8006, $0000, $0000

keys_vi:
    defw    $2009, $4006, $4008, $8007, $4003, $8003, $0000, $0000

keys_8246:
IF FORnc200
    defw    $4002, $0400, $0203, $0104, $0209, $1002, $0000, $0000
ELSE
    defw    $0106, $0104, $0203, $0108, $0109, $4001, $0000, $0000
ENDIF
