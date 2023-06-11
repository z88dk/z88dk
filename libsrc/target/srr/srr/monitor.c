/*=======================================================
 
        The Standard Exidy Monitor caller!
        Calling sequence is of the form:
          x=monitor("SA IDIOT 100 2BFF 2");
        ie it is passed a pointer to a Standard Monitor
        command string. The required CR is appended
        automatically by this routine.
        The value returned is:
                0 for an error in the command string,
                1 for a successful operation, or
                NO RETURN AT ALL for errors caught by
                 the monitor itself (sorry about that!)
*/
 
#include <sorcerer.h>
#include <string.h>
#include <ctype.h>

int monitor(char *s)
 
{       char    *inbuf;
 
        inbuf = mwa();
        strcpy(inbuf,s);
        while (*inbuf=toupper(*inbuf)) inbuf++;
        *inbuf = '\r';
        return exycall();
}
 
 
