
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_number_tail_int
PUBLIC __stdio_printf_number_tail_uint

EXTERN __stdio_nextarg_hl, asm1_utoa, l_neg_hl
EXTERN __stdio_printf_number_tail, __stdio_printf_number_tail_zero


__stdio_printf_number_tail_int:

   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         bc = base
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   ; read integer to convert
   
   call __stdio_nextarg_hl     ; hl = int
   
   or h
   jp z, __stdio_printf_number_tail_zero  ; if unsigned int is zero
   
   ; integer negative ?
   
   bit 7,h
   jr z, signed_join           ; if integer is positive
   
   set 7,(ix+5)                ; set negative flag
   call l_neg_hl               ; change to positive for conversion
   
   jr signed_join


__stdio_printf_number_tail_uint:

   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         bc = base
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   ; read unsigned int to convert
   
   call __stdio_nextarg_hl     ; hl = unsigned int

   or h
   jp z, __stdio_printf_number_tail_zero  ; if unsigned int is zero

signed_join:

   ; write unsigned int to ascii buffer
   
   push de                     ; save buffer_digits
   push ix
   
   ld a,c
   call asm1_utoa              ; general conversion with special cases for base 2,8,10,16

   pop ix
   pop de

   jp __stdio_printf_number_tail
