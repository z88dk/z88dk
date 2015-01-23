; stdio_incommon1
; 05.2008 aralbrec

PUBLIC stdio_incommon1
EXTERN stdio_consumews, stdio_consumesign, stdio_getchar, stdio_nextarg

; common code for number scan converters
;
; enter :     ix  = FILE *
;               c = flags [000a*WLN]
;              hl = & parameter list
; on exit :    hl = & parameter list
;               a = first digit of number after sign
;              de = pointer to storage for number
;             bit 0 of c set appropriately
;             carry set if EOF reached

.stdio_incommon1

   bit 3,c                     ; suppressing assignment?
   call z, stdio_nextarg       ; de = pointer to storage for number

   call stdio_consumews        ; get rid of leading whitespace
   ret c
   
   call stdio_consumesign      ; also sets bit 0 of c for '-'
   ret c
   
   jp stdio_getchar            ; get first digit, to be verified as acceptable by caller
