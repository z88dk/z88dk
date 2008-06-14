; uint __CALLEE__ strlcat_callee(char *dst, char *src, uint size)
; 06.2008 aralbrec

XLIB strlcat_callee
XDEF ASMDISP_STRLCAT_CALLEE

; The openBSD implementation returns an oddball value when size
; is less than strlen(dst).  Instead this version always returns
; the length of the string that would be created without size
; restriction, ie strlen(dst)+strlen(src).  I think this makes
; much more sense and the information more useful.

.strlcat_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

.asmentry

   ; enter : hl = char *dst
   ;         de = char *src
   ;         bc = uint size

   push hl                     ; save dst to compute strlen(dst) later
   push de                     ; save src to compute strlen(src) later
   
   ld a,b                      ; catch degenerate case where size==0
   or c
   jr z, szexceeded0

   ; find end of string dst
   
   xor a
   cpir
   dec hl                      ; hl parked on \0 and bc decr by one extra for the \0
   jp po, szexceeded0          ; oops, size exceeded within string dst
   
   ; append string dst with chars from string src
   
   ex de,hl                    ; de = dst, hl = src

.cpyloop

   ld a,(hl)
   or a
   jr z, success
   ldi
   jp pe, cpyloop
   
   ; incomplete appending of string src
   
   ex de,hl
   dec hl
   ld (hl),0                   ; terminate string dst

.szexceeded1

   ; hl = end of char *dst (pointing at \0)
   ; de = somewhere in char *src
   ; bc = 0
   ; stack = char *dst, char *src
   
   ex de,hl
   xor a
   cpir
   dec hl                       ; hl = end of char *src (pointing at \0)
   
   pop bc
   sbc hl,bc
   ex de,hl                     ; de = strlen(src)
   
   pop bc
   sbc hl,bc                    ; hl = strlen(dst)
   
   add hl,de                    ; return strlen(src)+strlen(dst)
   ret

.szexceeded0

   ; hl = somewhere in char *dst
   ; de = somewhere in char *src
   ; bc = 0
   ; stack = char *dst, char *src

   xor a
   cpir
   dec hl                       ; hl = end of char *dst (pointing at \0)
   
   ld c,a
   ld b,a
   jp szexceeded1

.success

   ex de,hl
   ld (hl),a                    ; terminate dst with \0

   ; hl = end of char *dst (pointing at \0)
   ; carry flag reset
   ; stack = char *dst, char *src

   pop bc
   pop bc
   sbc hl,bc                    ; hl = strlen(final dst)
   ret

defc ASMDISP_STRLCAT_CALLEE = asmentry - strlcat_callee
