; stdio_incommon3
; 05.2008 aralbrec

PUBLIC stdio_incommon3
EXTERN stdio_atoul_any_stream, l_long_neg

; common code for long number scan converters
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
;              de = LSW of number (suppress flag only)
;              hl = & parameter list
;             carry set if EOF reached

.stdio_incommon3

   push hl                     ; save & parameter list
   push de                     ; save number *
   push bc                     ; save c = flags
   
   call stdio_atoul_any_stream ; dehl = unsigned int from stream
   
   or a                        ; clear carry
   pop bc

   bit 0,c                     ; is this number negative?
   call nz, l_long_neg         ; if so dehl=-dehl

   bit 3,c                     ; suppressing assignment?
   jr nz, suppress0
   
   ; dehl = unsigned long
   ;    c = flags [000a*WLN]
   ; stack = number *
   
   ex de,hl                    ; long is hlde
   ex (sp),hl                  ; hl = number *
   ld (hl),e
   inc hl
   ld (hl),d                   ; write least significant word of long
   pop de                      ; de = most sig word of long
   
   bit 1,c
   jr z, notlong
   
   inc hl
   ld (hl),e                   ; write most significant word of long
   inc hl
   ld (hl),d
   
.notlong

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
