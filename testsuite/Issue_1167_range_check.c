
typedef unsigned char uint8_t;
typedef signed char int8_t;

int func(unsigned char mode)
{

	if ( mode == ((((uint8_t)(( 0100000 ) >> 8))))) {
		return 0;
	}
	return 1;
}
	
