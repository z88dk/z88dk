

#include <drivers/rs232.h>

void RS232_Putstring_Null( unsigned char *string )
{
    while (*string)
    {
        RS232_Putchar( *string++ );
    }
}


