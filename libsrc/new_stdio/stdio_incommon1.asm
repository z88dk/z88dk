; stdio_incommon1
; 05.2008 aralbrec

XLIB incommon1
LIB stdio_consumews, stdio_consumesign, stdio_getchar

; common code for number scan converters
;
; enter :     ix  = & attached file / device getchar function
;               c = flags [000a*WLN]
;              hl = & parameter list
; on exit :    hl = & parameter list
;               a = first digit of number after sign
;              de = pointer to storage for number
;             bit 0 of c set appropriately
;             carry set if EOF reached

.stdio_incommon1

   bit 3,c                     ; suppressing assignment?
   jr nz, suppress0
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = pointer to storage for number
   dec hl

.suppress0

   call stdio_consumews        ; get rid of leading whitespace
   ret c
   
   call stdio_consumesign      ; also sets bit 0 of c for '-'
   ret c
   
   jp stdio_getchar            ; get first digit, to be verified as acceptable by caller
