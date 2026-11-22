SECTION rodata_user

PUBLIC _err_out_of_memory
PUBLIC _err_invalid_parameter
PUBLIC _err_invalid_option
PUBLIC _err_break_into_program
PUBLIC _err_depth_order

_err_out_of_memory:

   defm "4 Out of memor", 'y' + 0x80

_err_invalid_parameter:

   defm "A Invalid paramete", 'r' + 0x80

_err_invalid_option:

   defm "Invalid optio", 'n' + 0x80

_err_break_into_program:

   defm "D BREAK - no repea", 't' + 0x80

_err_depth_order:

   defm "Depth order invali", 'd' + 0x80
