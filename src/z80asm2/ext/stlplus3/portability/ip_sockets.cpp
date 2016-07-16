////////////////////////////////////////////////////////////////////////////////

// Author:    Andy Rushton
// Copyright: (c) Southampton University 1999-2004
//            (c) Andy Rushton           2004 onwards
// License:   BSD License, see ../docs/license.html

// Contains all the platform-specific socket handling used by the TCP and UDP classes

// TODO - any conversion required to support IPv6

////////////////////////////////////////////////////////////////////////////////

#include "ip_sockets.hpp"
#include "dprintf.hpp"
#include <string.h>

#ifdef MSWINDOWS
// Windoze-specific includes

#include <winsock2.h>
#define ERRNO WSAGetLastError()
#define HERRNO WSAGetLastError()
#define IOCTL ioctlsocket
#define CLOSE closesocket
#define SHUT_RDWR SD_BOTH
#define SOCKLEN_T int
#define SEND_FLAGS 0
// on Windows, these options have a different prefix but the same function as on Unix
#define INPROGRESS WSAEINPROGRESS
#define WOULDBLOCK WSAEWOULDBLOCK
#define CONNRESET WSAECONNRESET

#else

// Generic Unix includes
// fix for older versions of Darwin?
#define _BSD_SOCKLEN_T_ int
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <errno.h>
#include <netdb.h>
#include <unistd.h>
#define INVALID_SOCKET -1
#define ERRNO errno
#define HERRNO h_errno
#define SOCKET int
#define SOCKET_ERROR -1
#define IOCTL ::ioctl
#define CLOSE ::close
#define SOCKLEN_T socklen_t
#ifdef __APPLE__
// fix from IngwiePhoenix for OSX
// https://github.com/Deskshell-Core/PhoenixEngine
#define SEND_FLAGS SO_NOSIGPIPE
#else
#define SEND_FLAGS MSG_NOSIGNAL
#endif
#define INPROGRESS EINPROGRESS
#define WOULDBLOCK EWOULDBLOCK
#define CONNRESET ECONNRESET

#ifdef SOLARIS
// Sun put some definitions in a different place
#include <sys/filio.h>
#endif
#endif

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // Utilities

  // get an operating-system error message given an error code
  static std::string error_string(int error)
  {
    std::string result = "error " + dformat("%d",error);
#ifdef MSWINDOWS
    char* message = 0;
    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_IGNORE_INSERTS,
                  0,
                  error,
                  MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // "User default language"
                  (LPTSTR)&message,
                  0,0);
    if (message)
    {
      result = message;
      LocalFree(message);
    }
    // the error message is for some perverse reason newline terminated - remove this
    if (result[result.size()-1] == '\n')
      result.erase(result.end()-1);
    if (result[result.size()-1] == '\r')
      result.erase(result.end()-1);
#else
    char* message = strerror(error);
    if (message && message[0])
      result = message;
#endif
    return result;
  }

  // convert address:port into a sockaddr
  static void convert_address(unsigned long address, unsigned short port, sockaddr& sa)
  {
    sa.sa_family = AF_INET;
    unsigned short network_port = htons(port);
    memcpy(&sa.sa_data[0], &network_port, sizeof(network_port));
    unsigned long network_address = htonl(address);
    memcpy(&sa.sa_data[2], &network_address, sizeof(network_address));
  }

