
    SECTION rodata_clib
    PUBLIC  keys_cursor
    PUBLIC  keys_qaop
    PUBLIC  keys_vi
    PUBLIC  keys_8246

keys_cursor:
    defw    $4004, $4003, $4005, $4006, $4007, $4002, 0, 0

keys_qaop:
    defw    $0103, $0105, $0802, $1002, $0203, $0407, 0, 0

keys_vi:
    defw    $0202, $0807, $0205, $0204, $0803, $0804, 0, 0

keys_8246:
    defw    $2007, $2005, $2003, $0107, $0102, $2006, 0, 0
