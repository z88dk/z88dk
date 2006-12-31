;/*
; *      strtol(char *s, char **endp, int base)
; *
; *      Taken from vbcc archive
; *
; *      Added to Small C+ 27/4/99 djm
; *
; * -----
; * $Id: strtol.asm,v 1.2 2006-12-31 23:28:13 aralbrec Exp $
; *
; */

; rewritten in asm and lost the overflow check in process
; 12.2006 aralbrec
;
; Note: The writeendp subroutine expects to find the
;  char **endp parameter on the stack so this function
;  should be called using the C convention only.
;
; Uses all registers except a',iy (does use f')

XLIB strtol
LIB l_long_neg, l_long_mult

.strtol

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)                 ; bc = base
   inc hl
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = char *s

   ld de,writeendp           ; put writeendp on stack so that it
   push de                   ; is executed on ret
   ld e,l
   ld d,h
   
   ; bc = base
   ; hl = char *
   ; de = start char *

.eatws

   ld a,(hl)                 ; eat whitespace
   inc hl

   cp 32                     ; inlined isspace
   jr z, eatws
   cp 7
   jr z, eatws
   cp 10
   jr z, eatws
   cp 13
   jr z, eatws

   ; ate up one too many chars, see if it's a sign
   
   cp '+'
   jr z, signdone
   dec hl
   cp '-'
   jr nz, signdone
   inc hl                    ; this is a negative number
   push hl
   ld hl,l_long_neg          ; sneakily push negate long function on stack
   ex (sp),hl                ; so it is run on ret
   
.signdone

   ; bc = base
   ; hl = char *
   ; de = start char *

   ld a,b                    ; base must be in [0,2-36]
   or a
   jp nz, fail
   ld a,c
   cp 37
   jp nc, fail
   dec a
   jp z, fail
   inc a
   jr nz, knownbase

   ; base=0 so need to figure out if it's oct, dec or hex

   ld a,(hl)
   ld c,10
   cp '0'                    ; if leading digit not '0' must be decimal
   jr nz, knownbase
   inc hl
   ld a,(hl)                 ; if next char is a digit must be oct
   ld c,8
   cp '0'
   jr c, fail
   cp '7'+1
   jr c, knownbase
   and $df                   ; toupper(a)
   ld c,16
   cp 'X'                    ; leading 0x indicates hex
   jr nz, fail
   inc hl

.knownbase

   ld a,(hl)                 ; make sure there's at least one
   sub '0'                   ; digit else fail
   jr c, fail
   cp c
   jr nc, fail
   cp 10
   jr c, pass
   add a,'0'
   and $df                   ; toupper(a)
   sub 'A'
   jr c, fail
   add a,10
   cp c
   jr nc, fail

.pass

   ; bc = base
   ; hl = char *

   ld d,b
   ld e,b                    ; de = 0
   push de
   push bc                   ; push (long)(base) on stack
   
   ld ix,-6
   add ix,sp                 ; ix will point at duplicate (long)(base) on stack
   
   ld c,l
   ld b,h                    ; bc = char *
   
   ld h,d
   ld l,e                    ; dehl = 0 = total so far

.loop

   ;   bc = char *, char there known to be digit
   ; dehl = running total
   ;   ix = & duplicate (long)(base) on stack (not valid now)
   ; stack = (long)(base)

   ; first refresh copy of duplicate base on stack

   push bc                   ; save char *
   ld bc,0
   push bc                   ; make space for duplicate base on stack
   push bc
   ld a,(ix+6)               ; copy (long)(base) into duplicate
   ld (ix+0),a               ; only single byte since base must be < 37
   call l_long_mult          ; dehl = dehl * base
   pop bc                    ; bc = char * (lib mult does stack gymnastics)
   
   ; now add in digit
   
   ld a,(bc)
   inc bc
   
   sub '0'
   cp 10
   jr c, okaddit
   add a,'0'
   and $df
   sub 'A'-10
   
.okaddit

   add a,l
   ld l,a
   jr nc, oksum
   inc h
   jr nz, oksum
   inc e
   jr nz, oksum
   inc d

.oksum

   ld a,(bc)                 ; check if next char is a digit

   sub '0'
   jr c, done
   cp (ix+6)                 ; base
   jr nc, done
   cp 10
   jr c, loop
   add a,'0'
   and $df                   ; toupper(a)
   sub 'A'
   jr c, done
   add a,10
   cp (ix+6)                 ; base
   jp c, loop

.done

   ; bc = char *
   ; dehl = result
   ; stack = (long)(base)
   
   pop af
   pop af
   ret
   
.fail

   ld c,e
   ld b,d                    ; bc = original char *
   ld de,0                   ; dehl = result = 0
   ld h,d
   ld l,e
   ret
   
.writeendp

   ; dehl = result
   ; bc = char *
   
   push hl
   ld hl,6
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = char **endp
   
   or h                      ; if endp==NULL skip
   jr z, noendp
   
   ld (hl),c                 ; write last string position
   inc hl                    ; into endp
   ld (hl),b

.noendp

   pop hl
   ret


;#include <stdio.h>
;#include <ctype.h>
;#include <limits.h>
;#include <stdlib.h>
;
;
;signed long strtol(
;char *nptr,
;char **endptr,
;int base)
;{ 
;
;  unsigned long r;
;  unsigned char *q;
;  unsigned char *p;
;
;  p=nptr;
;
;  while(isspace(*p))
;    p++;
;  r=strtoul(p,(signed char **)&q,base);
;  if(endptr!=NULL)
;  { if(q==p)
;      *endptr=(char *)nptr;
;    else
;      *endptr=q;
;  }
;  if(*p=='-') {
;    if((signed long)r>0)
;      return LONG_MIN;
;    else
;      return r;
;  } else {
;   if((signed long)r<0)
;      return LONG_MAX;
;    else
;      return r;
;  }
;}
