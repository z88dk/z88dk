/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

i8_t *getprotobynumber(port,store)
        tcpport_t port;
        u8_t    *store;
{
        return_nc (getxxbyport(get_protocols(),port,store));
}
