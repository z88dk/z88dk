; The key matrix (rows 2 to 12, 7 keys a row, bits 0 to 6) as ASCII, for in_LookupKey: plain and with shift.  The tables are getk's.

    SECTION code_clib
    PUBLIC  in_keytranstbl
    PUBLIC  in_keytranstbl_shift
    PUBLIC  in_keytranstbl_len

    defc    in_keytranstbl_len = 77

    INCLUDE "../stdio/getk_table.inc"

    defc    in_keytranstbl = keymap_plain
    defc    in_keytranstbl_shift = keymap_shift
