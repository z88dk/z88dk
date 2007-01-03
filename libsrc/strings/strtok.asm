; char *strtok(char *s, char *delim)
; on each call, return next token in s using delimiters from string delim
; 01.2007 aralbrec

; enter: char *s = new string to tokenize or 0 if want next tkn from last string
; exit : hl = ptr within s to next token, 0 if none
; uses : af, c, de, hl

XLIB strtok
LIB strchr
XREF ASMDISP_STRCHR
XDEF ASM_STRTOK

; static data stored here, not ROMable

.strtok

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   ; de = char *delim
   ; hl = char *s

.asmentry

   ld a,h
   or l
   jr nz, newstart
   
   ld hl,(lastpos)
   ld a,h
   or l
   ret z

.newstart

   ex de,hl
   
   ; hl = char *delim
   ; de = char *s
   
   push de

.loop

   ld a,(de)
   or a
   jr z, endstring
   
   ld c,a
   push hl
   call strchr + ASMDISP_STRCHR
   pop hl
   jr nc, endtoken
   inc de
   jp loop

.endstring

   ld l,a
   ld h,a
   ld (lastpos),hl
   pop hl
   ret

.endtoken

   ex de,hl
   ld (hl),0
   inc hl
   ld (lastpos),hl
   pop hl
   ret

.lastpos

   defw 0

DEFC ASM_STRTOK = asmentry - strtok
