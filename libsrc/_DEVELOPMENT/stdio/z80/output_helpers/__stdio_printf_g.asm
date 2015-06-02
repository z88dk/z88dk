
SECTION code_stdio

PUBLIC __stdio_printf_g

EXTERN dread1, __ftog__, __stdio_printf_float_tail

__stdio_printf_g:

   ; %g, %G converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         hl'= current output tally
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   ex (sp),hl                  ; hl = precision
   
   exx
   
   ex (sp),hl                  ; hl = void *stack_param, save tally
   call dread1                 ; exx set = float x
   
   ex de,hl                    ; hl = buffer *, de = precision
   
   ;  ix = FILE *
   ;  de = precision
   ;  hl = buffer *
   ; exx = float x
   ; stack = buffer *, width, output_tally
   
   ld c,(ix+5)                 ; c = printf flags
   
   bit 0,c
   jr nz, prec_defined
   ld de,6                     ; default precision is six

prec_defined:

   push ix
   call __ftog__               ; generate hexadecimal string
   
   ;     bc = buffer length
   ;     de = buffer *
   ;  stack = buffer *, width, output_tally, FILE *
   ;
   ; (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = ignore
   ;
   ; carry set = special form just output buffer with sign

   jp __stdio_printf_float_tail
