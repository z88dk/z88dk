
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_number_tail_long
PUBLIC __stdio_printf_number_tail_ulong

EXTERN __stdio_nextarg_de, __stdio_nextarg_hl, asm1_ultoa, l_neg_dehl
EXTERN __stdio_printf_number_tail, __stdio_printf_number_tail_zero


__stdio_printf_number_tail_long:

   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         bc = base
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   push de                     ; save buffer_digits

   ; read long to convert
   
   call __stdio_nextarg_de     ; de = MSW of long
   call __stdio_nextarg_hl     ; hl = LSW of long
      
   or h
   or e
   or d
   jr z, zero                  ; if integer is zero

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   ex de,hl                    ; dehl = long

;******************************
ENDIF
;******************************

   ; integer negative ?
   
   bit 7,d
   jr z, signed_join           ; if integer is positive
   
   set 7,(ix+5)                ; set negative flag
   call l_neg_dehl             ; change to positive for conversion

   jr signed_join


__stdio_printf_number_tail_ulong:

   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         bc = base
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   push de                     ; save buffer digits
   
   ; read unsigned long to convert
   
   call __stdio_nextarg_de     ; de = MSW of long
   call __stdio_nextarg_hl     ; hl = LSW of long
   
   or h
   or e
   or d
   jr z, zero                  ; if long is zero

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   ex de,hl                    ; dehl = long

;******************************
ENDIF
;******************************

signed_join:

   ; write unsigned long to ascii buffer

   ex (sp),ix                  ; ix = buffer_digits
   
   exx
   push bc
   push de
   push hl
   exx
   
   ld a,c
   call asm1_ultoa

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

   pop de
   jp __stdio_printf_number_tail_zero
