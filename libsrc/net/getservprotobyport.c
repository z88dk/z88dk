/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

i8_t getservprotobyport(port )
        tcpport_t port;
{
        struct data_entry *search=get_services();

        while (search->name) {
                if (search->port == port) {
                        return_nc search->protocol;
                }
                search++;
        }
        return_nc 0;
}
