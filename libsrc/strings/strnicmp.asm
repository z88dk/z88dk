; int strnicmp(char *s1, char *s2, int n)
; caseless compare

; exit : if s1==s2 : hl = 0, Z flag set
;        if s1<<s2 : hl < 0, NC flag set
;        if s1>>s3 : hl > 0, C flag set
; uses : af, bc, de, hl

XLIB strnicmp
XDEF ASMDISP_STRNICMP

.strnicmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af

   ; bc = int n
   ; de = char *s2 = char *ct
   ; hl = char *s1 = char *s
 
.asmentry
.strnicmp1

   ld a,b
   or c
   jr z, equal
   
   push bc
   ld a,(hl)
   inc hl
   call tolower              ; local version, lib function optimized for C not asm
   ld c,a
   ld a,(de)
   inc de
   call tolower
   cp c
   pop bc
   jr nz, different
   dec bc
   or a
   jp nz, strnicmp1
   
.equal

   ld hl,0
   ret

.different

   ; effectively performed *ct - *cs

   ld h,$80
   ret nc
   dec h
   ret

.tolower

   cp 'A'
   ret c
   cp 'Z'+1
   ret nc
   or $20
   ret

DEFC ASMDISP_STRNICMP = asmentry - strnicmp
