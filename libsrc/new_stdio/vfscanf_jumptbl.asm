; lookup table for input scan converters
; 05.2008 aralbrec

XLIB vfscanf_jumptbl

; scan converters: "[bcdeEfFionpPsuxX"
; place most common first

.vfscanf_jumptbl

   defb 'd', 195
   LIB stdio_in_d
   defw stdio_in_d
   
   defb 's', 195
   LIB stdio_in_s
   defw stdio_in_s
   
   defb 'i', 195
   LIB stdio_in_i
   defw stdio_in_i
   
   defb 'c', 195
   LIB stdio_in_c
   defw stdio_in_c
   
   defb 'u', 195
   LIB stdio_in_d
   defw stdio_in_d

   defb '[', 195
   LIB stdio_in_bkt
   defw stdio_in_bkt

   defb 'x', 195
   LIB stdio_in_x
   defw stdio_in_x
 
   defb 'n', 195
   LIB stdio_in_n
   defw stdio_in_n

   defb 'o', 195
   LIB stdio_in_o
   defw stdio_in_o
     
   defb 'b', 195
   LIB stdio_in_b
   defw stdio_in_b
   
   defb 'p', 195
   LIB stdio_in_x
   defw stdio_in_x
   
   defb 'X', 195
   LIB stdio_in_x
   defw stdio_in_x

   defb 'P', 195
   LIB stdio_in_x
   defw stdio_in_x
   
;   defb 'f', 195
;   defw
   
;   defb 'e', 195
;   defw
   
;   defb 'F', 195
;   defw
   
;   defb 'E', 195
;   defw
   
   defb 0                      ; end of table
