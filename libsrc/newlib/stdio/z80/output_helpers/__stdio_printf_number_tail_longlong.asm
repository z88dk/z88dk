
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_number_tail_longlong
PUBLIC __stdio_printf_number_tail_ulonglong

EXTERN l_testzero_64_mhl, l_neg_64_mhl, l_load_64_dehldehl_mbc
EXTERN asm1_ulltoa, __stdio_printf_number_tail, __stdio_printf_number_tail_zero


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
   jr z, signed_join           ; if positive
   
   set 7,(ix+5)                ; set negative flag
   
   pop hl                      ; hl = stack_param
   push hl
   
   call l_neg_64_mhl           ; make positive for conversion
   
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

   pop hl

   ; ix = FILE*
   ; bc = base
   ; de = void *buffer_digits
   ; hl = stack_param
   ; stack = buffer_digits, width, precision
   
   exx
   push bc
   push de
   push hl
   exx
   
   push de                     ; save buffer_digits
   push de                     ; save buffer_digits
   push bc                     ; save radix
   
   ld c,l
   ld b,h                      ; bc = stack param
   
   call l_load_64_dehldehl_mbc ; dehl'dehl = num
   
   pop bc                      ; bc = radix
   ex (sp),ix                  ; ix = buffer_digits
   
   ; dehl'dehl = number
   ; bc = radix
   ; ix = buffer_digits
   ; stack = ..., buffer_digits, FILE*
   
   call asm1_ulltoa
   
   pop ix                      ; ix = FILE*
   pop de                      ; de = buffer_digits
   
   exx
   pop hl
   pop de
   pop bc
   exx
   
   jp __stdio_printf_number_tail
   

zero:

   pop hl
   
   ld l,a
   ld h,a
   
   jp __stdio_printf_number_tail_zero
