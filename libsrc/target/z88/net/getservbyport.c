/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

char  *getservbyport(port,store)
        int port;
        char *store;
{
        return_nc (getxxbyport(get_services(),port,store));
}
