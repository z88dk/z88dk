#include "t_stdio.h"

void tempoutput(void)
{
   // there is no backend for t_stdio yet
   // instead all output is passed through this function
   
   #asm

   ; a = char to output
   ; must not modify ix, exx registers
   
   ; bloody hell, cant find a suitable output function
   
   exx                         ; go back into main set
   push bc                     ; save registers being used by t_stdio
   push de
   push hl
   rst $10                     ; use rom to output char
   pop hl
   pop de
   pop bc
   exx
      
   #endasm
}

main()
{
   int a, b, c, d;
   
   a = t_printf("|%5d|%-5d|%+5d|%+-5d|% 5d|%05d|%5.0d|%5.2d|%d|\n", 0, 0, 0, 0, 0, 0, 0, 0, 0);
   b = t_printf("|%5d|%-5d|%+5d|%+-5d|% 5d|%05d|%5.0d|%5.2d|%d|\n", 1, 1, 1, 1, 1, 1, 1, 1, 1);
   c = t_printf("|%5d|%-5d|%+5d|%+-5d|% 5d|%05d|%5.0d|%5.2d|%d|\n", -1, -1, -1, -1, -1, -1, -1, -1, -1);
   d = t_printf("|%5d|%-5d|%+5d|%+-5d|% 5d|%05d|%5.0d|%5.2d|%d|\n", 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384);
   t_printf("Chars output: %d, %d, %d, %d\n\n", a, b, c, d);

   a = t_printf("|%5u|%5o|%5x|%5x|%#5o|%#5x|%#5x|%#10.8x|\n", 0, 0, 0, 0, 0, 0, 0, 0);
   b = t_printf("|%5u|%5o|%5x|%5x|%#5o|%#5x|%#5x|%#10.8x|\n", 1, 1, 1, 1, 1, 1, 1, 1);
   c = t_printf("|%5u|%5o|%5x|%5x|%#5o|%#5x|%#5x|%#10.8x|\n", 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384);
   t_printf("Chars output: %d, %d, %d, %d\n\n", a, b, c, d);
}

