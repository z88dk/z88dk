/*
 *      Small C+ Z88 TCP stack
 *
 *      resolv.h
 *
 *	Various resolving functions
 *
 *	(See UNIX manpage for info!)
 *
 *	djm 13/2/2000
 *
 *	$Id: resolv.h,v 1.6 2010-09-19 00:24:08 dom Exp $
 */

#ifndef __NET_RESOLV_H__
#define __NET_RESOLV_H__

#include <sys/compiler.h>
#include <net/inet.h>

/* A couple of macros to make life easier... */

#define gethostbyname(a) resolve(a)
#define gethostbyaddr(a,b) reverse_addr_lookup(a,b)


/*
 * DNS resolving
 *
 * resolve takes a name and gets a network order IP addres
 * t'other takes a network order IP address and gets a name
 * (shoves it into *name and returns TRUE/FALSE for success/failure
 */

extern ipaddr_t __LIB__ __SHARED__   resolve(char *name);
extern int __LIB__ __SHARED__   reverse_addr_lookup(ipaddr_t ipaddr, char *name);

/* The getxxbyXX routines are now implemented in the library not the kernel */

struct data_entry {
        u8_t    *name;
        tcpport_t port;
        u8_t    protocol;
};

/*
 * Services
 *
 * getservbyname returns a (host order) port number for the service
 * getservbyport returns a portname for the service supplied. The name
 * is stashed in store (no checks made)
 * getservproto* returns the appropriate protocol for a service
 * i.e. 6 = TCP, 27 = UDP , if a service both UDP & TCP returns
 * most common - usu TCP
 */

extern int __LIB__   getservbyname(char *name);
extern char __LIB__ *getservbyport(int port, char *store);
extern char __LIB__  getservprotobyport(int port);
extern char __LIB__  getservprotobyname(char *name);

/*
 * Protocols
 *
 * We don't have many of them but even so...
 *
 * getprotobyname returns the protocol number of the given protocol
 * getprotobynumber does it the other way round
 */

extern int __LIB__   getprotobyname(char *name);
extern char __LIB__ *getprotobynumber(int proto, char *store);

/*
 * Networks...let's be complete here!
 */

extern int __LIB__   getnetbyname(char *name);
extern char __LIB__ *getnetbynumber(int network, char *store);

/* The helper routines */
extern tcpport_t  __LIB__  getxxbyname(struct data_entry *,char *name);
extern char __LIB__ *getxxbyport(struct data_entry *, int, char *store);
extern struct data_entry *get_services();
extern struct data_entry *get_networks();
extern struct data_entry *get_protocols();


#endif /* _NET_RESOLV_H */


