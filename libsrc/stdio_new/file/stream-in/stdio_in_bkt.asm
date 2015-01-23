; stdio_in_bkt
; 05.2008 aralbrec

PUBLIC stdio_in_bkt
EXTERN stdio_getchar, stdio_ungetchar, stdio_nextarg

; input %[ parameter
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

.stdio_in_bkt

   ; still need to generate the accepting character set from the format string
   ; done here so that the full code can be removed from stdio if this specifier
   ; is not included in compile
   
   pop de
   ex (sp),hl
   push de
   ex de,hl
   
   ; ***************************************************
   ; PART 1
   ; Generate accepting character set from format string
   ;**************************************************** 
   
   ;     b = width
   ;     c = flags [^00a*WL0]
   ;    de = format string
   ; stack = & parameter list, ret
   
   ; create a character sit bitmap on stack, one bit per 8-bit character code
   ; a set bit indicates the corresponding character is in the %[ set
   
   ld hl,0
   ld a,16
   
.createcharsetlp

   push hl
   dec a
   jp nz, createcharsetlp
   
   ;     b = width
   ;     c = flags [^00a*WL0]
   ;    de = format string
   ; stack = & parameter list, ret, char set bitmap (32 bytes)

   ; look for the special leading chars in the %[ char set

   ld a,(de)
   cp '^'                      ; is '^' a leading char?
   jr nz, leading
   
   set 7,c                     ; set carat flag
   inc de
   ld a,(de)                   ; on to next char in format string

.leading

   push bc                     ; save width + flags (done after ^ flag set)

   cp ']'                      ; is ']' a leading char?
   jr nz, fillcharset0

   call addcharA
   inc de                      ; on to next char in format string
   
   ; '-' will be caught in regular loop
   
.fillcharset0

   ; here we are starting from a blank slate... have no pending left char
   ;     b = nothing
   ;     c = flags [^00a*WL0]
   ;    de = format string
   ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags

   ld a,(de)
   or a
   jr z, endcharset0           ; premature end of format string should be an error but taken as ']'
   
   inc de
   cp ']'                      ; reached end of char set?
   jr z, endcharset0

   ld b,a                      ; got our left char

.fillcharset1

   ; we've seen a left char
   ;     b = left char
   ;     c = flags [^00a*WL0]
   ;    de = format string
   ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags

   ld a,(de)                   ; premature end of format string should be an error but taken as ']'
   or a
   jr z, endcharset1

   inc de
   cp ']'                      ; end of char set?
   jr z, endcharset1

   cp '-'                      ; range char?
   jr z, fillcharset2

   ; seen a left char in 'b' and have a following char in 'a'
   ; add left char to character set and make char in 'a' the new left char
   
   ld l,b
   ld b,a                      ; latest char becomes left char
   ld a,l
   
   call addcharA
   jr fillcharset1

.fillcharset2

   ; we've seen a left char and a range char '-'
   ;     b = left char in range
   ;     c = flags [^00a*WL0]
   ;    de = format string
   ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags

   ld a,(de)                   ; premature end of format string should be an error but taken as ']'
   or a
   jr z, endcharset2

   inc de
   cp ']'                      ; end of char set?
   jr z, endcharset2
   
   cp b                       ; make sure right char (A) > left char (B)
   jr nc, rangelp

   ld l,a                     ; if not swap left and right to get increasing order in range
   ld a,b
   ld b,l

.rangelp

   call addcharA   
   dec a                      ; move to next char in range
   cp b                       ; check if end of range reached
   jr nc, rangelp
   jr fillcharset0

.endcharset2

   ; we've seen a left char and a range char '-'
   ;     b = left char in range
   ;     c = flags [^00a*WL0]
   ;    de = format string
   ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags
   
   ld a,'-'                    ; add the minus to the charset
   call addcharA

.endcharset1

   ; we've seen a left char
   ;     b = left char
   ;     c = flags [^00a*WL0]
   ;    de = format string
   ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags
   
   ld a,b                      ; add the left char to the charset
   call addcharA

.endcharset0

   pop bc
   
   ;     b = width
   ;     c = flags [^00a*WL0]
   ;    de = format string
   ; stack = & parameter list, ret, char set bitmap (32 bytes)
   
   ;  swap format string and parameter list on stack
   
   ld hl,34
   add hl,sp
   ld a,(hl)
   ld (hl),e
   inc hl
   ld e,(hl)
   ld (hl),d
   ld l,a
   ld h,e

   ; ***********************************************************************
   ; PART 2
   ; Match characters from stream to charset and write to destination buffer
   ; ***********************************************************************

   ;     b = width
   ;     c = flags [^00a*WLM], M = matched at least one char
   ;    hl = & parameter list
   ; stack = format string, ret, char set bitmap (32 bytes)

   bit 3,c                     ; suppress assignment?
   call z, stdio_nextarg       ; if not de = char *s
   
   push hl                     ; save & parameter list
   push de                     ; save char *s

.loop

   call stdio_getchar          ; get char from stream
   jr c, done

   call computebitsetaddr
   
   ld a,c
   rla
   sbc a,a
   xor (hl)                    ; if ^ invert charset bitmap
   and d                       ; if specific charset bit set we have a match
   jr z, finished
   
   ; char is in bitset so add to string
   
   set 0,c                     ; matched at least one char
   
   bit 3,c
   jr nz, suppress1
   
   ld a,e                      ; write char into char *s
   pop de                      ; de = char *s
   ld (de),a
   inc de
   push de                     ; save char *s
   
.suppress1

   bit 2,c                     ; without width specifier just loop back
   jr z, loop
   
   djnz loop

.done

   pop de                      ; de = char *s
   pop hl                      ; hl = & parameter list

   bit 3,c
   jr nz, adjuststack
   
   xor a
   ld (de),a                   ; write terminating \0 to string
   
   exx
   inc de                      ; increase number of conversions done
   exx

.adjuststack

   ex de,hl
   ld hl,32
   add hl,sp
   ld sp,hl
   ex de,hl

   or a                        ; clear carry flag
   bit 0,c                     ; if at least one char matched
   ret nz                      ;   return with no carry
   scf
   ret

.finished

   ld a,e
   call stdio_ungetchar
   jr done

.computebitsetaddr

   ; enter :  a = char
   ;         stack = ..., char set bitmap (32 bytes), something, something, ret
   ; exit  :  d = mask
   ;          e = char
   ;         hl = bitset addr
   ; uses  : af, de, hl
   
   ld e,a                      ; e = char

   rra
   rra
   rra                         ; a = char / 8
   
   and $1f
   add a,6
   ld l,a
   ld h,0
   add hl,sp                   ; hl = corresponding & in char set bitmap
   
   ld a,e
   and $07
   ld d,1
   ret z

.bitrot

   rl d
   dec a
   jr nz, bitrot

   ret

.addcharA

   push de
   call computebitsetaddr
   inc hl                      ; undershoot by 2 bytes because of extra item on stack
   inc hl
   ld a,(hl)
   or d
   ld (hl),a
   ld a,e
   pop de
   ret
 