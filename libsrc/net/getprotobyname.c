/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

u8_t getprotobyname(char *name)
{
        return_nc (getxxbyname(get_protocols(),name));
}
