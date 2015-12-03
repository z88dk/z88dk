
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_g

EXTERN __dtog__, __stdio_printf_float_tail

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

   ; snprintf requires bc',de' to be preserved

   pop bc                      ; bc = precision
   ex (sp),hl                  ; hl = width
   
   exx

   ex (sp),hl                  ; save tally, hl = stack_param *
   push de                     ; save snprintf variable
   push bc                     ; save snprintf variable
   
   ex de,hl
   
   ld hl,-65
   add hl,sp
   ld sp,hl
   
   ex de,hl
   
   push ix

   IF __SDCC | __SDCC_IX | SDCC_IY
   
      EXTERN dload
      call dload               ; exx set = double x
   
   ELSE
   
      EXTERN dloadb
      call dloadb              ; exx set = double x

   ENDIF

   ; exx occurred

   push hl                     ; save width
   ex de,hl                    ; hl = void *buffer_digits
   
   ld e,c
   ld d,b                      ; de = precision
   
   ;  de = precision
   ;  hl = buffer *
   ;  ix = FILE *
   ; exx = double x
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, FILE *, width
   
   ld c,(ix+5)                 ; c = printf flags
   
   bit 0,c
   jr nz, prec_defined
   ld de,6                     ; default precision is six

prec_defined:

   call __dtog__               ; generate hexadecimal string
   
   ;     bc = workspace length
   ;     de = workspace *
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, FILE *, width
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
