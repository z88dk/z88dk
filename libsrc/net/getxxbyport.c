/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

char *getxxbyport(type, port, store_in )
	struct data_entry *type;
        tcpport_t port;
        char *store_in;
{
        struct data_entry *search;
	search=type;

        while (search->name) {
                if (search->port == port) {
                        strcpy(store_in, search->name);
                        return store_in;
                }
                search++;
        }
        /* Didnt find - just return the value */
        sprintf(store_in, "%u", port);
        return store_in;
}
