
SECTION code_stdio

PUBLIC __stdio_printf_float_tail

EXTERN 

__stdio_printf_float_tail:

   ;     bc = workspace length
   ;     de = workspace *
   ;  stack = buffer *, width, output_tally, FILE *
   ;
   ; (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = ignore
   ;
   ; carry set = special form just output buffer with sign

   ex af,af'                   ; carry'= special form

   push de                     ; save workspace *
   
   call __ftoa_count           ; hl = num_chars
   
   ld a,(ix-5)                 ; a = printf flags

   pop de                      ; de = workspace *
   pop ix                      ; ix = FILE *

   ld (ix+5),a                 ; store printf flags
   
   exx
   pop hl                      ; hl'= output tally
   exx
   
   ; bc = workspace length
   ; de = workspace *
   ; hl = num_chars
   ; ix = FILE *
   ; hl'= output tally
   ; carry' = special form
   ; stack  = buffer *, width
   
   