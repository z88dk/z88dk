

#include <drivers/rs232.h>

void RS232_Putstring( unsigned char *string, unsigned char length )
{
    unsigned int i;

    for (i=0; i<length; i++)
    {
        RS232_Putchar( string[i] );
    }
}


