

#include <drivers/rs232.h>

extern port_info_s port_info;

unsigned char RS232_Getchar( void )
{
	unsigned char c;	

	while (port_info.input_remove == port_info.input_insert)
	{
	    /* What should we do!?  be prepared for a lockup if we
	     * don't fix this
	     */
	}	

	c = port_info.input_buffer[port_info.input_remove++];
	port_info.input_remove &= RS232_BUFFERMASK;

	return (c);
}


