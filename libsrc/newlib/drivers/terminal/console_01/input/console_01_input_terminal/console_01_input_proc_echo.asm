
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC console_01_input_proc_echo, console_01_input_proc_oterm

EXTERN l_jpix

console_01_input_proc_echo:

   ; a = char to output to oterm
   
   bit 7,(ix+6)
   ret z                         ; if echo off
   
   ld c,a
   ld a,ITERM_MSG_PUTC
   
   bit 6,(ix+6)
   jr z, console_01_input_proc_oterm  ; if not password mode
   
   ld c,CHAR_PASSWORD

console_01_input_proc_oterm:

   ;  a = message to output terminal
   ; bc = parameter
   ; de = parameter
   ; ix = & FDSTRUCT.JP (input terminal)
   
   ld l,(ix+14)
   ld h,(ix+15)                ; hl = FDSTRUCT *oterm
      
   inc h
   dec h
   jr nz, cont
   
   inc l
   dec l
   ret z                       ; silently fail if output terminal is not connected

cont:
   
   push hl
   ex (sp),ix                  ; ix = FDSTRUCT *oterm
   
   call l_jpix                 ; deliver message to oterm
   
   pop ix                      ; ix = & FDSTRUCT.JP (input terminal)
   ret
