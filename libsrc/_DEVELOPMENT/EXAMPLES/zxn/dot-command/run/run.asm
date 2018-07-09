SECTION code_user

PUBLIC _fix_command_line

EXTERN _PATH

_fix_command_line:

   ld de,_PATH

   ld a,h
   or l
   jr z, terminate

loop:

   ld a,(hl)
   
   or a
   jr z, terminate
   
   cp ':'
   jr z, terminate
   
   cp 0x0d
   jr z, terminate
   
   ldi

   jr loop

terminate:

   xor a
   ld (de),a

   ld hl,_PATH
   ret
