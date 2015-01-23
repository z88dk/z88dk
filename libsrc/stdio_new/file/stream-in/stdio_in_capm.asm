; stdio_in_M, read EUI-48 / MAC-48 address in canonical form
; 07.2009 aralbrec

PUBLIC stdio_in_capm
EXTERN stdio_incommon1, asm_isxdigit, stdio_inexit, stdio_ungetchar
EXTERN stdio_getchar, stdio_atou_any_stream

; input %M parameter, read EUI-48 address in pairwise hex notation
;
; enter :     ix  = FILE *
;               b = width
;               c = flags [000a*WL0]
;              hl = & parameter list
;             bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
; on exit :   bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;              hl = & parameter list
;             carry set if EOF reached
;
; MUST NOT ALTER HL' FOR SSCANF FAMILY

.stdio_in_capm

   call stdio_incommon1        ; leading ws, sign, mac*
   ret c

   bit 0,c                     ; return error if a sign was present
   jp nz, stdio_inexit
   
   push hl                     ; save & parameter list

   ; ix = FILE*
   ;  a = first char from stream to interpret
   ;  c = flags [000a*WL0]
   ; de = mac*
   ; stack = & parameter list

   ld b,6                      ; read six hex pairs

.loop

   call asm_isxdigit           ; is next char a hex digit?
   jr c, error
   call stdio_ungetchar        ; ungetchar for consumption later
   
   push bc
   push de
   ld e,16
   call stdio_atou_any_stream  ; hl = hex byte
   pop de
   pop bc
   jr c, error
   
   inc h                       ; result should be < 256
   dec h
   jr nz, error
   
   bit 3,c                     ; assignment suppression on?
   jr nz, suppress

   ld a,l
   ld (de),a                   ; write hex byte into mac*
   inc de

   djnz nextdigit              ; if more to go
   
   exx
   inc de                      ; one more successful scan conversion
   exx
   
   pop hl                      ; hl = & parameter list
   ret                         ; carry reset indicating no error

.suppress

   djnz nextdigit              ; if more to go
   
   pop hl                      ; hl = & parameter list
   ret                         ; carry reset indicating no error

.nextdigit

   call stdio_getchar
   jr c, error
   
   cp ':'                      ; expecting a separator here
   jr z, separator_present
   
   cp '-'
   jr nz, error

.separator_present

   call stdio_getchar          ; peek at next digit
   jp nc, loop

.error

   pop hl                      ; hl = & parameter list
   jp stdio_inexit
