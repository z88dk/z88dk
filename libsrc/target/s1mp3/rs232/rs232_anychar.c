

#include <drivers/rs232.h>

extern port_info_s port_info;

int RS232_Anychar( void )
{
	int temp;

	temp = port_info.input_insert - port_info.input_remove;

	return temp < 0 ? temp + RS232_BUFFERSIZE : temp;
}


