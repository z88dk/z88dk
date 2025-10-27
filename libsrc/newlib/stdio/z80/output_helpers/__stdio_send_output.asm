
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_send_output
PUBLIC __stdio_send_output_buffer, __stdio_send_output_chars

PUBLIC __stdio_printf_padding_width
PUBLIC __stdio_printf_padding_width_bc, __stdio_printf_padding_width_hl

PUBLIC __stdio_printf_padding_precision
PUBLIC __stdio_printf_padding_precision_bc, __stdio_printf_padding_precision_hl

EXTERN STDIO_MSG_PUTC, STDIO_MSG_WRIT
EXTERN l_jpix, l_addu_hl_bc

; ALL VFPRINTF OUTPUT PASSES THROUGH THESE FUNCTIONS
; HL' IS USED TO TRACK TOTAL NUMBER OF CHARS OUTPUT ON STREAM
;
; OTHER HIGH LEVEL OUTPUT SHOULD USE __STDIO_SEND_OUTPUT_RAW

__stdio_printf_padding_precision_hl:

   ; output length zeroes on stream
   ;
   ; enter : ix  = FILE *
   ;         hl  = length (0 means no output)
   ;         hl' = output tally (num chars output so far)
   ;
   ; exit  : ix  = FILE *
   ;         hl' = output tally (updated)
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix

   ld c,l
   ld b,h
   
   ; fall through

__stdio_printf_padding_precision:
__stdio_printf_padding_precision_bc:

   ; output length zeroes on stream
   ;
   ; enter : ix  = FILE *
   ;         bc  = length (0 means no output)
   ;         hl' = output tally (num chars output so far)
   ;
   ; exit  : ix  = FILE *
   ;         hl' = output tally (updated)
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix

   ld e,'0'
   jr __stdio_send_output_chars

__stdio_printf_padding_width_hl:

   ; output length spaces on stream
   ;
   ; enter : ix  = FILE *
   ;         hl  = length (0 means no output)
   ;         hl' = output tally (num chars output so far)
   ;
   ; exit  : ix  = FILE *
   ;         hl' = output tally (updated)
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix

   ld c,l
   ld b,h
   
   ; fall through

__stdio_printf_padding_width:
__stdio_printf_padding_width_bc:

   ; output length spaces on stream
   ;
   ; enter : ix  = FILE *
   ;         bc  = length (0 means no output)
   ;         hl' = output tally (num chars output so far)
   ;
   ; exit  : ix  = FILE *
   ;         hl' = output tally (updated)
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix

   ld e,' '

   ; fall through

__stdio_send_output_chars:

   ; write char to output length times
   ;
   ; enter : ix  = FILE *
   ;          e  = char c
   ;         bc  = length (0 means no output)
   ;         hl' = output tally (num chars output so far)
   ;
   ; exit  : ix  = FILE *
   ;         hl' = output tally (updated)
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix
   
   ld a,b
   or c
   ret z
   
   ld a,STDIO_MSG_PUTC
   jr __stdio_send_output

__stdio_send_output_buffer:

   ; write buffer to stream
   ;
   ; enter : ix  = FILE *
   ;         hl  = char *buffer
   ;         bc  = length (0 means no output)
   ;         hl' = output tally (num chars output so far)
   ;
   ; exit  : ix  = FILE *
   ;         hl' = output tally (updated)
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix
   
   ld a,b
   or c
   ret z
   
   ld a,STDIO_MSG_WRIT
   
   ; fall through

__stdio_send_output:

   ; write chars to stream
   ; all output from vfprintf passes through this function
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
   
   call l_addu_hl_bc           ; update tally
   or a                        ; no error

exit:

   push hl
   exx
   pop hl                      ; hl' = updated output tally
   exx
   
   ret
   
error_detected:
   
   set 3,(ix+3)                ; set stream error indicator

   ; update tally and exit with error indicator on
   
   call l_addu_hl_bc           ; update tally
   
   scf                         ; indicate stream error
   jr exit
