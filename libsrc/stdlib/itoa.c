/* Small c library, by Jeremy Dewey (jxd45@po.cwru.edu)
   http://www.seashellinc.com/jdewey

   Synopsis:
      itoa(char* str, int number)

   Description:
      converts the number to its string representation and stores it in str,
      returning a pointer to str.

   Example:
      char str[6];
      itoa(str, 568);

   Notes:

*/

#include <ctype.h>
#include <stdlib.h>

char *itoa(char *str, int num) 
{
   int k;
   char c, flag, *ostr;

   if (num < 0) {
      num = -num;
      *str++ = '-';
   }
   k = 10000;
   ostr = str;
   flag = 0;
   while (k) {
      c = num / k;
      if (c || k == 1 || flag) {
         num %= k;
         c += '0';
         *str++ = c;
         flag = 1;
      }
      k /= 10;
   }
   *str = '\0';
   return ostr;
}
