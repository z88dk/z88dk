
#include "mysock.h"



#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <poll.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/time.h>


static const int rand_port_dbg=0;
static const int socket_dbg=0;
static const int dbg=0;

static const int traffic_dbg=0;

int mysock_create_listener(int use_socket)
{
  int stat;
  struct sockaddr_in sin;

  int acceptor;
  
  acceptor=socket(AF_INET, SOCK_STREAM, 0);
  
  /** TODO: Can't seem to find right setsockopt to allow
   *  for reusing the port 
   */

  memset(&sin, 0, sizeof(sin));
  sin.sin_family=AF_INET;
  sin.sin_port=htons(use_socket);
  sin.sin_addr.s_addr=inet_addr("0.0.0.0");
  stat=bind(acceptor, (struct sockaddr*)&sin, sizeof(sin));
  
  if (stat != 0)
    {
      perror("bind failed");
      exit(1);
    }
  
  stat=listen(acceptor, 1);
  
  if (stat != 0)
    {
      perror("listen failed");
      exit(1);
    }

  return acceptor;
}

int mysock_create_listener_random(int* use_socketp)
{
  int stat, i, rand_port;
  struct sockaddr_in sin;

  int acceptor;
  
  static int ftf=1;

  if (ftf)
    {
      /** First call? randomize */
      struct timeval tm;
      
      gettimeofday(&tm, NULL);
      
      srand(tm.tv_usec + tm.tv_sec);
      ftf=0;
    }

  acceptor=socket(AF_INET, SOCK_STREAM, 0);
  
  for (i=1;i<=1000;i++)
    {
      rand_port=rand()%65536;
      
      if (rand_port_dbg) printf("Trying rand_port=%d\n", rand_port);
      
      memset(&sin, 0, sizeof(sin));
      sin.sin_family=AF_INET;
      sin.sin_port=htons(rand_port);
      sin.sin_addr.s_addr=inet_addr("0.0.0.0");
      stat=bind(acceptor, (struct sockaddr*)&sin, sizeof(sin));
      if (stat == 0)  break;
    }

  if (stat != 0)
    {
      perror("bind failed");
      exit(1);
    }
  
  stat=listen(acceptor, 1);
  
  if (stat != 0)
    {
      perror("listen failed");
      exit(1);
    }

  *use_socketp=rand_port;

  return acceptor;
}

int mysock_get_incoming_connection(int acceptor)
{
  /** Check for incoming connection */
  int trafficfd;
  struct sockaddr_in sin;
  socklen_t slen=sizeof(struct sockaddr);
  struct pollfd pfd;

  
  pfd.fd=acceptor;
  pfd.events=POLLIN;
  pfd.revents=0;

  if (dbg) fprintf(stderr, "Before poll...\n");
  if (dbg) fprintf(stderr, "acceptor=%d\n", acceptor);
  
  /** No connection yet... */
  if (1!=poll(&pfd, 1, -1)) return -1;
  
  if (dbg) fprintf(stderr, "After poll...\n");

  trafficfd=accept(acceptor, (struct sockaddr*)&sin, &slen);
  return trafficfd;
}


/** 
 *  Read data once, at most size bytes, if the read timeout
 *  more that ms_timeout, return with nothing read
 *
 * If -1 is returned the socket has closed
 */
int mysock_read_data(int sock, char *buf, int size, int ms_timeout)
{
  int no_read;
  
  struct pollfd pfd;

  pfd.fd=sock;
  pfd.events=POLLIN;
  pfd.revents=0;
  
  if (0==poll(&pfd, 1, ms_timeout)) return 0;
  
  if ((pfd.revents & POLLIN) != 0)
    {
      no_read=read(sock,buf, size);
      if (-1==no_read)
	{
	  perror("mysock_read_data: Read failed on socket\n");
	  exit(1);
	}
      if (no_read == 0)
	{
	  return -1;
	}
    }
  
  if (traffic_dbg) 
  {
    fwrite(buf, sizeof(char), no_read, stdout);
  }

  return no_read;
}

void mysock_write_persist(int sock, const char* str, int sz)
{
  int sent_this_time=0;
  int sent_tot=0;

  while (1)
    {
      sent_this_time=write(sock, str+sent_tot, sz-sent_tot);

	if (sent_this_time<=0)
	  {
	    perror("Write failed");
	    exit(1);
	  }
      sent_tot+=sent_this_time;

      if (sent_tot>sz)
	{
	  char tmp[1024];
	  sprintf(tmp, "Write sent more than expected sent_tot=%d, sz=%d, sent_this_time=%d\n", sent_tot, sz, sent_this_time);
	  perror(tmp);
	  exit(1);
	}
      if (sent_tot==sz)
      {
	  if (traffic_dbg) 
	  {
	    fwrite(str, sizeof(char), sz, stdout);
	  }

	  return;
      }
    }
}


int mysock_connect_socket(const char* host, unsigned port)
{
  int myfd;
  struct sockaddr_in sin;
  memset(&sin, 0, sizeof(sin));
  
  sin.sin_family=AF_INET;
  sin.sin_addr.s_addr=inet_addr(host);
  sin.sin_port=htons((u_int16_t)port);
  
  if (socket_dbg) fprintf(stderr, "sin.sin_port=%d\n", sin.sin_port);
  
  /** port is socket number for != 0 */
  myfd=socket(PF_INET, SOCK_STREAM, 0);
  
  if (0!=connect(myfd, (const  struct sockaddr *)&sin, sizeof(sin)))
    {
      perror("mysock.cc, connect failed\n");
      exit(1);
    }
  return myfd;
}

