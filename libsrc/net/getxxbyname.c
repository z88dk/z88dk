/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

tcpport_t getxxbyname(struct data_entry *type, char *name )
{
        struct data_entry *search;
        search=type;

        while (search->name) {
                if (!strcmp(search->name, name)) {
                        return search->port;
                }
                search++;
        }
        return 0;
}
