
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC console_01_input_stdio_msg_getc

EXTERN console_01_input_proc_getc

defc console_01_input_stdio_msg_getc = console_01_input_proc_getc

   ; enter : ix = & FDSTRUCT.JP
   ;
   ; exit  : success
   ;
   ;            a = hl = char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0 on stream error, -1 on eof
   ;            carry set
   ;
   ; uses  : af, hl
