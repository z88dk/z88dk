#!/usr/sbin/python
import time, datetime
import os

PAYLOAD_ORIGIN = 0xd000	# see z88dk.git/lib/config/vgl.cfg	"-Ca--origin=0xc800"

name = 'payload'
filename_bin = name + '.bin'
filename_inc = name + '.inc'

with open(filename_bin, 'rb') as h:
	data = h.read()

l = len(data)
r = ''
r += '; Converted from binary file\n'
r += '; Original file: %s\n' % (os.path.abspath(filename_bin))
r += '; Time of conversion: %s\n' % (datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S'))
r += '\n'

r += 'PUBLIC _%s_size\n' % (name)
r += '_%s_size:\n' % (name)
r += '	defw %d\n' % (l)
r += '\n'

r += 'PUBLIC _%s_org\n' % (name)
r += '_%s_org:\n' % (name)
r += '	defw 0x%04X\n' % (PAYLOAD_ORIGIN)
r += '\n'

r += 'PUBLIC _%s_data\n' % (name)
r += '_%s_data:' % (name)

col = 9999	# Force new line at beginning
o = 0
while o < l:
	c = data[o]
	
	if (col > 16):
		r += '\n'
		r += '	defb '
		col = 0
	else:
		r += ', '
	
	r += '0x%02X' % ord(c)
	
	col += 1
	
	o += 1
r += '\n'

r += '\n'
r += '; End of %s\n' % (filename_bin)

with open(filename_inc, 'w') as h:
	h.write(r)