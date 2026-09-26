/*
 *	z88dk RS232 Function — RC700 (Z80-SIO channel A / RDR+PUN)
 *
 *	uint8_t rs232_init(void)
 *
 *	Following the Classic-Serial model (cf. +svi), the full SIO-A setup
 *	is done by rs232_params(); this call just reports success.  On the
 *	RC700, SIO-A is already configured (8N1) by the firmware at boot, so
 *	programs that only call rs232_init()/put/get work at the default rate.
 */

#include <rs232.h>

uint8_t rs232_init(void)
{
    return RS_ERR_OK;
}
