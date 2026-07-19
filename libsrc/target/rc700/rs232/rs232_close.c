/*
 *	z88dk RS232 Function — RC700 (Z80-SIO channel A / RDR+PUN)
 *
 *	uint8_t rs232_close(void)
 *
 *	Nothing to release; SIO-A stays configured for the RC700 RDR/PUN
 *	devices.  Provided for API completeness.
 */

#include <rs232.h>

uint8_t rs232_close(void)
{
    return RS_ERR_OK;
}