//   // convert host:port into a sockaddr
//   static void convert_host(hostent& host, unsigned short port, sockaddr& sa)
//   {
//     sa.sa_family = host.h_addrtype;
//     unsigned short network_port = htons(port);
//     memcpy(&sa.sa_data[0], &network_port, sizeof(network_port));
//     memcpy(&sa.sa_data[2], host.h_addr, host.h_length);
//   }

  // convert sockaddr to address:port
  static void convert_sockaddr(const sockaddr& sa, unsigned long& address, unsigned short& port)
  {
    unsigned short network_port = 0;
    memcpy(&network_port, &sa.sa_data[0], sizeof(network_port));
    port = ntohs(network_port);
    unsigned long network_address = 0;
    memcpy(&network_address, &sa.sa_data[2], sizeof(network_address));
    address = ntohl(network_address);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Initialisation
  // Windows requires that Winsock is initialised before use and closed after
  // These routines initialise once on first use and close on the destruction of the last object using it
  // on non-windows platforms, I still increment/decrement the sockets count variable for diagnostic purposes

  static int sockets_count = 0;

  static int sockets_init(void)
  {
    int error = 0;
    if (sockets_count++ == 0)
    {
#ifdef MSWINDOWS
      WSAData winsock_info;
      // request Winsock 2.0 or higher
      error = WSAStartup(MAKEWORD(2,0),&winsock_info);
#endif
    }
    return error;
  }

  static int sockets_close(void)
  {
    int error = 0;
    if (--sockets_count == 0)
    {
#ifdef MSWINDOWS
      if (WSACleanup() == SOCKET_ERROR)
        error = ERRNO;
#endif
    }
    return error;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Socket Implementation - common code to manipulate a TCP socket

  class IP_socket_internals
  {
  private:
    IP_socket_type m_type;
    SOCKET m_socket;
    unsigned long m_remote_address;
    unsigned short m_remote_port;
    mutable int m_error;
    mutable std::string m_message;
    unsigned m_count;

    // disable copying of the internals
    IP_socket_internals(const IP_socket_internals&);
    IP_socket_internals& operator=(const IP_socket_internals&);

  public:

    ////////////////////////////////////////////////////////////////////////////
    // PIMPL alias counting

    void increment(void)
      {
        ++m_count;
      }

    bool decrement(void)
      {
        --m_count;
        return m_count == 0;
      }

    ////////////////////////////////////////////////////////////////////////////
    // constructors/destructors

    // construct an invalid socket
    IP_socket_internals(void) : m_type(undefined_socket_type), m_socket(INVALID_SOCKET), m_error(0), m_count(1)
      {
        set_error(sockets_init());
      }

    // close on destroy
    ~IP_socket_internals(void)
      {
        close();
        set_error(sockets_close());
      }

    ////////////////////////////////////////////////////////////////////////////
    // initialisation, connection

    bool initialised(void) const
      {
        return m_socket != INVALID_SOCKET;
      }

    // attach this object to a pre-opened socket
    bool set(SOCKET socket, unsigned long remote_address, unsigned short remote_port)
      {
        if (initialised()) close();
        clear_error();
        m_socket = socket;
        m_remote_address = remote_address;
        m_remote_port = remote_port;
        return true;
      }

    // create a raw socket attached to this object
    bool initialise(IP_socket_type type)
      {
        if (initialised()) close();
        clear_error();
        if ((type != TCP) && (type != UDP))
        {
          set_error(-1, "Illegal socket type");
          return false;
        }
        // create an anonymous socket
        m_socket = ::socket(AF_INET, ((type == TCP) ? SOCK_STREAM : SOCK_DGRAM), 0);
        if (m_socket == INVALID_SOCKET)
        {
          set_error(ERRNO);
          close();
          return false;
        }
        // record the type on success only
        m_type = type;
        // set the socket into non-blocking mode
        unsigned long nonblocking = 1;
        if (IOCTL(m_socket, FIONBIO, &nonblocking) == SOCKET_ERROR)
        {
          set_error(ERRNO);
          return false;
        }
        return true;
      }

    // function for performing IP lookup (i.e. gethostbyname)
    // could be standalone but making it a member means that it can use the socket's error handler
    // - remote_address: IP name or number
    // - returns the IP address as a number - zero if there's an error
    unsigned long ip_lookup(const std::string& remote_address)
      {
        unsigned long result = 0;
        // Lookup the IP address to convert it into a host record
        // this DOES lookup IP address names as well (not according to MS help !!)
        // TODO - convert this to use ::getaddrinfo - ::gethostbyname is deprecated
        hostent* host_info = ::gethostbyname(remote_address.c_str());
        if (!host_info)
        {
          set_error(HERRNO);
          return 0;
        }
        // extract the address from the host info
        unsigned long network_address = 0;
        memcpy(&network_address, host_info->h_addr, host_info->h_length);
        result = ntohl(network_address);
        return result;
      }

    // tests whether a socket is ready for communication
    bool select(bool readable, bool writeable, unsigned wait)
      {
        if (!initialised()) return false;
        // set up the readable set
        fd_set readable_set;
        fd_set* readable_set_ptr = 0;
        if (readable)
        {
          FD_ZERO(&readable_set);
          FD_SET(m_socket,&readable_set);
          readable_set_ptr = &readable_set;
        }
        // set up the writeable set
        fd_set writeable_set;
        fd_set* writeable_set_ptr = 0;
        if (writeable)
        {
          FD_ZERO(&writeable_set);
          FD_SET(m_socket,&writeable_set);
          writeable_set_ptr = &writeable_set;
        }
        // TODO - check the error set and lookup the error?
        fd_set* error_set_ptr = 0;
        // set up the timout value
        // Note: a null pointer implements a blocking select
        //       a pointer to a zero value implements a zero-wait poll
        //       a pointer to a positive value implements a poll with a timeout
        // I currently only implement polling with timeout which may be zero  - no blocking
        timeval timeout;
        timeval* timeout_ptr = 0;
        timeout.tv_sec = wait/1000000;
        timeout.tv_usec = wait%1000000;
        timeout_ptr = &timeout;
        // now test the socket
        int select_result = ::select(m_socket+1, readable_set_ptr, writeable_set_ptr, error_set_ptr, timeout_ptr);
        switch(select_result)
        {
        case SOCKET_ERROR:
          // select failed with an error - trap the error
          set_error(ERRNO);
          return false;
        case 0:
          // timeout exceeded without a connection appearing
          return false;
        default:
          // at least one connection is pending
          // TODO - do we need to do the extra socket options checking on Posix?
          // TODO - does this connect in any way to the error_set above?
          return true;
        }
      }

    // bind the socket to a port so that it can receive from specific address
    bool bind(unsigned long remote_address, unsigned short local_port)
      {
        if (!initialised()) return false;
        // name the socket and bind it to a port - this is a requirement for a server
        sockaddr server;
        convert_address(INADDR_ANY, local_port, server);
        if (::bind(m_socket, &server, sizeof(server)) == SOCKET_ERROR)
        {
          set_error(ERRNO);
          close();
          return false;
        }
        return true;
      }

    // bind the socket to a port so that it can receive from any address
    bool bind_any(unsigned short local_port)
      {
        return bind(INADDR_ANY, local_port);
      }

    // set this socket up to be a listening port
    // must have been bound to a local port already
    // - length of backlog queue to manage - may be zero
    // - returns success status
    bool listen(unsigned short queue)
      {
        if (!initialised()) return false;
        // set the port to listen for incoming connections
        if (::listen(m_socket, (int)queue) == SOCKET_ERROR)
        {
          set_error(ERRNO);
          close();
          return false;
        }
        return true;
      }

    // test whether there's an incoming connection on the socket
    // only applicable if it has been set up as a listening port
    bool accept_ready(unsigned wait)
      {
        // the test for a connection being ready is the same as the test for whether the socket is readable
        // see documentation for select
        return select(true, false, wait);
      }

    // accept a connection on the socket
    // only applicable if it has been set up as a listening port
    // - returns socket filled in with the accepted connection's details - or with the error fields set
    IP_socket accept(void)
      {
        if (!initialised()) return IP_socket();
        IP_socket result;
        // accept the connection, at the same time getting the address of the connecting client
        sockaddr saddress;
        SOCKLEN_T saddress_length = sizeof(saddress);
        SOCKET socket = ::accept(m_socket, &saddress, &saddress_length);
        if (socket == INVALID_SOCKET)
        {
          // only set the result socket with an error
          result.m_impl->set_error(ERRNO);
          return result;
        }
        // extract the contents of the address
        unsigned long remote_address = 0;
        unsigned short remote_port = 0;
        convert_sockaddr(saddress, remote_address, remote_port);
        result.m_impl->set(socket, remote_address, remote_port);
        return result;
      }

    // client connect to a server
    // - remote_address: IP number of remote address to connect to
    // - remote_port: port to connect to
    bool connect(unsigned long remote_address, unsigned short remote_port)
      {
        if (!initialised()) return false;
        // fill in the connection data structure
        sockaddr connect_data;
        convert_address(remote_address, remote_port, connect_data);
        // connect binds the socket to a local address
        // if connectionless it simply sets the default remote address
        // if connectioned it makes the connection
        if (::connect(m_socket, &connect_data, sizeof(connect_data)) == SOCKET_ERROR)
        {
          // the socket is non-blocking, so connect will almost certainly fail with INPROGRESS which is not an error
          // only catch real errors
          int error = ERRNO;
          if (error != INPROGRESS && error != WOULDBLOCK)
          {
            set_error(error);
            return false;
          }
        }
        // extract the remote connection details for local storage
        convert_sockaddr(connect_data, m_remote_address, m_remote_port);
        return true;
      }

    // test whether a socket is connected and ready to communicate
    bool connected(unsigned wait)
      {
        if (!initialised()) return false;
        // Gnu/Linux and Windows docs say test with select for whether socket is
        // writable. However, a problem has been reported with Gnu/Linux whereby
        // the OS will report a socket as writable when it isn't
        // first use the select method
        if (!select(false, true, wait))
          return false;
#ifdef MSWINDOWS
        // Windows needs no further processing - select method works
        return true;
#else
        // Posix version needs further checking using the socket options
        // http://linux.die.net/man/2/connect see description of EINPROGRESS
        // DJDM: socket has returned INPROGRESS on the first attempt at connection
        // it has also returned that it can be written to
        // we must now ask it if it has actually connected - using getsockopt
        int error = 0;
        socklen_t serror = sizeof(int);
        if (::getsockopt(m_socket, SOL_SOCKET, SO_ERROR, &error, &serror) == 0)
          // handle the error value - the EISCONN error actually means that the socket has connected (so no error then)
          if (!error || error == EISCONN)
            return true;
        return false;
#endif
      }

    bool close(void)
      {
        bool result = true;
        if (initialised())
        {
          if (shutdown(m_socket,SHUT_RDWR) == SOCKET_ERROR)
          {
            set_error(ERRNO);
            result = false;
          }
          if (CLOSE(m_socket) == SOCKET_ERROR)
          {
            set_error(ERRNO);
            result = false;
          }
        }
        m_socket = INVALID_SOCKET;
        m_remote_address = 0;
        m_remote_port = 0;
        return result;
      }

    ////////////////////////////////////////////////////////////////////////////
    // sending/receiving

    bool send_ready(unsigned wait)
      {
        // determines whether the socket is ready to send by testing whether it is writable
        return select(false, true, wait);
      }

    bool send (std::string& data)
      {
        if (!initialised()) return false;
        // send the data - this will never block but may not send all the data
        int bytes = ::send(m_socket, data.c_str(), (int)data.size(), SEND_FLAGS);
        if (bytes == SOCKET_ERROR)
        {
          set_error(ERRNO);
          return false;
        }
        // remove the sent bytes from the data buffer so that the buffer represents the data still to be sent
        data.erase(0,bytes);
        return true;
      }

    bool send_packet(std::string& data, unsigned long address = 0, unsigned short port = 0)
      {
        if (!initialised()) return false;
        // if no address specified, rely on the socket having been connected (can I test this?)
        // so use the standard send, otherwise use the sendto function
        int bytes = 0;
        if (!address)
        {
          bytes = ::send(m_socket, data.c_str(), (int)data.size(), SEND_FLAGS);
        }
        else
        {
          sockaddr saddress;
          convert_address(address, port, saddress);
          bytes = ::sendto(m_socket, data.c_str(), (int)data.size(), SEND_FLAGS, &saddress, sizeof(saddress));
        }
        if (bytes == SOCKET_ERROR)
        {
          set_error(ERRNO);
          return false;
        }
        // remove the sent bytes from the data buffer so that the buffer represents the data still to be sent
        data.erase(0,bytes);
        return true;
      }

    bool receive_ready(unsigned wait)
      {
        // determines whether the socket is ready to receive by testing whether it is readable
        return select(true, false, wait);
      }

    bool receive (std::string& data)
      {
        if (!initialised()) return false;
        // determine how much data is available to read
        unsigned long bytes = 0;
        if (IOCTL(m_socket, FIONREAD, &bytes) == SOCKET_ERROR)
        {
          set_error(ERRNO);
          return false;
        }
        // get the data up to the amount claimed to be present - this is non-blocking
        char* buffer = new char[bytes+1];
        int read = ::recv(m_socket, buffer, bytes, 0);
        if (read == SOCKET_ERROR)
        {
          delete[] buffer;
          set_error(ERRNO);
          close();
          return false;
        }
        if (read == 0)
        {
          // TODO - check whether this is an appropriate conditon to close the socket
          close();
        }
        else
        {
          // this is binary data so copy the bytes including nulls
          data.append(buffer,read);
        }
        delete[] buffer;
        return true;
      }

    bool receive_packet(std::string& data, unsigned long& address, unsigned short& port)
      {
        if (!initialised()) return false;
        // determine how much data is available to read
        unsigned long bytes = 0;
        if (IOCTL(m_socket, FIONREAD, &bytes) == SOCKET_ERROR)
        {
          set_error(ERRNO);
          return false;
        }
        // get the data up to the amount claimed to be present - this is non-blocking
        // also get the sender's details
        char* buffer = new char[bytes+1];
        sockaddr saddress;
        SOCKLEN_T saddress_length = sizeof(saddress);
        int read = ::recvfrom(m_socket, buffer, bytes, 0, &saddress, &saddress_length);
        if (read == SOCKET_ERROR)
        {
          // UDP connection reset means that a previous sent failed to deliver cos the address was unknown
          // this is NOT an error with the sending server socket, which IS still usable
          int error = ERRNO;
          if (error != CONNRESET)
          {
            delete[] buffer;
            set_error(error);
            close();
            return false;
          }
        }
        // this is binary data so copy the bytes including nulls
        data.append(buffer,read);
        // also retrieve the sender's details
        convert_sockaddr(saddress, address, port);
        delete[] buffer;
        return true;
      }

    bool receive_packet(std::string& data)
      {
        // call the above and then discard the address details
        unsigned long address = 0;
        unsigned short port = 0;
        return receive_packet(data, address, port);
      }

    ////////////////////////////////////////////////////////////////////////////
    // informational

    IP_socket_type type(void) const
      {
        return m_type;
      }

    unsigned short local_port(void) const
      {
        if (!initialised()) return 0;
        sockaddr saddress;
        SOCKLEN_T saddress_length = sizeof(saddress);
        if (::getsockname(m_socket, &saddress, &saddress_length) != 0)
        {
          set_error(ERRNO);
          return 0;
        }
        unsigned long address = 0;
        unsigned short port = 0;
        convert_sockaddr(saddress, address, port);
        return port;
      }

    unsigned long remote_address(void) const
      {
        return m_remote_address;
      }

    unsigned short remote_port(void) const
      {
        return m_remote_port;
      }

    ////////////////////////////////////////////////////////////////////////////
    // error handling

    void set_error (int error, const char* message = 0) const
      {
        if (error != 0)
        {
          m_error = error;
          if (message && (message[0] != 0))
            m_message = message;
          else
            m_message = error_string(error);
        }
      }

    int error(void) const
      {
        return m_error;
      }

    void clear_error (void) const
      {
        m_error = 0;
        m_message.erase();
      }

    std::string message(void) const
      {
        return m_message;
      }

  };

  ////////////////////////////////////////////////////////////////////////////////
  // Socket - common code to manipulate a socket

  // create an uninitialised socket
  IP_socket::IP_socket(void) : m_impl(new IP_socket_internals)
  {
  }

  // create an initialised socket
  // - type: create either a TCP or UDP socket - if neither, creates an uninitialised socket
  IP_socket::IP_socket(IP_socket_type type) : m_impl(new IP_socket_internals)
  {
    initialise(type);
  }

  // destroy the socket, closing it if open
  IP_socket::~IP_socket(void)
  {
    if (m_impl->decrement())
      delete m_impl;
  }

  ////////////////////////////////////////////////////////////////////////////
  // copying is implemented as aliasing

  IP_socket::IP_socket(const IP_socket& right) : m_impl(0)
  {
    // make this an alias of right
    m_impl = right.m_impl;
    m_impl->increment();
  }

  IP_socket& IP_socket::operator=(const IP_socket& right)
  {
    // make self-copy safe
    if (m_impl == right.m_impl) return *this;
    // first dealias the existing implementation
    if (m_impl->decrement())
      delete m_impl;
    // now make this an alias of right
    m_impl = right.m_impl;
    m_impl->increment();
    return *this;
  }

  ////////////////////////////////////////////////////////////////////////////
  // initialisation, connection

  // initialise the socket
  // - type: create either a TCP or UDP socket
  // - returns success status
  bool IP_socket::initialise(IP_socket_type type)
  {
    return m_impl->initialise(type);
  }

  // test whether this is an initialised socket
  // - returns whether this is initialised
  bool IP_socket::initialised(void) const
  {
    return m_impl->initialised();
  }

  // close, i.e. disconnect the socket
  // - returns a success flag
  bool IP_socket::close(void)
  {
    return m_impl->close();
  }

  // function for performing IP lookup (i.e. gethostbyname)
  // could be standalone but making it a member means that it can use the socket's error handler
  // - remote_address: IP name (stlplus.sourceforge.net) or dotted number (216.34.181.96)
  // - returns the IP address as a long integer - zero if there's an error
  unsigned long IP_socket::ip_lookup(const std::string& remote_address)
  {
    return m_impl->ip_lookup(remote_address);
  }

  // test whether a socket is ready to communicate
  // - readable: test whether socket is ready to read
  // - writeable: test whether a socket is ready to write
  // - timeout: if socket is not ready, time to wait before giving up - in micro-seconds - 0 means don't wait
  // returns false if not ready or error - use error() method to tell - true if ready
  bool IP_socket::select(bool readable, bool writeable, unsigned timeout)
  {
    return m_impl->select(readable, writeable, timeout);
  }

  // bind the socket to a port so that it can receive from specific address - typically used by a client
  // - remote_address: IP number of remote server to send/receive to/from
  // - local_port: port on local machine to bind to the address
  // - returns success flag
  bool IP_socket::bind(unsigned long remote_address, unsigned short local_port)
  {
    return m_impl->bind(remote_address, local_port);
  }

  // bind the socket to a port so that it can receive from any address - typically used by a server
  // - local_port: port on local machine to bind to the address
  // - returns success flag
  bool IP_socket::bind_any(unsigned short local_port)
  {
    return m_impl->bind_any(local_port);
  }

  // initialise a socket and set this socket up to be a listening port
  // - queue: length of backlog queue to manage - may be zero
  // - returns success status
  bool IP_socket::listen(unsigned short queue)
  {
    return m_impl->listen(queue);
  }

  // test for a connection on the object's socket - only applicable if it has been set up as a listening port
  // - returns true if a connection is ready to be accepted
  bool IP_socket::accept_ready(unsigned timeout) const
  {
    return m_impl->accept_ready(timeout);
  }

  // accept a connection on the object's socket - only applicable if it has been set up as a listening port
  // - returns the connection as a new socket
  IP_socket IP_socket::accept(void)
  {
    return m_impl->accept();
  }

  // client connect to a server
  // - address: IP number already lookup up with ip_lookup
  // - port: port to connect to
  // - returns a success flag
  bool IP_socket::connect(unsigned long address, unsigned short port)
  {
    return m_impl->connect(address, port);
  }

  // test whether a socket is connected and ready to communicate, returns on successful connect or timeout
  // - timeout: how long to wait in microseconds if not connected yet
  // - returns success flag
  bool IP_socket::connected(unsigned timeout)
  {
    return m_impl->connected(timeout);
  }

  ////////////////////////////////////////////////////////////////////////////
  // sending/receiving

  // test whether a socket is connected and ready to send data, returns if ready or on timeout
  // - timeout: how long to wait in microseconds if not connected yet (blocking)
  // - returns status
  bool IP_socket::send_ready(unsigned timeout)
  {
    return m_impl->send_ready(timeout);
  }

  // send data through the socket - if the data is long only part of it may
  // be sent. The sent part is removed from the data, so the same string can
  // be sent again and again until it is empty.
  // - data: string containing data to be sent - any data successfully sent is removed
  // - returns success flag
  bool IP_socket::send (std::string& data)
  {
    return m_impl->send(data);
  }

  // send data through a connectionless (UDP) socket
  // the data will be sent as a single packet
  // - packet: string containing data to be sent - any data successfully sent is removed
  // - remote_address: address of the remote host to send to - optional if the socket has been connected to remote
  // - remote_port: port of the remote host to send to - optional if the socket has been connected to remote
  // - returns success flag
  bool IP_socket::send_packet(std::string& packet, unsigned long remote_address, unsigned short remote_port)
  {
    return m_impl->send_packet(packet, remote_address, remote_port);
  }

  // send data through a connectionless (UDP) socket
  // the data will be sent as a single packet
  // only works if the socket has been connected to remote
  // - packet: string containing data to be sent - any data successfully sent is removed
  // - returns success flag
  bool IP_socket::send_packet(std::string& packet)
  {
    return m_impl->send_packet(packet);
  }

  // test whether a socket is connected and ready to receive data, returns if ready or on timeout
  // - timeout: how long to wait in microseconds if not connected yet (blocking)
  // - returns status
  bool IP_socket::receive_ready(unsigned timeout)
  {
    return m_impl->receive_ready(timeout);
  }

  // receive data through a connection-based (TCP) socket
  // if the data is long only part of it may be received. The received data
  // is appended to the string, building it up in stages, so the same string
  // can be received again and again until all information has been
  // received.
  // - data: string receiving data from socket - any data successfully received is appended
  // - returns success flag
  bool IP_socket::receive (std::string& data)
  {
    return m_impl->receive(data);
  }

  // receive data through a connectionless (UDP) socket
  // - packet: string receiving data from socket - any data successfully received is appended
  // - remote_address: returns the address of the remote host received from
  // - remote_port: returns the port of the remote host received from
  // - returns success flag
  bool IP_socket::receive_packet(std::string& packet, unsigned long& remote_address, unsigned short& remote_port)
  {
    return m_impl->receive_packet(packet, remote_address, remote_port);
  }

  // variant of above which does not give back the address and port of the sender
  // receive data through a connectionless (UDP) socket
  // - packet: string receiving data from socket - any data successfully received is appended
  // - returns success flag
  bool IP_socket::receive_packet(std::string& packet)
  {
    return m_impl->receive_packet(packet);
  }

  ////////////////////////////////////////////////////////////////////////////
  // informational

  IP_socket_type IP_socket::type(void) const
  {
    return m_impl->type();
  }

  unsigned short IP_socket::local_port(void) const
  {
    return m_impl->local_port();
  }

  unsigned long IP_socket::remote_address(void) const
  {
    return m_impl->remote_address();
  }

  unsigned short IP_socket::remote_port(void) const
  {
    return m_impl->remote_port();
  }

  ////////////////////////////////////////////////////////////////////////////
  // error handling

  void IP_socket::set_error (int error, const std::string& message) const
  {
    m_impl->set_error(error, message.c_str());
  }

  void IP_socket::clear_error (void) const
  {
    m_impl->clear_error();
  }

  int IP_socket::error(void) const
  {
    return m_impl->error();
  }

  std::string IP_socket::message(void) const
  {
    return m_impl->message();
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
