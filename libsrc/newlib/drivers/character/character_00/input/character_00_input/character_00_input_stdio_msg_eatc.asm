
SECTION code_driver
SECTION code_driver_character_input

PUBLIC character_00_input_stdio_msg_eatc

EXTERN STDIO_MSG_GETC, l_jphl, l_jpix

character_00_input_stdio_msg_eatc:

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

   ld c,l
   ld b,h                      ; bc = max number of chars to consume
   
   ld de,-1                    ; de = num chars consumed - 1

eatc_loop:

   inc de                      ; de = num chars consumed thus far
   
   ; bc = max number of chars to consume
   ; de = number of chars consumed thus far
   
   push bc
   push de
   
   ld a,STDIO_MSG_GETC
   call l_jpix                 ; hl = char
   
   pop de
   pop bc
   
   jr c, eatc_exit             ; if driver error
   
   ld a,b
   or c
   jr z, eatc_exit             ; if max num chars reached

   dec bc                      ; num chars remaining -= 1
   
   ld a,l                      ; a = char
   exx
   call l_jphl                 ; qualify(a)
   exx

   jr nc, eatc_loop            ; if char was accepted by state machine
   ccf                         ; rejection by state machine is not an error

eatc_exit:

   ; de = number of chars consumed from the stream
   ; hl = next unconsumed char
   
   ld c,e
   ld b,d                      ; bc = num chars consumed
   
   ret
