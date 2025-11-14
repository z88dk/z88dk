
#include <stdio.h>
#include <stropts.h>
#include <arch/zx.h>
#include <stdlib.h>
#include <string.h>

extern FILE *window_1;
extern FILE *window_2;

main()
{
   static int i;
   static unsigned char buffer[100];

   zx_border(INK_BLACK);
   zx_cls(INK_GREEN | PAPER_GREEN);

   ioctl(1, IOCTL_OTERM_CLS);
   ioctl(2, IOCTL_OTERM_CLS);

   while (1)
   {
      // fill buffer with random letters
      
      memset(buffer, 0, 100);
      
      for (i = rand() % 100; i >= 0; --i)
         buffer[i] = (unsigned char)((rand() % ('z' - ' ')) + ' ');
      
      // print to both windows
      
      fprintf(window_1, "%s\n", buffer);
      fprintf(window_2, "%s\n", buffer);
      
      // gather input
      
      if (rand() > 32200)
      {
         fprintf(window_1, "\nEnter some text: ");
         
         fflush(stdin);
         scanf("%99[^\n]", buffer);
         
         i = ioctl(2, IOCTL_OTERM_FCOLOR, INK_YELLOW | PAPER_BLUE);
         fprintf(window_2, "\n%s\n\n", buffer);
         ioctl(2, IOCTL_OTERM_FCOLOR, i);
      }
   }
}
