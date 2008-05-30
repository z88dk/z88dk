; stdio_in_bkt
; 05.2008 aralbrec

XLIB stdio_in_bkt
LIB stdio_getchar, stdio_ungetchar

; input %[ parameter
;
; enter :     ix  = & attached file / device getchar function
;               b = width
;               c = flags [^00a*WL0]
;              hl = & parameter list
;             bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;           stack = format string, ret
; on exit :   bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;              hl = & parameter list
;           stack = format string
;             carry set if EOF reached

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
   jr nz, leading0
   
   set 7,c                     ; set carat flag
   inc de
   ld a,(de)                   ; on to next char in format string

.leading0

   push bc                     ; save width + flags (done after ^ flag set)

   cp ']'                      ; is ']' a leading char?
   jr nz, fillcharsetlp
   
   push de
   sub 16
   call addcharA               ; add ']' to bitset
   pop de
   
   inc de                      ; on to next char in format string
   ld a,(de)
   
   ; '-' will be caught in regular loop
   
.fillcharsetlp

   ;     b = left char in range
   ;     c = flags [^VRa*WL0] (bit 6 = 1 if left char is valid, bit 5 = 1 if range '-' seen)
   ;    de = format string
   ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags

   ld a,(de)
   or a
   jr z, endcharset            ; premature end of format string should be an error but taken as ']'
   
   inc de
   cp ']'                      ; reached end of char set?
   jr z, endcharset

   cp '-'                      ; range char?
   jr nz, validchar

   bit 6,c                     ; if left char not seen place into left char
   jr z, validchar
   
   set 5,c                     ; left char and range seen
   jr fillcharsetlp

.validchar

   bit 5,c                     ; have we seen a left char followed by a '-'?
   jr nz, dorange

   bit 6,c                     ; have we seen a left char yet?
   jr nz, haveleft

   ld b,a                      ; place char read into left char
   set 6,c
   jr fillcharsetlp

.haveleft

   push de                     ; save format string ptr

   ; have left char and char just read but no range so add left char to charset bitmap
   
   ld e,a
   ld a,b
   ld b,e                      ; char just read becomes new left char
   
   call addcharA

   pop de                     ; de = format string
   jr fillcharsetlp

.dorange

   cp b                       ; make sure right char (A) > left char (B)
   jr nc, orderok

   ld l,a                     ; if not swap left and right to get increasing order in range
   ld a,b
   ld b,l

.orderok

   push de                    ; save format string ptr

.rangeaddlp

   push af                    ; save current char in range
   add a,16
   call addcharA   
   pop af
   
   dec a                      ; move to next char in range
   cp b                       ; check if end of range reached
   jr nc, rangeaddlp
   
   ld a,c
   and $9f                    ; clear left char and range flags
   ld c,a
   
   pop de
   jr fillcharsetlp

.endcharset

   push de

   ; must see if there is a pending left char and range indicator
   
   bit 6,c                    ; left char present?
   jr nz, donecharsetfill

   ld a,b
   call addcharA
   
   bit 5,c                    ; range char seen?
   jr nz, donecharsetfill
   
   ld a,'-'
   call addcharA

.donecharsetfill

   pop de
   pop bc
   
   ;     b = width
   ;     c = flags [^00a*WL0]
   ;    de = format string
   ; stack = & parameter list, ret, char set bitmap (32 bytes)
   
   ;  write format string into stack before return address in stack
   
   ld hl,34
   add hl,sp
   ld a,(hl)
   ld (hl),e
   inc hl
   ld e,(hl)
   ld (hl),d
   ld l,a
   ld h,e

   ; *******************************************************************
   ; PART 2
   ; Match characters from stream to set and write to destination buffer
   ; *******************************************************************

   ;     b = width
   ;     c = flags [^00a*WL0]
   ;    hl = & parameter list
   ; stack = format string, ret, char set bitmap (32 bytes)

   bit 3,c
   jr nz, suppress0
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = char *s
   dec hl

.suppress0

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

   xor a                       ; also clears carry flag
   
   bit 3,c
   jr nz, adjuststack
   
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

   ret

.finished

   ld a,e
   call stdio_ungetchar
   jr done

.computebitsetaddr

   ; enter :  a = char
   ;         stack = ..., char set bitmap (32 bytes), something, something
   ; exit  :  d = mask
   ;          e = char
   ;         hl = bitset addr
   ; uses  : af, de, hl
   
   ld e,a                      ; e = char

   rra
   rra
   rra                         ; a = char / 8
   
   and $1f
   add a,4
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
   jp nz, bitrot

   ret

.addcharA

   call computebitsetaddr
   ld a,(hl)
   or d
   ld (hl),a
   ret

