	defc x1 = out1
	defc x2 = out2
	defc y1 = in1
	defc y2 = in2
out1:
	defw x1, x2, y1, y2
	
	phase 0x1000
in1:
	defw x1, x2, y1, y2
in2:
	dephase
out2:
