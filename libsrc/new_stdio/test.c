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

char buf[128];

main()
{
   int a, b, c, d;
   
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
   t_printf("Chars output: %d\n\n", a-1);
}

