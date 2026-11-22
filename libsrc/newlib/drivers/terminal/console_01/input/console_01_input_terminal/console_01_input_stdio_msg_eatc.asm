
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC console_01_input_stdio_msg_eatc

EXTERN character_00_input_stdio_msg_eatc

defc console_01_input_stdio_msg_eatc = character_00_input_stdio_msg_eatc

   ; intended only to be called by stdio
   ; as the disqualified char is ungot at FILE* level
   ;
   ; IX = & FDSTRUCT.JP
   ; HL'= int (*qualify)(char c)
   ; BC'= optional
   ; DE'= optional
   ; HL = max_length = number of stream chars to consume
   ;
   ; return:
   ;
   ; BC = number of bytes consumed from stream
   ; HL = next unconsumed (unmatching) char or EOF
   ; BC'= unchanged by driver
   ; DE'= unchanged by driver
   ; HL'= unchanged by driver
   ; 
   ; carry set on error or eof: if HL=0 stream error, HL=-1 on eof
