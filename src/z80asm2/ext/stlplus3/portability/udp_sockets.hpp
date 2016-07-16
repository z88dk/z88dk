#ifndef STLPLUS_UDP_SOCKET
#define STLPLUS_UDP_SOCKET
////////////////////////////////////////////////////////////////////////////////

// Author:    Andy Rushton
// Copyright: (c) Southampton University 1999-2004
//            (c) Andy Rushton           2004 onwards
// License:   BSD License, see ../docs/license.html

// A platform-independent (Unix and Windows anyway) interface to UDP sockets

////////////////////////////////////////////////////////////////////////////////

#include "portability_fixes.hpp"
#include "ip_sockets.hpp"
#include <string>

namespace stlplus
{

  //////////////////////////////////////////////////////////////////////////////
  // UDP client - creates a connectioned socket

  class UDP_client : protected IP_socket
  {
  public:

    // create an uninitialised socket
    UDP_client(void);

    // Send/Receive datagram packets to/from the given address/remote port on the local port.
    // - remote_address: IP name or number of remote host
    // - remote_port: port number of remote host
    // - local_port: port number to receive on - 0 to get an ephemeral port.
    UDP_client(const std::string& remote_address, unsigned short remote_port, unsigned short local_port=0);

    // Send/Receive datagram packets to/from the given address/remote port on the given local port
    // Enables default send to remote address/port
    // - remote_address: IP address of remote host - pre-looked-up using ip_lookup
    // - remote_port: port number of remote host
    // - local_port: port number to receive on - 0 to get an ephemeral port.
    UDP_client(unsigned long remote_address, unsigned short remote_port, unsigned short local_port=0);

    ////////////////////////////////////////////////////////////////////////////
    // initialisation, connection

    // function for performing IP lookup (i.e. gethostbyname)
    // could be standalone but making it a member means that it can use the socket's error handler
    // i.e. if this fails, the sockets error code will be set - clear it to use the socket again
    // - remote_address: IP name (stlplus.sourceforge.net) or dotted number (216.34.181.96)
    // - returns the IP address as a long integer - zero if there's an error
    // unsigned long ip_lookup(const std::string& remote_address);
    using IP_socket::ip_lookup;

    // Send/Receive datagram packets to/from the given address/remote port on the local port.
    // Enables default send to remote address/port
    // - remote_address: IP name or number of remote host
    // - remote_port: port number of remote host
    // - local_port: port number to receive on - 0 to get an ephemeral port.
    // - returns a success flag
    bool initialise(const std::string& remote_address, unsigned short remote_port, unsigned short local_port=0);

    // Send/Receive datagram packets to/from the given address/remote port on the given local port
    // Enables default send to remote address/port
    // - remote_address: IP address of remote host - pre-looked-up using ip_lookup
    // - remote_port: port number of remote host
    // - local_port: port number to receive on - 0 to get an ephemeral port.
    // - returns a success flag
    bool initialise(unsigned long remote_address, unsigned short remote_port, unsigned short local_port=0);

    // test whether this is an initialised socket
    // - returns whether this is initialised
    // bool initialised(void) const;
    using IP_socket::initialised;

    // close, i.e. disconnect the socket
    // - returns a success flag
    // bool close(void);
    using IP_socket::close;

    ////////////////////////////////////////////////////////////////////////////
    // sending/receiving

    // test whether a socket is connected and ready to send data, returns if ready or on timeout
    // - timeout: how long to wait in microseconds if not connected yet (blocking)
    // - returns status
    // bool send_ready(unsigned timeout = 0);
    using IP_socket::send_ready;

    // send to the remote address/port setup in initialise, from the local port also setup in initialise.
    // send data through the socket as a single datagram
    // - packet: string containing data to be sent - if data is successfully sent it is removed
    // - returns success flag
    bool send(std::string& packet);

    // test whether a socket is connected and ready to receive data, returns if ready or on timeout
    // - timeout: how long to wait in microseconds if not connected yet (blocking)
    // - returns status
    // bool receive_ready(unsigned timeout = 0);
    using IP_socket::receive_ready;

    // datagram receive
    // - packet: string to receive data from datagram - if data is successfully sent it is appended
    // - returns success flag - i.e. packet successfully received
    bool receive(std::string& packet);

    ////////////////////////////////////////////////////////////////////////////
    // informational

    // the local port number of the connection
    // returns the port number, 0 if not bound to a port
    // unsigned short local_port(void) const;
    using IP_socket::local_port;

    // the remote address of the connection
    // returns the address, 0 if ANY address
    // unsigned long remote_address(void) const;
    using IP_socket::remote_address;

    // the remote port number of the connection
    // returns the port number, 0 if not bound to a port
    // unsigned short remote_port(void) const;
    using IP_socket::remote_port;

