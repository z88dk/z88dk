;; workspace in main ram above ramtop

defc BUFFER_SIZE = 16384   ;; must be consistent with dzx7.c

SECTION IGNORE
org 65536 - BUFFER_SIZE*2

PUBLIC _input_data
PUBLIC _output_data

_input_data:   defs BUFFER_SIZE
_output_data:  defs BUFFER_SIZE
