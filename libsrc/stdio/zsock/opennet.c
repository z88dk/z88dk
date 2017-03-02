/*
 *	Open a TCP/UDP connection based on fileio
 *
 *	djm 25/4/2000
 *	
 *	$Id: opennet.c,v 1.2 2001-04-13 14:14:00 stefano Exp $
 */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <net/resolv.h>
#include <net/socket.h>


int opennet(FILE *fp,char *name)
{
	char	host[50];
	int	proto;
	char	*next,*next2;
	int 	len;

	if (strncmp(name,":UDP",4) == 0 ) proto=17;
	else if (strncmp(name,":TCP",4) == 0 ) proto=6;
	else return 0;

	if ( (next=strchr(name,'/') ) == 0 ) return 0;
	if ( (next2=strchr(++next,'/') ) == 0 ) return 0;
	len=next2-next;
	if (len > 49 ) return 0;
	strncpy(host,next,len);
	host[len]=0;
	len=open_net1(host,atoi(++next2),proto);
	if ( len ) {
			fp->desc.ptr=(char *)len;
			fp->flags=_IONETWORK|_IOUSE;
			fp->ungetc=0;
			return 1;
	}
	return 0;	/* Failed */
}

int open_net1(char *host, int port, int proto)
{
	ipaddr_t addr;
	SOCKET *s;
	int ret;

	addr=resolve(host);

	if (addr == 0L ) return 0;

	s=sock_open(addr,port,0,proto);


	if (s == 0 ) {
		return 0;	/* No socket created */
	}

	switch ( (char) sock_waitopen(s) ) {
		case 0:		/* Closed */
		case -1:	/* abort */
			sock_shutdown(s);
			return 0;
		case 1:
			return s;
	}
}
