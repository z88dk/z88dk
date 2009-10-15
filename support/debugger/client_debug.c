
/** This is the client program which talks via localhost socket to target */


#include "mysock.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>

int main(int argc, const char *argv[])
{
  int portno;
  int sock;

  fd_set fs;

  if (argc!=2)
    {
      fprintf(stderr, "Usage: debug_client <portno>\n");
      exit(1);
    }
  
  portno=atoi(argv[1]);

  sock=mysock_connect_socket("127.0.0.1", portno);

  if (sock <= 0)
    {
      fprintf(stderr, "Connect failed\n");
      exit(1);
    }
  
  while (1)
    {
      /** Either we get something on stdin which goes to the socket or we get something on 
       *  socket that should go to stdout
       */
      FD_ZERO(&fs);
      FD_SET(sock, &fs);
      FD_SET(0, &fs);
      
      select(sock+1, &fs, NULL, NULL, NULL);
      
      if (FD_ISSET(sock, &fs))
	{
	  char tmp[1024];
	  int n_read;
	  
	  n_read=mysock_read_data(sock, tmp, 1024, 0);

	  if (n_read<=0)
	    {
	      fprintf(stderr, "Connection terminated.\n");
	      exit(0);
	    }

	  fwrite(tmp, sizeof(char), n_read, stdout);
	  fflush(stdout);
	}
      
      if (FD_ISSET(0, &fs))
	{
	  char tmp[1024];
	  int n_read;

	  fgets(tmp, 1024, stdin);
	  mysock_write_persist(sock, tmp, strlen(tmp));
	}
      
    }
  
}
