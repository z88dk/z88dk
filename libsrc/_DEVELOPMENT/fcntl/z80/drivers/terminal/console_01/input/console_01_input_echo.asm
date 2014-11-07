
SECTION seg_code_fcntl

PUBLIC console_01_input_echo, console_01_input_oterm

EXTERN ITERM_MSG_PUTC, l_jpix, CHAR_PASSWORD

console_01_input_echo:

   ; a = char to output to oterm
   
   bit 7,(ix+6)
   ret z                         ; if echo off
   
   ld c,a
   ld a,ITERM_MSG_PUTC
   
   bit 6,(ix+6)
   jr z, console_01_input_oterm  ; if not password mode
   
   ld c,CHAR_PASSWORD

console_01_input_oterm:

   ;  a = message to output terminal
   ; bc = parameter
   ; de = parameter
   ; ix = & FDSTRUCT.JP (input terminal)
   
   ld l,(ix+14)
   ld h,(ix+15)                ; hl = FDSTRUCT *oterm
   
   ld a,h
   or l
   ret z                       ; silently fail if output terminal is not connected
   
   push hl
   ex (sp),ix                  ; ix = FDSTRUCT *oterm
   
   call l_jpix                 ; deliver message to oterm
   
   pop ix                      ; ix = & FDSTRUCT.JP (input terminal)
   ret
