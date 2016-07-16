#ifndef STLPLUS_IP_SOCKET
#define STLPLUS_IP_SOCKET
////////////////////////////////////////////////////////////////////////////////

// Author:    Andy Rushton
// Copyright: (c) Southampton University 1999-2004
//            (c) Andy Rushton           2004 onwards
// License:   BSD License, see ../docs/license.html

// A platform-independent (Unix and Windows anyway) interface to Internet-Protocol sockets

////////////////////////////////////////////////////////////////////////////////
#include "portability_fixes.hpp"
#include <string>

namespace stlplus
{

  //////////////////////////////////////////////////////////////////////////////
  // internals
  // use a PIMPL interface to hide the platform-specifics in the implementation

  class IP_socket_internals;

  ////////////////////////////////////////////////////////////////////////////
  // Types of socket supported

  enum IP_socket_type {undefined_socket_type = -1, TCP = 0, UDP = 1};

  //////////////////////////////////////////////////////////////////////////////
  // Socket class

  class IP_socket
  {
  public:

    ////////////////////////////////////////////////////////////////////////////
    // constructors/destructors

    // create an uninitialised socket
    IP_socket(void);

    // create an initialised socket
    // - type: create either a TCP or UDP socket
    IP_socket(IP_socket_type type);

    // destroy the socket, closing it if open
    ~IP_socket(void);

    // copying is implemented as aliasing
    IP_socket(const IP_socket&);
    IP_socket& operator=(const IP_socket&);

    ////////////////////////////////////////////////////////////////////////////
    // initialisation

    // initialise the socket
    // - type: create either a TCP or UDP socket
    // - returns success status
    bool initialise(IP_socket_type type);

    // test whether this is an initialised socket
    // - returns whether this is initialised
    bool initialised(void) const;

    // close, i.e. disconnect the socket
    // - returns a success flag
    bool close(void);

    //////////////////////////////////////////////////////////////////////////////
    // Socket configuration

    // function for performing IP lookup (i.e. gethostbyname)
    // could be standalone but making it a member means that it can use the socket's error handler
    // i.e. if this fails, the sockets error code will be set - clear it to use the socket again
    // - remote_address: IP name (stlplus.sourceforge.net) or dotted number (216.34.181.96)
    // - returns the IP address as a long integer - zero if there's an error
    unsigned long ip_lookup(const std::string& remote_address);

    // test whether a socket is ready to communicate
    // - readable: test whether socket is ready to read
    // - writeable: test whether a socket is ready to write
    // - timeout: if socket is not ready, time to wait before giving up - in micro-seconds - 0 means don't wait
    // returns false if not ready or error - use error() method to tell - true if ready
    bool select(bool readable, bool writeable, unsigned timeout = 0);

    // bind the socket to a port so that it can receive from specific address - typically used by a client
    // - remote_address: IP number of remote server to send/receive to/from
    // - local_port: port on local machine to bind to the address
    // - returns success flag
    bool bind(unsigned long remote_address, unsigned short local_port);

    // bind the socket to a port so that it can receive from any address - typically used by a server
    // - local_port: port on local machine to bind to the address
    // - returns success flag
    bool bind_any(unsigned short local_port);

    // set this socket up to be a listening port
    // socket must be bound to a port already
    // - queue: length of backlog queue to manage - may be zero meaning no queue
    // - returns success status
    bool listen(unsigned short queue = 0);

    // test for a connection on the socket
    // only applicable if it has been set up as a listening port
    // - timeout: how long to wait in microseconds if not connected yet
    // - returns true if a connection is ready to be accepted
    bool accept_ready(unsigned timeout = 0) const;

    // accept a connection on the socket
    // only applicable if it has been set up as a listening port
    // - returns the connection as a new socket
    IP_socket accept(void);

    // create a connection - usually used by a client
    // TCP: client connect to a remote server
    // UDP: setup remote address and port for sends
    // - remote_address: IP number already looked up using ip_lookup
    // - remote_port: port to connect to
    // - returns a success flag
    bool connect(unsigned long remote_address, unsigned short remote_port);

