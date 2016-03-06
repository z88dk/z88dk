;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;Exit routine, rewritten 27/11/98 so to traverse the atexit stack
;
;Constantly revisited through April
;Some of the opt rules cause this routine to be jumped to instead
;of called, so we don't use the stack, instead we use hl as our
;entrance variable...we're buggered if we define a pointer to here
;though...
;
; -----
; $Id: exit.asm,v 1.8 2016-03-06 22:03:07 dom Exp $

SECTION code_clib
PUBLIC exit
PUBLIC _exit

EXTERN cleanup, exitsp, exitcount

EXTERN l_jphl

PUBLIC ASMDISP_EXIT

; FASTCALL

;This also allows for an atexit function to print a bye bye message
;or whatever... - no parameters are passed into it...

.exit
._exit

   push hl                   ; save exit value
   
   ld a,(exitcount)
   or a
   jr z, end

   ld b,a                    ; b = number of registered functions
   add a,a
   ld e,a
   ld d,0
   ld hl,(exitsp)            ; hl = & atexit stack
   add hl,de                 ; hl = & last function in exit stack + 2b

.loop                        ; now traverse atexit stack in reverse order

   push bc
   dec hl
   ld a,(hl)
   dec hl
   push hl
   ld l,(hl)
   ld h,a                    ; hl = atexit function
   call l_jphl
   pop hl
   pop bc
   
   djnz loop

.end                         ; disrupt stack completely and exit with error value

   pop hl
   ld a,l                    ; was here so left as is, something to do with z88?
   jp cleanup                ;  perhaps should be in the z88 crt0?

DEFC ASMDISP_EXIT = 0
