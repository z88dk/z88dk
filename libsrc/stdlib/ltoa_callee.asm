; char __CALLEE__ *ltoa_callee(char *s, long num)
; convert long to string and store in s
; 04.2007 aralbrec

XLIB ltoa_callee
XDEF ASMDISP_LTOA_CALLEE
XDEF ASMDISP2_LTOA_CALLEE

LIB l_long_div_u, l_long_neg

; l_long_div_u
; enter: push arg1,ret addr, arg2 = dehl
; exit : dehl = arg1/arg2, de'hl' = arg1%arg2

.ltoa_callee

   pop af
   pop hl
   pop de
   pop bc
   push af

.asmentry

   ; dehl = long num
   ; bc = char *s
   
   push bc

   bit 7,d                     ; negative num?
   jr z, notneg
   ld a,'-'                    ; write negative sign
   ld (bc),a
   inc bc
   call l_long_neg             ; make it positive, bc okay

.notneg

   push bc                     ; save current char * position
   ld bc,constants
   push bc
   exx
   
.skipleading0

   ; de'hl'= num
   ; stack = char *, constants

   pop hl                      ; & constant
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)                   ; debc = constant
   
   ld a,d
   or e
   or b
   or c
   jr z, writelast             ; if there are no more constant write last digit
   
   inc hl
   push hl                     ; & next constant
   
   ld l,c
   ld h,b                      ; dehl = arg2
   exx
   push de
   push hl                     ; arg1 on stack
   exx
   call l_long_div_u           ; dehl = arg1/arg2, de'hl' = arg1%arg2

   ld a,l
   or a
   jp z, skipleading0

.write

   ;     a  = digit to write
   ; de'hl' = remaining num
   ; stack  = char *, constants
   
   add a,'0'
   
   pop hl                      ; & constant
   pop de                      ; char *
   ld (de),a                   ; write digit
   inc de
   push de

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)                   ; debc = constant
   
   ld a,d
   or e
   or b
   or c
   jr z, writelast             ; if there are no more constant write last digit
   
   inc hl
   push hl                     ; & next constant
   
   ld l,c
   ld h,b                      ; dehl = arg2
   exx
   push de
   push hl                     ; arg1 on stack
   exx
   call l_long_div_u           ; dehl = arg1/arg2, de'hl' = arg1%arg2
   
   ld a,l
   jp write

.writelast

   ;    hl' = remaining num
   ; stack  = char *

   exx
   pop de
   ld a,l
   add a,'0'
   ld (de),a                   ; write last digit
   inc de
   
   xor a
   ld (de),a                   ; terminate with '\0'
   pop hl                      ; hl = char *s
   ret

.constants                     ; MSW, LSW, all big endian

   defw $9a3b, $00ca           ; 1,000,000,000
   defw $f505, $00e1           ;   100,000,000
   defw $9800, $8096           ;    10,000,000
   defw $0f00, $4042           ;     1,000,000
   defw $0100, $a086           ;       100,000
   defw $0000, $1027           ;        10,000
   defw $0000, $e803           ;         1,000
   defw $0000, $6400           ;           100
   defw $0000, $0a00           ;            10
   defw $0000, $0000           ;  end of table

DEFC ASMDISP_LTOA_CALLEE = asmentry - ltoa_callee
DEFC ASMDISP2_LTOA_CALLEE = notneg - ltoa_callee

