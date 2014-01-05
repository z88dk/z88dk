
XLIB __stdio_send_output

LIB l_jpix

__stdio_send_output:

   ; write chars to stream
   ; all output from high level stdio passes through this function
   ;
   ; enter : ix  = FILE *
   ;         hl' = output tally (num chars output so far) 
   ;
   ;         if output repeated char
   ;
   ;            a = STDIO_MSG_PUTC
   ;           bc = length > 0
   ;            e = char
   ;
   ;         if output buffer
   ;
   ;            a = STDIO_MSG_WRIT
   ;           bc = length > 0
   ;           hl = void *buffer
   ;
   ;         NOTE : hl' used by high level stdio to track chars output
   ;
   ; exit  : ix  = FILE *
   ;         hl' = updated output tally
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix
   
   push bc
   exx
   ex (sp),hl
   
   ; ix = FILE *
   ; hl = length
   ; STDIO_MSG params in EXX set
   ; stack = output tally
   
   call l_jpix                 ; output chars to file

   push hl                     ; careful not to alter more exx registers
   exx                         ; this is done to speed up sprintf()
   pop hl
   pop bc
   
   ; ix = FILE *
   ; bc = output tally
   ; hl = num chars successfully output
   ; carry set if error occurred
   
   jr c, error_detected
   
   add hl,bc                   ; update tally
   jr c, saturate_nc           ; if tally wrapped

exit:

   push hl
   exx
   pop hl                      ; hl' = updated output tally
   exx
   
   ret

saturate_nc:

   or a                        ; no stream error

saturate:

   ld hl,$ffff                 ; tally saturates
   jr exit
   
error_detected:
   
   set 3,(ix+3)                ; set stream error indicator

   ; update tally and exit with error indicator on
   
   add hl,bc                   ; update tally
   jr c, saturate              ; if tally wrapped (carry is set)
   
   ; tally ok
   
   scf                         ; indicate stream error
   jr exit
