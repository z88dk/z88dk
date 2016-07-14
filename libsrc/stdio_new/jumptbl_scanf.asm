; lookup table for input scan converters
; 05.2008 aralbrec

PUBLIC jumptbl_scanf

; scan converters: "[bcdeEfFiIMonpPsuxX"
; place most common first, library alternatives in comments

.jumptbl_scanf

   defb 'd', 195               ; signed integer
   EXTERN stdio_in_ld             ; stdio_in_d
   defw stdio_in_ld
   
   defb 's', 195               ; string
   EXTERN stdio_in_s
   defw stdio_in_s
   
   defb 'i', 195               ; signed binary, octal, decimal or hexadecimal integer
   EXTERN stdio_in_li             ; stdio_in_i
   defw stdio_in_li
   
   defb 'c', 195               ; character
   EXTERN stdio_in_c
   defw stdio_in_c
   
   defb 'u', 195               ; unsigned integer
   EXTERN stdio_in_ld             ; stdio_in_d
   defw stdio_in_ld

   defb '[', 195               ; character admittance set
   EXTERN stdio_in_bkt
   defw stdio_in_bkt

   defb 'x', 195               ; unsigned hexadecimal integer
   EXTERN stdio_in_lx             ; stdio_in_x
   defw stdio_in_lx
 
   defb 'n', 195               ; store number of bytes read thus far
   EXTERN stdio_in_n
   defw stdio_in_n

   defb 'o', 195               ; unsigned octal integer
   EXTERN stdio_in_lo             ; stdio_in_o
   defw stdio_in_lo
     
   defb 'b', 195               ; unsigned binary integer
   EXTERN stdio_in_lb             ; stdio_in_b
   defw stdio_in_lb
   
   defb 'p', 195               ; pointer value
   EXTERN stdio_in_lx             ; stdio_in_x
   defw stdio_in_lx
   
   defb 'X', 195               ; alias for x
   EXTERN stdio_in_lx             ; stdio_in_x
   defw stdio_in_lx

   defb 'P', 195               ; alias for p
   EXTERN stdio_in_lx             ; stdio_in_x
   defw stdio_in_lx
   
;   defb 'f', 195
;   defw
   
;   defb 'e', 195
;   defw
   
;   defb 'F', 195
;   defw
   
;   defb 'E', 195
;   defw
   
   defb 'I', 195               ; IPv4 address
   EXTERN stdio_in_capi
   defw stdio_in_capi
   
   defb 'M', 195               ; EUI-48 / MAC-48 address
   EXTERN stdio_in_capm
   defw stdio_in_capm
   
   defb 0                      ; end of table
