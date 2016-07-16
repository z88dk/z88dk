////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

#include "tcp_sockets.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  //////////////////////////////////////////////////////////////////////////////
  // TCP Connection


  TCP_connection::TCP_connection(const IP_socket& socket) : IP_socket(socket)
  {
  }

  TCP_connection::TCP_connection(void) : IP_socket(TCP)
  {
  }

  unsigned short TCP_connection::port(void) const
  {
    return remote_port();
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Server

  TCP_server::TCP_server(void) : IP_socket(TCP)
  {
  }

  TCP_server::TCP_server(unsigned short port, unsigned short queue) : IP_socket(TCP)
  {
    initialise(port,queue);
  }

  bool TCP_server::initialise(unsigned short port, unsigned short queue)
  {
    if (!IP_socket::bind_any(port)) return false;
    return IP_socket::listen(queue);
  }

  TCP_connection TCP_server::accept(void)
  {
    return TCP_connection(IP_socket::accept());
  }

  bool TCP_server::connection_ready(unsigned timeout)
  {
    return accept_ready(timeout);
  }

  TCP_connection TCP_server::connection(void)
  {
    return accept();
  }

  //////////////////////////////////////////////////////////////////////////////
  // Client

  TCP_client::TCP_client(void) : IP_socket(TCP)
  {
  }

  TCP_client::TCP_client(const std::string& address, unsigned short port, unsigned int timeout) : IP_socket(TCP)
  {
    initialise(address,port,timeout);
  }

  TCP_client::TCP_client(unsigned long address, unsigned short port, unsigned int timeout) : IP_socket(TCP)
  {
    initialise(address,port,timeout);
  }

  bool TCP_client::initialise(unsigned long remote_address, unsigned short remote_port, unsigned int timeout)
  {
    if (!IP_socket::connect(remote_address, remote_port))
    {
      close();
      return false;
    }
    if (timeout && !IP_socket::connected(timeout))
    {
      close();
      return false;
    }
    return true;
  }

  bool TCP_client::initialise(const std::string& address, unsigned short remote_port, unsigned int timeout)
  {
    // lookup the address and convert it into an IP number
    unsigned long remote_address = IP_socket::ip_lookup(address);
    if (!remote_address) return false;
    return initialise(remote_address, remote_port, timeout);
  }

  unsigned short TCP_client::port(void) const
  {
    return remote_port();
  }

  unsigned long TCP_client::address(void) const
  {
    return remote_address();
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