    ////////////////////////////////////////////////////////////////////////////
    // error handling
    // errors are set internally
    // an error code of 0 is the test for no error, don't rely on the message being an empty string
    // an error code != 0 means an error, then there will be a message explaining the error

    // if an error is set it stays set - so you must clear it before further operations
    // void clear_error (void);
    using IP_socket::clear_error ;

    // get the error code of the last error
    // int error(void) const;
    using IP_socket::error;

    // get the explanatory message of the last error
    // std::string message(void) const;
    using IP_socket::message;

    ////////////////////////////////////////////////////////////////////////////

  private:
    IP_socket m_socket;
  };

  ////////////////////////////////////////////////////////////////////////////////
  // UDP server - creates a connectionless (multicast) listener socket

  class UDP_server : protected IP_socket
  {
  public:

    // create an uninitialised socket
    UDP_server(void);

    // Initialise socket.
    // Receive datagram packets from any address on provided local receiving port.
    // - local_port: port number to receive on - 0 to get an ephemeral port.
    UDP_server(unsigned short local_port);

    ////////////////////////////////////////////////////////////////////////////
    // initialisation, connection

    // function for performing IP lookup (i.e. gethostbyname)
    // could be standalone but making it a member means that it can use the socket's error handler
    // i.e. if this fails, the sockets error code will be set - clear it to use the socket again
    // - remote_address: IP name (stlplus.sourceforge.net) or dotted number (216.34.181.96)
    // - returns the IP address as a long integer - zero if there's an error
    // unsigned long ip_lookup(const std::string& remote_address);
    using IP_socket::ip_lookup;

    // Initialise socket.
    // Receive datagram packets from any address on provided local receiving port.
    // - local_port: port number to receive on - 0 to get an ephemeral port.
    // - returns a success flag
    bool initialise(unsigned short local_port);

    // test whether this is an initialised socket
    // - returns whether this is initialised
    // bool initialised(void) const;
    using IP_socket::initialised;

    // close, i.e. disconnect the socket
    // - returns a success flag
    // bool close(void);
    using IP_socket::close;

    ////////////////////////////////////////////////////////////////////////////
    // sending/receiving

    // test whether a socket is connected and ready to send data, returns if ready or on timeout
    // - timeout: how long to wait in microseconds if not connected yet (blocking)
    // - returns status
    // bool send_ready(unsigned timeout = 0);
    using IP_socket::send_ready;

    // send to the address/port given here, from the local port setup in initialise.
    // send data through the socket as a single datagram
    // - packet: string containing data to be sent - if data is successfully sent it is removed
    // - remote_address: IP name (stlplus.sourceforge.net) or dotted number (216.34.181.96)
    // - remote_port: port number of remote host
    // - returns success flag
    bool send(std::string& packet, const std::string& remote_address, unsigned short remote_port);

    // send to the address/port given here, from the local port setup in initialise.
    // send data through the socket as a single datagram
    // - packet: string containing data to be sent - if data is successfully sent it is removed
    // - remote_address: pre-looked-up IP address of remote host
    // - remote_port: port number of remote host
    // - returns success flag
    bool send(std::string& packet, unsigned long remote_address, unsigned short remote_port);

    // test whether a socket is connected and ready to receive data, returns if ready or on timeout
    // - timeout: how long to wait in microseconds if not connected yet (blocking)
    // - returns status
    // bool receive_ready(unsigned timeout = 0);
    using IP_socket::receive_ready;

    // datagram receive
    // - packet: string to receive data from datagram - if data is successfully sent it is appended
    // - remote_address: the address of the client that sent the packet, can then be used to reply
    // - remote_port: the port of the client that sent the packet, can then be used to reply
    // - returns success flag - i.e. packet successfully received
    bool receive(std::string& packet, unsigned long& remote_address, unsigned short& remote_port);

    ////////////////////////////////////////////////////////////////////////////
    // informational

    // the local port number of the connection
    // returns the port number, 0 if not bound to a port
    // unsigned short local_port(void) const;
    using IP_socket::local_port;

    ////////////////////////////////////////////////////////////////////////////
    // error handling
    // errors are set internally
    // an error code of 0 is the test for no error, don't rely on the message being an empty string
    // an error code != 0 means an error, then there will be a message explaining the error

    // if an error is set it stays set - so you must clear it before further operations
    // void clear_error(void);
    using IP_socket::clear_error;

    // get the error code of the last error
    // int error(void) const;
    using IP_socket::error;

    // get the explanatory message of the last error
    // std::string message(void) const;
    using IP_socket::message;

    ////////////////////////////////////////////////////////////////////////////
  };

  /////////////////////////////////////////////////////////////////////////////
  // fire and forget UDP client packet send function

  bool UDP_send(const std::string& packet,
                const std::string& remote_address, unsigned short remote_port, unsigned short local_port = 0);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