    // test whether a socket is connected and ready to communicate, returns on successful connect or timeout
    // - timeout: how long to wait in microseconds if not connected yet
    // - returns true if connected and ready to communicate, false if not ready or error
    bool connected(unsigned timeout = 0);

    ////////////////////////////////////////////////////////////////////////////
    // sending/receiving

    // test whether a socket is connected and ready to send data, returns if ready or on timeout
    // - timeout: how long to wait in microseconds if not connected yet (blocking)
    // - returns status
    bool send_ready(unsigned timeout = 0);

    // send data through a connection-based (TCP) socket
    // if the data is long only part of it may be sent. The sent part is
    // removed from the data, so the same string can be sent again and again
    // until it is empty.
    // - data: string containing data to be sent - any data successfully sent is removed
    // - returns success flag
    bool send(std::string& data);

    // send data through a connectionless (UDP) socket
    // the data will be sent as a single packet
    // - packet: string containing data to be sent - any data successfully sent is removed
    // - remote_address: address of the remote host to send to - optional if the socket has been connected to remote
    // - remote_port: port of the remote host to send to - optional if the socket has been connected to remote
    // - returns success flag
    bool send_packet(std::string& packet, unsigned long remote_address, unsigned short remote_port);

    // send data through a connectionless (UDP) socket
    // the data will be sent as a single packet
    // only works if the socket has been connected to remote
    // - packet: string containing data to be sent - any data successfully sent is removed
    // - returns success flag
    bool send_packet(std::string& packet);

    // test whether a socket is connected and ready to receive data, returns if ready or on timeout
    // - timeout: how long to wait in microseconds if not connected yet (blocking)
    // - returns status
    bool receive_ready(unsigned wait = 0);

    // receive data through a connection-based (TCP) socket
    // if the data is long only part of it may be received. The received data
    // is appended to the string, building it up in stages, so the same string
    // can be received again and again until all information has been
    // received.
    // - data: string receiving data from socket - any data successfully received is appended
    // - returns success flag
    bool receive(std::string& data);

    // receive data through a connectionless (UDP) socket
    // - packet: string receiving data from socket - any data successfully received is appended
    // - remote_address: returns the address of the remote host received from
    // - remote_port: returns the port of the remote host received from
    // - returns success flag
    bool receive_packet(std::string& packet, unsigned long& remote_address, unsigned short& remote_port);

    // variant of above which does not give back the address and port of the sender
    // receive data through a connectionless (UDP) socket
    // - packet: string receiving data from socket - any data successfully received is appended
    // - returns success flag
    bool receive_packet(std::string& packet);

    ////////////////////////////////////////////////////////////////////////////
    // informational

    // gets the type of socket
    // - returns undefined_socket_type, TCP or UDP
    IP_socket_type type(void) const;

    // the local port number of the connection
    // returns the port number, 0 if not bound to a port
    unsigned short local_port(void) const;

    // the remote address of the connection
    // returns the address, 0 if not connected
    unsigned long remote_address(void) const;

    // the remote port number of the connection
    // returns the port number, 0 if not connected to a port
    unsigned short remote_port(void) const;

    ////////////////////////////////////////////////////////////////////////////
    // error handling
    // errors are set internally
    // an error code of 0 is the test for no error, don't rely on the message being an empty string
    // an error code != 0 means an error, then there will be a message explaining the error

    // indicate an error - mostly used internally, you can set your own errors - use a negative code
    void set_error (int error, const std::string& message) const;

    // if an error is set it stays set - so you must clear it before further operations
    void clear_error (void) const;

    // get the error code of the last error
    int error(void) const;

    // get the explanatory message of the last error
    std::string message(void) const;

    ////////////////////////////////////////////////////////////////////////////

  private:
    friend class IP_socket_internals;
    IP_socket_internals* m_impl;
  };


} // end namespace stlplus

#endif
