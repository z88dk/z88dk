#include "t_stdio.h"


///////////////////////////////////////
// FILE STRUCTURES FOR STDIN, STDOUT //
///////////////////////////////////////


#asm

; stdout FILE structure as of now, still no connection to low level file descriptors

XDEF _t_stdout

._t_stdout

   defb $04                    ; flags: 0000 0OIU (Output stream, Input stream, Unget char)
   
   defb 0                      ; space for single unget char
 
   defb 195                    ; jp
   defw 0                      ; address of character input function
  
   defb 195                    ; jp
   defw _tempoutput            ; address of character output function
   
; stdin FILE structure as of now, still no connection to low level file descriptors

XDEF _t_stdin

._t_stdin

   defb $02                    ; flags: 0000 0OIU (Output stream, Input stream, Unget char)
   
   defb 0                      ; space for single unget char

   defb 195                    ; jp
   defw _tempinput             ; address of character input function
   
   defb 195                    ; jp
   defw 0                      ; address of character output function

#endasm


////////////////////////////////////////////////////////////
// PRIMITIVE OUTPUT FUNCTION ACTING AS BACKEND FOR STDOUT //
////////////////////////////////////////////////////////////


#asm

.coords  defw 0                ; current character coords MSB=Y, LSB=X

.nextx

   ld hl,(coords)
   inc l
   ld (coords),hl
   
   ld a,l
   cp 32
   ret c

.cr

   ld l,0
   inc h
   ld (coords),hl

   ld a,h
   cp 24
   ret c
   
   ld h,23
   ld (coords),hl
   
   call 3582                   ; ROM scroll up
   
   ret

#endasm

void tempoutput(void)
{   
   #asm

   ; a = char to output
   ; must not modify ix, exx registers
   ; set carry and optionally ERRNO if problem on stream
   ; called from stdio_outchar.asm
   
   ; the idea is that the stdio front end uses the main set
   ; of registers and the back end (low level io) uses the
   ; alternate set
   
   cp 13
   jr nz, notcr
   
   ld hl,(coords)
   call cr
   or a
   ret

.notcr
   
   ld de,(23606)
   ld l,a
   ld h,0
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,de
   ex de,hl                    ; de = udg address
   
   LIB zx_cyx2saddr_callee
   XREF ASMDISP_ZX_CYX2SADDR_CALLEE
   
   ld hl,(coords)
   call zx_cyx2saddr_callee + ASMDISP_ZX_CYX2SADDR_CALLEE
   push hl
   
   ld b,8

.loop

   ld a,(de)
   ld (hl),a
   inc de
   inc h
   djnz loop
   
   pop hl
   
   LIB zx_saddr2aaddr
   
   call zx_saddr2aaddr
   ld (hl),7                   ; white ink on black paper
   
   call nextx
   or a                        ; no error on stream
   #endasm
}


//////////////////////////////////////////////////////////
// PRIMITIVE INPUT FUNCTION ACTING AS BACKEND FOR STDIN //
//////////////////////////////////////////////////////////


void tempinput(void)
{
   #asm
 
   ; return a = char read from input
   ; must not modify ix, exx registers
   ; called from stdio_getchar.asm
   ; set carry and optionally ERRNO if problem on stream
   
   ; the idea is that the stdio front end uses the main set
   ; of registers and the back end (low level io) uses the
   ; alternate set
   
   ; ZX Basic Interrupt is still running
   
   ld hl,(coords)
   
   LIB zx_cyx2aaddr_callee
   XREF ASMDISP_ZX_CYX2AADDR_CALLEE
   
   call zx_cyx2aaddr_callee + ASMDISP_ZX_CYX2AADDR_CALLEE
   ld (hl),130                 ; flashing red on black
   
.inloop

   ld a,(23560)                ; block until a char is read
   or a
   jr z, inloop
   
   ld (hl),0                   ; undo flashing cursor here
   
   push af
   call _tempoutput   
   xor a
   ld (23560),a
   pop af

   #endasm
}


////////////////////////
// BUFFER FOR SPRINTF //
////////////////////////

char buf[128];

main()
{
   int a, b, c, d;
   
   #asm
   ld hl,0
   ld (coords),hl
   #endasm
   
   a = t_printf("|%5d|%-5d|%+5d|%+-5d|% 5d|%05d|%5.0d|%5.2d|%d|\n", 0, 0, 0, 0, 0, 0, 0, 0, 0);
   b = t_printf("|%5d|%-5d|%+5d|%+-5d|% 5d|%05d|%5.0d|%5.2d|%d|\n", 1, 1, 1, 1, 1, 1, 1, 1, 1);
   c = t_printf("|%5d|%-5d|%+5d|%+-5d|% 5d|%05d|%5.0d|%5.2d|%d|\n", -1, -1, -1, -1, -1, -1, -1, -1, -1);
   d = t_printf("|%5d|%-5d|%+5d|%+-5d|% 5d|%05d|%5.0d|%5.2d|%d|\n", 12345, 12345, 12345, 12345, 12345, 12345, 12345, 12345, 12345);
   t_printf("Chars output: %d, %d, %d, %d\n\n", a, b, c, d);

   a = t_printf("|%5u|%5o|%5x|%5X|%#5o|%#5x|%#5X|%#10.8x|\n", 0, 0, 0, 0, 0, 0, 0, 0);
   b = t_printf("|%5u|%5o|%5x|%5X|%#5o|%#5x|%#5X|%#10.8x|\n", 1, 1, 1, 1, 1, 1, 1, 1);
   c = t_printf("|%5u|%5o|%5x|%5X|%#5o|%#5x|%#5X|%#10.8x|\n", 0xb93c, 0xb93c, 0xb93c, 0xb93c, 0xb93c, 0xb93c, 0xb93c, 0xb93c);

   d = t_printf("|%3s%-6s|%-10.5s|%c|%3c|%-3c|\n", "no", "where", "Oh no you didn't!", '$', '*', '@');
   t_printf("Chars output: %d, %d, %d, %d\n\n", a, b, c, d);

   a = t_sprintf(buf, "Did it work number %d?\n", 6);
   b = t_printf("%s", buf);
   c = t_snprintf(buf, 10, "Did it work number %d?\n", 6);
   d = t_printf("%s\n", buf);
   t_printf("Chars output: %d, %d, %d, %d\n\n", a, b, c, d-1);

   a = t_printf("%#*.*b\n", 24, 14, 1145);
   t_printf("Chars output: %d\n\n", a-1);

   a = t_printf("Ready to handle a long one %ld mixed with a short one %d?\n", -123456789L, -14);
   b = t_printf("Here's a double %%, a couple unknowns %-#5.t %j, and a very bad thing %");
   t_printf("\nChars output: %d %d\n\n", a-1, b);
  
   for (a=1; a<11; ++a)
   {
      t_printf("(%d of 10) Enter a number: \n-> ", a);
      t_scanf("%i", &b);
      t_printf("%#5b ; %#5o ; %#5x ; %5u\n", b, b, b, b);
   }
   
}

