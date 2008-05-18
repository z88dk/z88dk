; lookup table for output format specifiers
; 05.2008 aralbrec

XLIB vfprintf_jumptbl

; output format specifiers: "bcdeEfFinopPsuxX"
; place most common first

.vfprintf_jumptbl

   defb 'd', 195
   LIB stdio_out_ld
   defw stdio_out_ld
   
   defb 'c', 195
   LIB stdio_out_c
   defw stdio_out_c
   
   defb 's', 195
   LIB stdio_out_s
   defw stdio_out_s
   
   defb 'u', 195
   LIB stdio_out_lu
   defw stdio_out_lu
   
   defb 'x', 195
   LIB stdio_out_lx
   defw stdio_out_lx
   
   defb 'i', 195
   LIB stdio_out_ld
   defw stdio_out_ld
   
   defb 'X', 195
   LIB stdio_out_caplx
   defw stdio_out_caplx
   
   defb 'b', 195
   LIB stdio_out_b
   defw stdio_out_b
   
   defb 'o', 195
   LIB stdio_out_lo
   defw stdio_out_lo
   
   defb 'p', 195
   LIB stdio_out_lp
   defw stdio_out_lp
   
   defb 'P', 195
   LIB stdio_out_caplp
   defw stdio_out_caplp
   
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
  