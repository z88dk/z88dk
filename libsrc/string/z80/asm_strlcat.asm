
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
; ===============================================================
; 
; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)
;
; Append chars from s2 to s1 such that the total length of the resulting s1
; is maximum n chars including terminating NUL.
;
; s1 is unaltered if n < strlen(s1).
;
; Return strlen(s1) + strlen(s2).
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strlcat

asm_strlcat:

   ; enter : hl = char *s1 = dst
   ;         de = char *s2 = src
   ;         bc = size_t n
   
   ; exit  : hl = strlen(s1) + strlen(s2)
   ;         bc = char *s1
   ;         carry set if complete strlcat not possible
   ;
   ; uses  : af, bc, de, hl

   push hl                     ; save s1 to compute strlen(s1) later
   
   ld a,b                      ; catch degenerate case where n == 0
   or c
   jr Z,szexceeded0

   xor a                       ; find end of string s1

IF __CPU_INTEL__ || __CPU_GBZ80__

   dec bc                      ; bc decr by one extra allowing for the dst NUL

   dec bc
   inc b
   inc c

srchloop:
   cp (hl)
   jr Z,found_dst              ; hl parked on NUL

   inc hl

   dec c
   jr NZ,srchloop
   dec b
   jr NZ,srchloop

   jr szexceeded0              ; oops, size exceeded within string s1

found_dst:

ELSE
   cpir

   dec hl                      ; hl parked on NUL and bc decr by one extra for the dst NUL
   jp PO,szexceeded0           ; oops, size exceeded within string s1
ENDIF

   ; append to string s1 with chars from string s2
   
   ex de,hl                    ; de = s1, hl = s2

IF __CPU_INTEL__ || __CPU_GBZ80__

cpyloop:
   xor a
   cp (hl)
   jr Z,success

   ld a,(hl+)
   ld (de+),a

   dec c
   jr NZ,cpyloop
   dec b
   jr NZ,cpyloop

ELSE
cpyloop:
   cp (hl)
   jr Z,success
   ldi
   jp pe,cpyloop
ENDIF

   ; incomplete appending of string src

   xor a
   ld (de),a                   ; terminate string s1

szexceeded1:

   ; de = end of char *s1 (pointing at NUL)
   ; hl = somewhere in char *s2, next char to copy
   ; bc = 0
   ;  a = 0
   ; carry reset
   ; stack = char *s1

   push hl                     ; save current position in s2 to compute strlens later

IF __CPU_INTEL__ || __CPU_GBZ80__
endloop:
   cp (hl)
   jr Z,found_src              ; find end of src

   inc hl

   dec c
   jr NZ,endloop
   dec b
   jr NZ,endloop

found_src:

ELSE
   cpir
   dec hl                      ; hl = end of char *s2 (pointing at NUL)
ENDIF

   pop bc

IF __CPU_8080__ || __CPU_GBZ80__
   ld  a,l
   sub c
   ld  l,a
   ld  a,h
   sbc b
   ld  h,a
ELIF __CPU_8085__
   sub hl,bc
ELSE
   sbc hl,bc
ENDIF

   ex de,hl                    ; de = strlen(s2 remnant)

   pop bc

IF __CPU_8080__ || __CPU_GBZ80__
   ld  a,l
   sub c
   ld  l,a
   ld  a,h
   sbc b
   ld  h,a
ELIF __CPU_8085__
   sub hl,bc
ELSE
   sbc hl,bc                   ; hl = strlen(result s1)
ENDIF

   add hl,de                   ; return strlen(s1)+strlen(s2)
   scf                         ; not enough space

   ret

szexceeded0:
   
   ; hl = nth char in s1
   ; de = char *s2
   ; bc = 0
   ;  a = 0
   ; carry reset
   ; stack = char *s1

IF __CPU_INTEL__ || __CPU_GBZ80__
loop0:
   cp (hl)
   jr Z,found_dst_end           ; find end of dst

   inc hl

   dec c
   jr NZ,loop0
   dec b
   jr NZ,loop0

found_dst_end:

ELSE
   cpir
   dec hl                      ; hl = end of char *s1 (pointing at NUL)
ENDIF

   ld c,a
   ld b,a
   ex de,hl
   jr szexceeded1

success:

   ex de,hl
   ld (hl),a                   ; terminate s1 with NUL

   ; hl = end of char *s1 (pointing at NUL)
   ; carry flag reset
   ; stack = char *s1

   pop bc
IF __CPU_8080__ || __CPU_GBZ80__
   ld  a,l
   sub c
   ld  l,a
   ld  a,h
   sbc b
   ld  h,a
ELIF __CPU_8085__
   sub hl,bc
ELSE
   sbc hl,bc                   ; hl = strlen(final s1)
ENDIF
   ret

