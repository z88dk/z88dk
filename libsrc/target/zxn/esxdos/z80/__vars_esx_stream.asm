SECTION bss_esxdos

PUBLIC __esx_stream_card_flags

PUBLIC __esx_stream_protocol
PUBLIC __esx_stream_protocol_address
PUBLIC __esx_stream_protocol_sectors

PUBLIC _esx_stream_io_port
PUBLIC _esx_stream_protocol

PUBLIC _esx_stream_card_address
PUBLIC _esx_stream_sectors_remaining

__esx_stream_card_flags:  defb 0

__esx_stream_protocol:  defw 0
__esx_stream_protocol_address:  defw 0, 0   ; these two must be in order
__esx_stream_protocol_sectors:  defw 0      ; these two must be in order

defc _esx_stream_io_port = __esx_stream_protocol
defc _esx_stream_protocol = __esx_stream_protocol + 1

defc _esx_stream_card_address = __esx_stream_protocol_address
defc _esx_stream_sectors_remaining = __esx_stream_protocol_sectors
