

#include <drivers/rs232.h>

extern port_info_s port_info;

void RS232_Putchar( unsigned char c )
{
    int  temp;

    temp = (port_info.output_insert + 1) & RS232_BUFFERMASK;

    if(temp == port_info.output_remove) /*buffer full */
        return;		/*  so end    */

    port_info.output_buffer[port_info.output_insert] = c;
    port_info.output_insert = temp;
}


