
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_number_tail_longlong
PUBLIC __stdio_printf_number_tail_ulonglong

EXTERN l_testzero_64_mhl, l_neg_64_mhl, asm1_ulltoa
EXTERN __stdio_printf_number_tail, __stdio_printf_number_tail_zero


__stdio_printf_number_tail_longlong:

   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         bc = base
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   push hl                     ; save stack_param
   
   ; test longlong for zero
   
   call l_testzero_64_mhl
   jr z, zero
   
   ; integer negative ?
   
   dec hl
   
   bit 7,(hl)
   jr z, signed_join           ; if integer is positive
   
   set 7,(ix+5)                ; set negative flag
   
   pop hl
   push hl
   
   call l_neg_64_mhl           ; change to positive for conversion
   jr signed_join


__stdio_printf_number_tail_ulonglong:

   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         bc = base
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   push hl                     ; save stack_param
   
   ; test longlong for zero
   
   call l_testzero_64_mhl
   jr z, zero

signed_join:

   ; write unsigned longlong to ascii buffer

   ex (sp),ix
   
   ; bc = base
   ; de = void *buffer_digits
   ; ix = & number
   ; stack = buffer_digits, width, precision, FILE*

   exx
   push bc
   push de
   push hl
   exx
   
   call asm1_ulltoa

   exx
   pop hl
   pop de
   pop bc
   exx
   
   push ix
   pop de                      ; de = buffer_digits
   
   pop ix
   jp __stdio_printf_number_tail

zero:

   pop hl
   
   ld l,a
   ld h,a
   
   jp __stdio_printf_number_tail_zero
