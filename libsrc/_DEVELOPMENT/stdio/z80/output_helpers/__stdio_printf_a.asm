
SECTION code_stdio

PUBLIC __stdio_printf_a

EXTERN dread1b, __ftoh__, __stdio_printf_float_tail

__stdio_printf_a:

   ; %a, %A converter called from vfprintf()
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
   
   pop de
   pop bc
   pop af
   
   push hl
   
   ld hl,-65
   add hl,sp
   ld sp,hl
   
   push ix
   push bc
   
   ex de,hl                    ; hl = void *stack_param
   call dread1b                ; exx set = float x
   
   ex de,hl                    ; hl = buffer *, de = precision
   
   ;  de = precision
   ;  hl = buffer *
   ;  ix = FILE *
   ; exx = float x
   ; stack = tally, BUFFER_65, FILE *, width
   
   ld c,(ix+5)                 ; c = printf flags
   
   bit 0,c
   jr nz, prec_defined
   ld e,255                    ; default precision selects max significant digits

prec_defined:

   call __ftoh__               ; generate hexadecimal string
   
   ;     bc = workspace length
   ;     de = workspace *
   ; stack = tally, BUFFER_65, FILE *, width
   ;
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer
   ;
   ; carry set = special form just output buffer with sign

   jp __stdio_printf_float_tail
