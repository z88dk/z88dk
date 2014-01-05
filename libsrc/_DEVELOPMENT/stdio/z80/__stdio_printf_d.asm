
XLIB __stdio_printf_d
XDEF __stdio_printf_i

LIB __stdio_printf_number_tail, __stdio_printf_number_zero, l_neg_hl, l_utoa

__stdio_printf_d:
__stdio_printf_i:

   ; %d, %i converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   ; read integer to convert
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = integer to convert
   
   or h
   jp z, __stdio_printf_number_zero  ; if integer is zero
   
   ; integer negative ?
   
   bit 7,h
   jr z, positive              ; if integer is positive
   
   set 7,(ix+5)                ; set negative flag
   call l_neg_hl               ; change to positive for conversion
   
positive:

   ; convert integer to ascii buffer
   
   push de                     ; save buffer_digits
   
   call l_utoa                 ; convert integer in hl to ascii digits in buffer at de
   
   pop hl
   ex de,hl                    ; de = buffer_digits
   
   sbc hl,de
   ld c,l
   ld b,h                      ; bc = num_sz = number of digits in ascii string
      
   ; ix = FILE *
   ; bc = num_sz
   ; stack = buffer_digits, width, precision
   
   jp __stdio_printf_number_tail
