/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

i8_t getservprotobyname(char *name )
{
        struct data_entry *search=get_services();

        while (search->name) {
                if (!strcmp(search->name, name)) {
                        return_nc search->protocol;
                }
                search++;
        }
        return_nc 0;
}
