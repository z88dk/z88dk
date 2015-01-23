; stdio_incommon2
; 05.2008 aralbrec

PUBLIC stdio_incommon2
EXTERN stdio_atou_any_stream, l_neg

; common code for number scan converters
;
; enter :     ix  = FILE *
;               b = radix
;               c = flags [000a*WLN]
;              hl = & parameter list
;              de = number *
;             bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
; on exit :   bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;              de = scanned number (suppress flag only)
;              hl = & parameter list
;             carry set if EOF reached

.stdio_incommon2

   push hl                     ; save & parameter list
   push de                     ; save number *
   push bc                     ; save c = flags
   
   ld e,b                      ; e = radix
   call stdio_atou_any_stream  ; hl = unsigned int from stream
   
   or a                        ; clear carry
   pop bc
 
   bit 0,c                     ; is this number negative?
   call nz, l_neg              ; if so hl=-hl

   bit 3,c                     ; suppressing assignment?
   jr nz, suppress0
   
   pop de
   ex de,hl                    ; hl = number *, de = number
   ld (hl),e
   inc hl
   ld (hl),d
   
   pop hl                      ; hl = & parameter list
   exx
   inc de                      ; increase number of conversions done
   exx
   ret

.suppress0

   ex de,hl
   pop hl
   pop hl
   ret

   