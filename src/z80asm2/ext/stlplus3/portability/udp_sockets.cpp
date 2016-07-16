////////////////////////////////////////////////////////////////////////////////

//   Author:    Daniel Milton adapted by Andy Rushton
//   Copyright: (c) Daniel Milton, Andy Rushton onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

#include "udp_sockets.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // UDP client
  ////////////////////////////////////////////////////////////////////////////////

  // create an uninitialised socket
  UDP_client::UDP_client(void) : IP_socket(UDP)
  {
  }

  // Send/Receive datagram packets to/from the given address/remote port on the local port.
  // Enables default send to remote address/port
  // - remote_address: IP name or number of remote host
  // - remote_port: port number of remote host
  // - local_port: port number to receive on - 0 to get an ephemeral port.
  UDP_client::UDP_client(const std::string& remote_address, unsigned short remote_port, unsigned short local_port) :
    IP_socket(UDP)
  {
    initialise(remote_address, remote_port, local_port);
  }

  // Send/Receive datagram packets to/from the given address/remote port on the given local port
  // Enables default send to remote address/port
  // - remote_address: IP address of remote host - pre-looked-up using ip_lookup
  // - remote_port: port number of remote host
  // - local_port: port number to receive on - 0 to get an ephemeral port.
  UDP_client::UDP_client(unsigned long remote_address, unsigned short remote_port, unsigned short local_port) :
    IP_socket(UDP)
  {
    initialise(remote_address, remote_port, local_port);
  }

  // Send/Receive datagram packets to/from the given address/remote port on the local port.
  // Enables default send to remote address/port
  // - remote_address: IP name or number of remote host
  // - remote_port: port number of remote host
  // - local_port: port number to receive on - 0 to get an ephemeral port.
  // - returns a success flag
  bool UDP_client::initialise(const std::string& address, unsigned short remote_port, unsigned short local_port)
  {
    // lookup the address and convert it into an IP number
    unsigned long remote_address = IP_socket::ip_lookup(address);
    if (!remote_address) return false;
    return initialise(remote_address, remote_port, local_port);
  }

  // Send/Receive datagram packets to/from the given address/remote port on the given local port
  // Enables default send to remote address/port
  // - remote_address: IP address of remote host - pre-looked-up using ip_lookup
  // - remote_port: port number of remote host
  // - local_port: port number to receive on - 0 to get an ephemeral port.
  // - returns a success flag
  bool UDP_client::initialise(unsigned long remote_address, unsigned short remote_port, unsigned short local_port)
  {
    if (!IP_socket::bind(remote_address, local_port)) return false;
    return IP_socket::connect(remote_address, remote_port);
  }

  // send to the remote address/port setup in initialise, from the local port also setup in initialise.
  // send data through the socket as a single datagram
  // - packet: string containing data to be sent - if data is successfully sent it is removed
  // - returns success flag
  bool UDP_client::send(std::string& packet)
  {
    return IP_socket::send_packet(packet);
  }

  // datagram receive
  // - packet: string to receive data from datagram - if data is successfully sent it is appended
  // - returns success flag - i.e. packet successfully received
  bool UDP_client::receive(std::string& packet)
  {
    return IP_socket::receive_packet(packet);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // UDP Server
  ////////////////////////////////////////////////////////////////////////////////

  // create an uninitialised socket
  UDP_server::UDP_server(void) : IP_socket(UDP)
  {
  }

  // Initialise socket.
  // Receive datagram packets from any address on provided local receiving port.
  // No default send possible.
  // - local_port: port number to receive on - 0 to get an ephemeral port.
  UDP_server::UDP_server(unsigned short local_port) : IP_socket(UDP)
  {
    initialise(local_port);
  }

  // Initialise socket.
  // Receive datagram packets from any address on provided local receiving port.
  // No default send possible.
  // - local_port: port number to receive on - 0 to get an ephemeral port.
  // - returns a success flag
  bool UDP_server::initialise(unsigned short local_port)
  {
    return IP_socket::bind_any(local_port);
  }

  // send to the address/port given here, from the local port setup in initialise.
  // send data through the socket as a single datagram
  // - packet: string containing data to be sent - if data is successfully sent it is removed
  // - remote_address: IP name (stlplus.sourceforge.net) or dotted number (216.34.181.96)
  // - remote_port: port number of remote host
  // - returns success flag
  bool UDP_server::send(std::string& packet, const std::string& remote_address, unsigned short remote_port)
  {
    unsigned long ip_address = ip_lookup(remote_address);
    if (ip_address == 0) return false;
    return send(packet, ip_address, remote_port);
  }

  // send to the address/port given here, from the local port setup in initialise.
  // send data through the socket as a single datagram
  // - packet: string containing data to be sent - if data is successfully sent it is removed
  // - remote_address: pre-looked-up IP address of remote host
  // - remote_port: port number of remote host
  // - returns success flag
  bool UDP_server::send(std::string& packet, unsigned long remote_address, unsigned short remote_port)
  {
    return IP_socket::send_packet(packet, remote_address, remote_port);
  }

  // datagram receive
  // - packet: string to receive data from datagram - if data is successfully sent it is appended
  // - remote_address: the address of the client that sent the packet, can then be used to reply
  // - remote_port: the port of the client that sent the packet, can then be used to reply
  // - returns success flag - i.e. packet successfully received
  bool UDP_server::receive(std::string& packet, unsigned long& remote_address, unsigned short& remote_port)
  {
    return IP_socket::receive_packet(packet, remote_address, remote_port);
  }

  /////////////////////////////////////////////////////////////////////////////
  // fire and forget UDP client packet send function
  ////////////////////////////////////////////////////////////////////////////////

  bool UDP_send(const std::string& packet,
                const std::string& remote_address, unsigned short remote_port, unsigned short local_port)
  {
    UDP_client client(remote_address, remote_port, local_port);
    if (!client.initialised()) return false;
    std::string packet_copy = packet;
    return client.send(packet_copy);
  }

  /////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
