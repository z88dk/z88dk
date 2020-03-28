SECTION rodata_user

PUBLIC _err_destination_not_directory
PUBLIC _err_out_of_memory
PUBLIC _err_destination_wrong_type
PUBLIC _err_invalid_parameter
PUBLIC _err_destination_duplicated
PUBLIC _err_invalid_option
PUBLIC _err_destination_contains_wildcards
PUBLIC _err_break_into_program

_err_destination_not_directory:

   defm "DST is not a director", 'y' + 0x80

_err_out_of_memory:

   defm "4 Out of memor", 'y' + 0x80

_err_destination_wrong_type:

   defm "DST found but wrong typ", 'e'+0x80

_err_invalid_parameter:

   defm "A Invalid paramete", 'r' + 0x80

_err_destination_duplicated:

   defm "DST specified twic", 'e' + 0x80

_err_invalid_option:

   defm "Invalid optio", 'n' + 0x80

_err_destination_contains_wildcards:

   defm "DST not resolve", 'd' + 0x80

_err_break_into_program:

   defm "D BREAK - no repea", 't' + 0x80
