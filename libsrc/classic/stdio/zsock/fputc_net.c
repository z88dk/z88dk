/*
 *	Write byte to socket using stdio library
 *
 *	djm 25/4/2000
 *	
 *	$Id: fputc_net.c,v 1.2 2001-04-13 14:14:00 stefano Exp $
 */


#include <stdio.h>
#include <net/socket.h>
#include <net/misc.h>

int fputc_net(SOCKET *s, int c)
{
	int	num=0;

	while (num==0) {
		GoTCP();

		num=sock_putc(c,s);
		iferror	return EOF;
	}
	return(c);
}


