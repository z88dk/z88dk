SECTION rodata_user

PUBLIC _err_out_of_memory
PUBLIC _err_invalid_argument
PUBLIC _err_destination_duplicated
PUBLIC _err_break_into_program
PUBLIC _err_destination_not_directory
PUBLIC _err_invalid_option
PUBLIC _err_destination_contains_wildcards

_err_out_of_memory:

   defm "4 Out of memor", 'y' + 0x80

_err_invalid_argument:

   defm "A Invalid argumen", 't' + 0x80

_err_destination_duplicated:

   defm "Destination duplicate", 'd' + 0x80

_err_break_into_program:

   defm "D BREAK - no repea", 't' + 0x80

_err_destination_not_directory:

   defm "Destination not a di", 'r' + 0x80

_err_invalid_option:

   defm "Invalid optio", 'n' + 0x80

_err_destination_contains_wildcards:

   defm "Destination not resolve", 'd' + 0x80
