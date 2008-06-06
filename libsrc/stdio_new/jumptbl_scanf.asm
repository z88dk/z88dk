; lookup table for input scan converters
; 05.2008 aralbrec

XLIB jumptbl_scanf

; scan converters: "[bcdeEfFionpPsuxX"
; place most common first

.jumptbl_scanf

   defb 'd', 195
   LIB stdio_in_ld
   defw stdio_in_ld
   
   defb 's', 195
   LIB stdio_in_s
   defw stdio_in_s
   
   defb 'i', 195
   LIB stdio_in_li
   defw stdio_in_li
   
   defb 'c', 195
   LIB stdio_in_c
   defw stdio_in_c
   
   defb 'u', 195
   LIB stdio_in_ld
   defw stdio_in_ld

   defb '[', 195
   LIB stdio_in_bkt
   defw stdio_in_bkt

   defb 'x', 195
   LIB stdio_in_lx
   defw stdio_in_lx
 
   defb 'n', 195
   LIB stdio_in_n
   defw stdio_in_n

   defb 'o', 195
   LIB stdio_in_lo
   defw stdio_in_lo
     
   defb 'b', 195
   LIB stdio_in_lb
   defw stdio_in_lb
   
   defb 'p', 195
   LIB stdio_in_lx
   defw stdio_in_lx
   
   defb 'X', 195
   LIB stdio_in_lx
   defw stdio_in_lx

   defb 'P', 195
   LIB stdio_in_lx
   defw stdio_in_lx
   
;   defb 'f', 195
;   defw
   
;   defb 'e', 195
;   defw
   
;   defb 'F', 195
;   defw
   
;   defb 'E', 195
;   defw
   
   defb 0                      ; end of table
