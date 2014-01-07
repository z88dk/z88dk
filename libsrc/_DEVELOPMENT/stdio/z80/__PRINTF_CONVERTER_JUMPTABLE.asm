
XLIB __PRINTF_CONVERTER_JUMPTABLE

__PRINTF_CONVERTER_JUMPTABLE:

   defb 'd', 195
   defw 
   
   defb 's', 195
   defw 

   defb 'c', 195
   defw 
   
   defb 'u', 195
   defw 
   
   defb 'x', 195
   defw 
   
   defb 'X', 195
   defw 
   
   defb 'i', 195
   defw 
   
   defb 'n', 195
   defw 
   
   defb 'I', 195
   defw 
   
   defb 'p', 195
   defw 
   
   defb 'o', 195
   defw 
   
   defb 'b', 195
   defw 
   
   defb 0

;;;IN:

   ; de = address of next format char to examine
   ;  c = length modifier id
   ; stack = width, precision, stack_param

;;;OUT:

   ; ix = FILE *
   ; hl = void *stack_param
   ; de = void *buffer_digits
   ; stack = buffer_digits, width, precision
