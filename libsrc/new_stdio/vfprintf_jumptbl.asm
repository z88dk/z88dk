; lookup table for output format specifiers
; 05.2008 aralbrec

XLIB vfprintf_jumptbl

; output format specifiers: "bcdeEfFinopPsuxX"
; place most common first

.vfprintf_jumptbl

   defb 'd', 195
   LIB stdio_out_d
   defw stdio_out_d
   
   defb 'c', 195
   LIB stdio_out_c
   defw stdio_out_c
   
   defb 's', 195
   LIB stdio_out_s
   defw stdio_out_s
   
   defb 'u', 195
   LIB stdio_out_u
   defw stdio_out_u
   
   defb 'x', 195
   LIB stdio_out_x
   defw stdio_out_x
   
   defb 'i', 195
   LIB stdio_out_d
   defw stdio_out_d
   
;   defb 'X', 195
;   defw
   
   defb 'b', 195
   LIB stdio_out_b
   defw stdio_out_b
   
   defb 'o', 195
   LIB stdio_out_o
   defw stdio_out_o
   
   defb 'p', 195
   LIB stdio_out_p
   defw stdio_out_p
   
;   defb 'P', 195
;   defw
   
   defb 'n', 195
   LIB stdio_out_n
   defw stdio_out_n
   
;   defb 'f', 195
;   defw
   
;   defb 'e', 195
;   defw
   
;   defb 'F', 195
;   defw
   
;   defb 'E', 195
;   defw
   
   defb 0                      ; end of table
 