SECTION rodata_user

PUBLIC _err_invalid_parameter
PUBLIC _err_invalid_option
PUBLIC _err_break_into_program
PUBLIC _err_multiple_name
PUBLIC _err_missing_filename
PUBLIC _err_file_not_found
PUBLIC _err_loading_error

_err_invalid_parameter:

   defm "A Invalid paramete", 'r' + 0x80

_err_invalid_option:

   defm "Invalid optio", 'n' + 0x80

_err_break_into_program:

   defm "D BREAK - no repea", 't' + 0x80

_err_multiple_name:

   defm "Multiple name", 's' + 0x80

_err_missing_filename:

   defm "F Missing file nam", 'e' + 0x80

_err_file_not_found:

   defm "F File not foun", 'd' + 0x80

_err_loading_error:

   defm "R Loading erro", 'r' + 0x80
