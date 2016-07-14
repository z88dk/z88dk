; uint __CALLEE__ strlcat_callee(char *dst, char *src, uint size)
; 06.2008 aralbrec

SECTION code_clib
PUBLIC strlcat_callee
PUBLIC _strlcat_callee
PUBLIC ASMDISP_STRLCAT_CALLEE

IF FORrcmx000
EXTERN  rcmx_cpir
ENDIF

; The openBSD implementation returns an oddball value when size
; is less than strlen(dst).  Instead this version always returns
; the length of the string that would be created without size
; restriction, ie strlen(dst)+strlen(src).  I think this makes
; much more sense and the information more useful.

.strlcat_callee
._strlcat_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

.asmentry

   ; enter : hl = char *dst
   ;         de = char *src
   ;         bc = uint size
   ; exit  : hl = strlen(dst) + strlen(src)
   ;         carry set if complete strcat not possible

   push hl                     ; save dst to compute strlen(dst) later
   
   ld a,b                      ; catch degenerate case where size==0
   or c
   jr z, szexceeded0

   ; find end of string dst
   
   xor a

IF FORrcmx000
   call rcmx_cpir
ELSE
   cpir
ENDIF
   
   dec hl                      ; hl parked on \0 and bc decr by one extra for the \0
   jp po, szexceeded0          ; oops, size exceeded within string dst
   
   ; append to string dst with chars from string src
   
   ex de,hl                    ; de = dst, hl = src

.cpyloop

   ld a,(hl)
   or a
   jr z, success
   ldi
   jp pe, cpyloop
   
   ; incomplete appending of string src
   
   xor a
   ld (de),a                   ; terminate string dst

.szexceeded1

   ; de = end of char *dst (pointing at \0)
   ; hl = somewhere in char *src
   ; bc = 0
   ;  a = 0
   ; carry reset
   ; stack = char *dst

   push hl                     ; save current position in src to compute strlens later   

IF FORrcmx000
   call rcmx_cpir
ELSE
   cpir
ENDIF

   dec hl                      ; hl = end of char *src (pointing at \0)
   
   pop bc
   sbc hl,bc
   ex de,hl                    ; de = strlen(src remnant)
   
   pop bc
   sbc hl,bc                   ; hl = strlen(dst augment)
   
   add hl,de                   ; return strlen(src)+strlen(dst)
   scf
   ret

.szexceeded0

   ; hl = somewhere in char *dst
   ; de = somewhere in char *src
   ; bc = 0
   ; stack = char *dst

   xor a

IF FORrcmx000
   call rcmx_cpir
ELSE
   cpir
ENDIF

   dec hl                       ; hl = end of char *dst (pointing at \0)
   
   ld c,a
   ld b,a
   ex de,hl
   jp szexceeded1

.success

   ex de,hl
   ld (hl),a                    ; terminate dst with \0

   ; hl = end of char *dst (pointing at \0)
   ; carry flag reset
   ; stack = char *dst

   pop bc
   sbc hl,bc                    ; hl = strlen(final dst)
   ret

defc ASMDISP_STRLCAT_CALLEE = # asmentry - strlcat_callee
