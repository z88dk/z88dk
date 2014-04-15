#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/opcodes.t,v 1.2 2014-04-15 20:45:05 pauloscustodio Exp $

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

assemble(<<'END');
start:
	ex	af,af		; 08
	ex	af,af'		; 08
	im	0			; ED 46
	im	1			; ED 56 
	im	2			; ED 5E
END

write_file(asm_file(), <<'ASM');
	im -1
	im 3
	im undefined
ASM
t_z80asm_capture(asm_file(), "", <<'ERR', 1 );
Error at file 'test.asm' line 1: integer '-1' out of range
Error at file 'test.asm' line 2: integer '3' out of range
Error at file 'test.asm' line 3: symbol not defined
3 errors occurred during assembly
ERR

write_file(asm_file(), <<'ASM');
	im 0
ASM
t_z80asm_capture("--RCMX000 ".asm_file(), "", <<'ERR', 1 );
Error at file 'test.asm' line 1: illegal identifier
1 errors occurred during assembly
ERR



unlink_testfiles();
done_testing();

# assemble the given code, compare
sub assemble {
	my($code) = @_;
	
	my $addr = 0;
	my %label;
	my $asm = "";
	my $bin = "";
	
	for (split(/\n/, $code)) {
		if (/^(\w+):/) {
			$label{$1} = $addr;
		}
		
		$asm .= "$_\n";

		if (/^\s/) {
			my $bytes = $_; $bytes =~ s/^[^;]+;\s*//;
			for (split(' ', $bytes)) {
				$bin .= chr(hex($_));
				$addr++;
			}
		}
	}
	
	# test asm in upper case
	t_z80asm(
		asm		=> uc($asm),
		bin		=> $bin,
	);

	# test asm 
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
	);
}


# $Log: opcodes.t,v $
# Revision 1.2  2014-04-15 20:45:05  pauloscustodio
# Added error message for invalid interrupt mode in IM, e.g. for "IM 3":
# Error at file 'test.asm' line 2: integer '3' out of range
#
# Revision 1.1  2014/03/29 01:19:41  pauloscustodio
# Accept both "ex af,af" and "ex af,af'"
#

__END__
List of all opcodes not yet in test list:

44    0000              DEFC IND =	5
45    0000              DEFC M   =	10H
46    0000              DEFC N   =	20H
47    0000              DEFC DIS =	30H
48    0000              
49    0000              Z80OPS:
50    0000  8E          	ADC	A,(HL)
51    0001  DD 8E 05    	ADC	A,(IX+IND)
52    0004  FD 8E 05    	ADC	A,(IY+IND)
53    0007  8F          	ADC	A,A
54    0008  88          	ADC	A,B
55    0009  89          	ADC	A,C
56    000A  8A          	ADC	A,D
57    000B  8B          	ADC	A,E
58    000C  8C          	ADC	A,H
59    000D  8D          	ADC	A,L
60    000E  CE 20       	ADC	A,N
61    0010  ED 4A       	ADC	HL,BC
62    0012  ED 5A       	ADC	HL,DE
63    0014  ED 6A       	ADC	HL,HL
64    0016  ED 7A       	ADC	HL,SP
65    0018  86          	ADD	A,(HL)
66    0019  DD 86 05    	ADD	A,(IX+IND)
67    001C  FD 86 05    	ADD	A,(IY+IND)
68    001F  87          	ADD	A,A
69    0020  80          	ADD	A,B
70    0021  81          	ADD	A,C
71    0022  82          	ADD	A,D
72    0023  83          	ADD	A,E
73    0024  84          	ADD	A,H
74    0025  85          	ADD	A,L
75    0026  C6 20       	ADD	A,N
76    0028  09          	ADD	HL,BC
77    0029  19          	ADD	HL,DE
78    002A  29          	ADD	HL,HL
79    002B  39          	ADD	HL,SP
80    002C  DD 09       	ADD	IX,BC
81    002E  DD 19       	ADD	IX,DE
82    0030  DD 29       	ADD	IX,IX
83    0032  DD 39       	ADD	IX,SP
84    0034  FD 09       	ADD	IY,BC
85    0036  FD 19       	ADD	IY,DE
86    0038  FD 29       	ADD	IY,IY
87    003A  FD 39       	ADD	IY,SP
88    003C  A6          	AND	(HL)
89    003D  DD A6 05    	AND	(IX+IND)
90    0040  FD A6 05    	AND	(IY+IND)
91    0043  A7          	AND	A
92    0044  A0          	AND	B
93    0045  A1          	AND	C
94    0046  A2          	AND	D
95    0047  A3          	AND	E
96    0048  A4          	AND	H
97    0049  A5          	AND	L
98    004A  E6 20       	AND	N
99    004C  CB 46       	BIT	0,(HL)
100   004E  DD CB 05 46 	BIT	0,(IX+IND)
101   0052  FD CB 05 46 	BIT	0,(IY+IND)
102   0056  CB 47       	BIT	0,A
103   0058  CB 40       	BIT	0,B
104   005A  CB 41       	BIT	0,C
105   005C  CB 42       	BIT	0,D
106   005E  CB 43       	BIT	0,E
107   0060  CB 44       	BIT	0,H
108   0062  CB 45       	BIT	0,L
109   0064  CB 4E       	BIT	1,(HL)
110   0066  DD CB 05 4E 	BIT	1,(IX+IND)
111   006A  FD CB 05 4E 	BIT	1,(IY+IND)
112   006E  CB 4F       	BIT	1,A
113   0070  CB 48       	BIT	1,B
114   0072  CB 49       	BIT	1,C
115   0074  CB 4A       	BIT	1,D
116   0076  CB 4B       	BIT	1,E
117   0078  CB 4C       	BIT	1,H
118   007A  CB 4D       	BIT	1,L
119   007C  CB 56       	BIT	2,(HL)
120   007E  DD CB 05 56 	BIT	2,(IX+IND)
121   0082  FD CB 05 56 	BIT	2,(IY+IND)
122   0086  CB 57       	BIT	2,A
123   0088  CB 50       	BIT	2,B
124   008A  CB 51       	BIT	2,C
125   008C  CB 52       	BIT	2,D
126   008E  CB 53       	BIT	2,E
127   0090  CB 54       	BIT	2,H
128   0092  CB 55       	BIT	2,L
129   0094  CB 5E       	BIT	3,(HL)
130   0096  DD CB 05 5E 	BIT	3,(IX+IND)
131   009A  FD CB 05 5E 	BIT	3,(IY+IND)
132   009E  CB 5F       	BIT	3,A
133   00A0  CB 58       	BIT	3,B
134   00A2  CB 59       	BIT	3,C
135   00A4  CB 5A       	BIT	3,D
136   00A6  CB 5B       	BIT	3,E
137   00A8  CB 5C       	BIT	3,H
138   00AA  CB 5D       	BIT	3,L
139   00AC  CB 66       	BIT	4,(HL)
140   00AE  DD CB 05 66 	BIT	4,(IX+IND)
141   00B2  FD CB 05 66 	BIT	4,(IY+IND)
142   00B6  CB 67       	BIT	4,A
143   00B8  CB 60       	BIT	4,B
144   00BA  CB 61       	BIT	4,C
145   00BC  CB 62       	BIT	4,D
146   00BE  CB 63       	BIT	4,E
147   00C0  CB 64       	BIT	4,H
148   00C2  CB 65       	BIT	4,L
149   00C4  CB 6E       	BIT	5,(HL)
150   00C6  DD CB 05 6E 	BIT	5,(IX+IND)
151   00CA  FD CB 05 6E 	BIT	5,(IY+IND)
152   00CE  CB 6F       	BIT	5,A
153   00D0  CB 68       	BIT	5,B
154   00D2  CB 69       	BIT	5,C
155   00D4  CB 6A       	BIT	5,D
156   00D6  CB 6B       	BIT	5,E
157   00D8  CB 6C       	BIT	5,H
158   00DA  CB 6D       	BIT	5,L
159   00DC  CB 76       	BIT	6,(HL)
160   00DE  DD CB 05 76 	BIT	6,(IX+IND)
161   00E2  FD CB 05 76 	BIT	6,(IY+IND)
162   00E6  CB 77       	BIT	6,A
163   00E8  CB 70       	BIT	6,B
164   00EA  CB 71       	BIT	6,C
165   00EC  CB 72       	BIT	6,D
166   00EE  CB 73       	BIT	6,E
167   00F0  CB 74       	BIT	6,H
168   00F2  CB 75       	BIT	6,L
169   00F4  CB 7E       	BIT	7,(HL)
170   00F6  DD CB 05 7E 	BIT	7,(IX+IND)
171   00FA  FD CB 05 7E 	BIT	7,(IY+IND)
172   00FE  CB 7F       	BIT	7,A
173   0100  CB 78       	BIT	7,B
174   0102  CB 79       	BIT	7,C
175   0104  CB 7A       	BIT	7,D
176   0106  CB 7B       	BIT	7,E
177   0108  CB 7C       	BIT	7,H
178   010A  CB 7D       	BIT	7,L
179   010C  DC 84 05    	CALL	C,NN
180   010F  FC 84 05    	CALL	M,NN
181   0112  D4 84 05    	CALL	NC,NN
182   0115  CD 84 05    	CALL	NN
183   0118  C4 84 05    	CALL	NZ,NN
184   011B  F4 84 05    	CALL	P,NN
185   011E  EC 84 05    	CALL	PE,NN
186   0121  E4 84 05    	CALL	PO,NN
187   0124  CC 84 05    	CALL	Z,NN
188   0127  3F          	CCF
189   0128  BE          	CP	(HL)
190   0129  DD BE 05    	CP	(IX+IND)
191   012C  FD BE 05    	CP	(IY+IND)
192   012F  BF          	CP	A
193   0130  B8          	CP	B
194   0131  B9          	CP	C
195   0132  BA          	CP	D
196   0133  BB          	CP	E
197   0134  BC          	CP	H
198   0135  BD          	CP	L
199   0136  FE 20       	CP	N
200   0138  ED A9       	CPD
201   013A  ED B9       	CPDR
202   013C  ED A1       	CPI
203   013E  ED B1       	CPIR
204   0140  2F          	CPL
205   0141  27          	DAA
206   0142  35          	DEC	(HL)
207   0143  DD 35 05    	DEC	(IX+IND)
208   0146  FD 35 05    	DEC	(IY+IND)
209   0149  3D          	DEC	A
210   014A  05          	DEC	B
211   014B  0B          	DEC	BC
212   014C  0D          	DEC	C
213   014D  15          	DEC	D
214   014E  1B          	DEC	DE
215   014F  1D          	DEC	E
216   0150  25          	DEC	H
217   0151  2B          	DEC	HL
218   0152  DD 2B       	DEC	IX
219   0154  FD 2B       	DEC	IY
220   0156  2D          	DEC	L
221   0157  3B          	DEC	SP
222   0158  F3          	DI
223   0159  10 2E       	DJNZ	ASMPC+DIS
224   015B  FB          	EI
225   015C  E3          	EX	(SP),HL
226   015D  DD E3       	EX	(SP),IX
227   015F  FD E3       	EX	(SP),IY
228   0161  08          	EX	AF,AF'
229   0162  EB          	EX	DE,HL
230   0163  D9          	EXX
231   0164  76          	HALT
235   016B  ED 78       	IN	A,(C)
236   016D  DB 20       	IN	A,(N)
237   016F  ED 40       	IN	B,(C)
238   0171  ED 48       	IN	C,(C)
239   0173  ED 50       	IN	D,(C)
240   0175  ED 58       	IN	E,(C)
241   0177  ED 60       	IN	H,(C)
242   0179  ED 68       	IN	L,(C)
243   017B  34          	INC	(HL)
244   017C  DD 34 05    	INC	(IX+IND)
245   017F  FD 34 05    	INC	(IY+IND)
246   0182  3C          	INC	A
247   0183  04          	INC	B
248   0184  03          	INC	BC
249   0185  0C          	INC	C
250   0186  14          	INC	D
251   0187  13          	INC	DE
252   0188  1C          	INC	E
253   0189  24          	INC	H
254   018A  23          	INC	HL
255   018B  DD 23       	INC	IX
256   018D  FD 23       	INC	IY
257   018F  2C          	INC	L
258   0190  33          	INC	SP
259   0191  ED AA       	IND
260   0193  ED BA       	INDR
261   0195  ED A2       	INI
262   0197  ED B2       	INIR
263   0199  E9          	JP	(HL)
264   019A  DD E9       	JP	(IX)
265   019C  FD E9       	JP	(IY)
266   019E  DA 84 05    	JP	C,NN
267   01A1  FA 84 05    	JP	M,NN
268   01A4  D2 84 05    	JP	NC,NN
269   01A7  C3 84 05    	JP	NN
270   01AA  C2 84 05    	JP	NZ,NN
271   01AD  F2 84 05    	JP	P,NN
272   01B0  EA 84 05    	JP	PE,NN
273   01B3  E2 84 05    	JP	PO,NN
274   01B6  CA 84 05    	JP	Z,NN
275   01B9  38 2E       	JR	C,ASMPC+DIS
276   01BB  18 2E       	JR	ASMPC+DIS
277   01BD  30 2E       	JR	NC,ASMPC+DIS
278   01BF  20 2E       	JR	NZ,ASMPC+DIS
279   01C1  28 2E       	JR	Z,ASMPC+DIS
280   01C3  02          	LD	(BC),A
281   01C4  12          	LD	(DE),A
282   01C5  77          	LD	(HL),A
283   01C6  70          	LD	(HL),B
284   01C7  71          	LD	(HL),C
285   01C8  72          	LD	(HL),D
286   01C9  73          	LD	(HL),E
287   01CA  74          	LD	(HL),H
288   01CB  75          	LD	(HL),L
289   01CC  36 20       	LD	(HL),N
290   01CE  DD 36 05    	LD	(IX+IND),A
291   01D1  DD 36 05    	LD	(IX+IND),B
292   01D4  DD 36 05    	LD	(IX+IND),C
293   01D7  DD 36 05    	LD	(IX+IND),D
294   01DA  DD 36 05    	LD	(IX+IND),E
295   01DD  DD 36 05    	LD	(IX+IND),H
296   01E0  DD 36 05    	LD	(IX+IND),L
297   01E3  DD 36 05 20 	LD	(IX+IND),N
298   01E7  FD 36 05    	LD	(IY+IND),A
299   01EA  FD 36 05    	LD	(IY+IND),B
300   01ED  FD 36 05    	LD	(IY+IND),C
301   01F0  FD 36 05    	LD	(IY+IND),D
302   01F3  FD 36 05    	LD	(IY+IND),E
303   01F6  FD 36 05    	LD	(IY+IND),H
304   01F9  FD 36 05    	LD	(IY+IND),L
305   01FC  FD 36 05 20 	LD	(IY+IND),N
306   0200  32 84 05    	LD	(NN),A
307   0203  ED 43 84 05 	LD	(NN),BC
308   0207  ED 53 84 05 	LD	(NN),DE
309   020B  22 84 05    	LD	(NN),HL
310   020E  DD 22 84 05 	LD	(NN),IX
311   0212  FD 22 84 05 	LD	(NN),IY
312   0216  ED 73 84 05 	LD	(NN),SP
313   021A  0A          	LD	A,(BC)
314   021B  1A          	LD	A,(DE)
315   021C  7E          	LD	A,(HL)
316   021D  DD 7E 05    	LD	A,(IX+IND)
317   0220  FD 7E 05    	LD	A,(IY+IND)
318   0223  3A 84 05    	LD	A,(NN)
319   0226  7F          	LD	A,A
320   0227  78          	LD	A,B
321   0228  79          	LD	A,C
322   0229  7A          	LD	A,D
323   022A  7B          	LD	A,E
324   022B  7C          	LD	A,H
325   022C  ED 57       	LD	A,I
326   022E  7D          	LD	A,L
327   022F  3E 20       	LD	A,N
328   0231  46          	LD	B,(HL)
329   0232  DD 46 05    	LD	B,(IX+IND)
330   0235  FD 46 05    	LD	B,(IY+IND)
331   0238  47          	LD	B,A
332   0239  40          	LD	B,B
333   023A  41          	LD	B,C
334   023B  42          	LD	B,D
335   023C  43          	LD	B,E
336   023D  44          	LD	B,H
337   023E  45          	LD	B,L
338   023F  06 20       	LD	B,N
339   0241  ED 4B 84 05 	LD	BC,(NN)
340   0245  01 84 05    	LD	BC,NN
341   0248  4E          	LD	C,(HL)
342   0249  DD 4E 05    	LD	C,(IX+IND)
343   024C  FD 4E 05    	LD	C,(IY+IND)
344   024F  4F          	LD	C,A
345   0250  48          	LD	C,B
346   0251  49          	LD	C,C
347   0252  4A          	LD	C,D
348   0253  4B          	LD	C,E
349   0254  4C          	LD	C,H
350   0255  4D          	LD	C,L
351   0256  0E 20       	LD	C,N
352   0258  56          	LD	D,(HL)
353   0259  DD 56 05    	LD	D,(IX+IND)
354   025C  FD 56 05    	LD	D,(IY+IND)
355   025F  57          	LD	D,A
356   0260  50          	LD	D,B
357   0261  51          	LD	D,C
358   0262  52          	LD	D,D
359   0263  53          	LD	D,E
360   0264  54          	LD	D,H
361   0265  55          	LD	D,L
362   0266  16 20       	LD	D,N
363   0268  ED 5B 84 05 	LD	DE,(NN)
364   026C  11 84 05    	LD	DE,NN
365   026F  5E          	LD	E,(HL)
366   0270  DD 5E 05    	LD	E,(IX+IND)
367   0273  FD 5E 05    	LD	E,(IY+IND)
368   0276  5F          	LD	E,A
369   0277  58          	LD	E,B
370   0278  59          	LD	E,C
371   0279  5A          	LD	E,D
372   027A  5B          	LD	E,E
373   027B  5C          	LD	E,H
374   027C  5D          	LD	E,L
375   027D  1E 20       	LD	E,N
376   027F  66          	LD	H,(HL)
377   0280  DD 66 05    	LD	H,(IX+IND)
378   0283  FD 66 05    	LD	H,(IY+IND)
379   0286  67          	LD	H,A
380   0287  60          	LD	H,B
381   0288  61          	LD	H,C
382   0289  62          	LD	H,D
383   028A  63          	LD	H,E
384   028B  64          	LD	H,H
385   028C  65          	LD	H,L
386   028D  26 20       	LD	H,N
387   028F  2A 84 05    	LD	HL,(NN)
388   0292  21 84 05    	LD	HL,NN
389   0295  ED 47       	LD	I,A
390   0297  DD 2A 84 05 	LD	IX,(NN)
391   029B  DD 21 84 05 	LD	IX,NN
392   029F  FD 2A 84 05 	LD	IY,(NN)
393   02A3  FD 21 84 05 	LD	IY,NN
394   02A7  6E          	LD	L,(HL)
395   02A8  DD 6E 05    	LD	L,(IX+IND)
396   02AB  FD 6E 05    	LD	L,(IY+IND)
397   02AE  6F          	LD	L,A
398   02AF  68          	LD	L,B
399   02B0  69          	LD	L,C
400   02B1  6A          	LD	L,D
401   02B2  6B          	LD	L,E
402   02B3  6C          	LD	L,H
403   02B4  6D          	LD	L,L
404   02B5  2E 20       	LD	L,N
405   02B7  ED 7B 84 05 	LD	SP,(NN)
406   02BB  F9          	LD	SP,HL
407   02BC  DD F9       	LD	SP,IX
408   02BE  FD F9       	LD	SP,IY
409   02C0  31 84 05    	LD	SP,NN
410   02C3  ED A8       	LDD
411   02C5  ED B8       	LDDR
412   02C7  ED A0       	LDI
413   02C9  ED B0       	LDIR
414   02CB  ED 44       	NEG
415   02CD  00          	NOP
416   02CE  B6          	OR	(HL)
417   02CF  DD B6 05    	OR	(IX+IND)
418   02D2  FD B6 05    	OR	(IY+IND)
419   02D5  B7          	OR	A
420   02D6  B0          	OR	B
421   02D7  B1          	OR	C
422   02D8  B2          	OR	D
423   02D9  B3          	OR	E
424   02DA  B4          	OR	H
425   02DB  B5          	OR	L
426   02DC  F6 20       	OR	N
427   02DE  ED BB       	OTDR
428   02E0  ED B3       	OTIR
429   02E2  ED 79       	OUT	(C),A
430   02E4  ED 41       	OUT	(C),B
431   02E6  ED 49       	OUT	(C),C
432   02E8  ED 51       	OUT	(C),D
433   02EA  ED 59       	OUT	(C),E
434   02EC  ED 61       	OUT	(C),H
435   02EE  ED 69       	OUT	(C),L
436   02F0  D3 20       	OUT	(N),A
437   02F2  ED AB       	OUTD
438   02F4  ED A3       	OUTI
439   02F6  F1          	POP	AF
440   02F7  C1          	POP	BC
441   02F8  D1          	POP	DE
442   02F9  E1          	POP	HL
443   02FA  DD E1       	POP	IX
444   02FC  FD E1       	POP	IY
445   02FE  F5          	PUSH	AF
446   02FF  C5          	PUSH	BC
447   0300  D5          	PUSH	DE
448   0301  E5          	PUSH	HL
449   0302  DD E5       	PUSH	IX
450   0304  FD E5       	PUSH	IY
451   0306  CB 86       	RES	0,(HL)
452   0308  DD CB 05 86 	RES	0,(IX+IND)
453   030C  FD CB 05 86 	RES	0,(IY+IND)
454   0310  CB 87       	RES	0,A
455   0312  CB 80       	RES	0,B
456   0314  CB 81       	RES	0,C
457   0316  CB 82       	RES	0,D
458   0318  CB 83       	RES	0,E
459   031A  CB 84       	RES	0,H
460   031C  CB 85       	RES	0,L
461   031E  CB 8E       	RES	1,(HL)
462   0320  DD CB 05 8E 	RES	1,(IX+IND)
463   0324  FD CB 05 8E 	RES	1,(IY+IND)
464   0328  CB 8F       	RES	1,A
465   032A  CB 88       	RES	1,B
466   032C  CB 89       	RES	1,C
467   032E  CB 8A       	RES	1,D
468   0330  CB 8B       	RES	1,E
469   0332  CB 8C       	RES	1,H
470   0334  CB 8D       	RES	1,L
471   0336  CB 96       	RES	2,(HL)
472   0338  DD CB 05 96 	RES	2,(IX+IND)
473   033C  FD CB 05 96 	RES	2,(IY+IND)
474   0340  CB 97       	RES	2,A
475   0342  CB 90       	RES	2,B
476   0344  CB 91       	RES	2,C
477   0346  CB 92       	RES	2,D
478   0348  CB 93       	RES	2,E
479   034A  CB 94       	RES	2,H
480   034C  CB 95       	RES	2,L
481   034E  CB 9E       	RES	3,(HL)
482   0350  DD CB 05 9E 	RES	3,(IX+IND)
483   0354  FD CB 05 9E 	RES	3,(IY+IND)
484   0358  CB 9F       	RES	3,A
485   035A  CB 98       	RES	3,B
486   035C  CB 99       	RES	3,C
487   035E  CB 9A       	RES	3,D
488   0360  CB 9B       	RES	3,E
489   0362  CB 9C       	RES	3,H
490   0364  CB 9D       	RES	3,L
491   0366  CB A6       	RES	4,(HL)
492   0368  DD CB 05 A6 	RES	4,(IX+IND)
493   036C  FD CB 05 A6 	RES	4,(IY+IND)
494   0370  CB A7       	RES	4,A
495   0372  CB A0       	RES	4,B
496   0374  CB A1       	RES	4,C
497   0376  CB A2       	RES	4,D
498   0378  CB A3       	RES	4,E
499   037A  CB A4       	RES	4,H
500   037C  CB A5       	RES	4,L
501   037E  CB AE       	RES	5,(HL)
502   0380  DD CB 05 AE 	RES	5,(IX+IND)
503   0384  FD CB 05 AE 	RES	5,(IY+IND)
504   0388  CB AF       	RES	5,A
505   038A  CB A8       	RES	5,B
506   038C  CB A9       	RES	5,C
507   038E  CB AA       	RES	5,D
508   0390  CB AB       	RES	5,E
509   0392  CB AC       	RES	5,H
510   0394  CB AD       	RES	5,L
511   0396  CB B6       	RES	6,(HL)
512   0398  DD CB 05 B6 	RES	6,(IX+IND)
513   039C  FD CB 05 B6 	RES	6,(IY+IND)
514   03A0  CB B7       	RES	6,A
515   03A2  CB B0       	RES	6,B
516   03A4  CB B1       	RES	6,C
517   03A6  CB B2       	RES	6,D
518   03A8  CB B3       	RES	6,E
519   03AA  CB B4       	RES	6,H
520   03AC  CB B5       	RES	6,L
521   03AE  CB BE       	RES	7,(HL)
522   03B0  DD CB 05 BE 	RES	7,(IX+IND)
523   03B4  FD CB 05 BE 	RES	7,(IY+IND)
524   03B8  CB BF       	RES	7,A
525   03BA  CB B8       	RES	7,B
526   03BC  CB B9       	RES	7,C
527   03BE  CB BA       	RES	7,D
528   03C0  CB BB       	RES	7,E
529   03C2  CB BC       	RES	7,H
530   03C4  CB BD       	RES	7,L
531   03C6  C9          	RET
532   03C7  D8          	RET	C
533   03C8  F8          	RET	M
534   03C9  D0          	RET	NC
535   03CA  C0          	RET	NZ
536   03CB  F0          	RET	P
537   03CC  E8          	RET	PE
538   03CD  E0          	RET	PO
539   03CE  C8          	RET	Z
540   03CF  ED 4D       	RETI
541   03D1  ED 45       	RETN
542   03D3  CB 16       	RL	(HL)
543   03D5  DD CB 05 16 	RL	(IX+IND)
544   03D9  FD CB 05 16 	RL	(IY+IND)
545   03DD  CB 17       	RL	A
546   03DF  CB 10       	RL	B
547   03E1  CB 11       	RL	C
548   03E3  CB 12       	RL	D
549   03E5  CB 13       	RL	E
550   03E7  CB 14       	RL	H
551   03E9  CB 15       	RL	L
552   03EB  17          	RLA
553   03EC  CB 06       	RLC	(HL)
554   03EE  DD CB 05 06 	RLC	(IX+IND)
555   03F2  FD CB 05 06 	RLC	(IY+IND)
556   03F6  CB 07       	RLC	A
557   03F8  CB 00       	RLC	B
558   03FA  CB 01       	RLC	C
559   03FC  CB 02       	RLC	D
560   03FE  CB 03       	RLC	E
561   0400  CB 04       	RLC	H
562   0402  CB 05       	RLC	L
563   0404  07          	RLCA
564   0405  ED 6F       	RLD
565   0407  CB 1E       	RR	(HL)
566   0409  DD CB 05 1E 	RR	(IX+IND)
567   040D  FD CB 05 1E 	RR	(IY+IND)
568   0411  CB 1F       	RR	A
569   0413  CB 18       	RR	B
570   0415  CB 19       	RR	C
571   0417  CB 1A       	RR	D
572   0419  CB 1B       	RR	E
573   041B  CB 1C       	RR	H
574   041D  CB 1D       	RR	L
575   041F  1F          	RRA
576   0420  CB 0E       	RRC	(HL)
577   0422  DD CB 05 0E 	RRC	(IX+IND)
578   0426  FD CB 05 0E 	RRC	(IY+IND)
579   042A  CB 0F       	RRC	A
580   042C  CB 08       	RRC	B
581   042E  CB 09       	RRC	C
582   0430  CB 0A       	RRC	D
583   0432  CB 0B       	RRC	E
584   0434  CB 0C       	RRC	H
585   0436  CB 0D       	RRC	L
586   0438  0F          	RRCA
587   0439  ED 67       	RRD
588   043B  C7          	RST	0
589   043C  D7          	RST	10H
590   043D  DF          	RST	18H
591   043E  E7          	RST	20H
592   043F  EF          	RST	28H
593   0440  F7          	RST	30H
594   0441  FF          	RST	38H
595   0442  CF          	RST	8
596   0443  9E          	SBC	A,(HL)
597   0444  DD 9E 05    	SBC	A,(IX+IND)
598   0447  FD 9E 05    	SBC	A,(IY+IND)
599   044A  9F          	SBC	A,A
600   044B  98          	SBC	A,B
601   044C  99          	SBC	A,C
602   044D  9A          	SBC	A,D
603   044E  9B          	SBC	A,E
604   044F  9C          	SBC	A,H
605   0450  9D          	SBC	A,L
606   0451  DE 20       	SBC	A,N
607   0453  ED 42       	SBC	HL,BC
608   0455  ED 52       	SBC	HL,DE
609   0457  ED 62       	SBC	HL,HL
610   0459  ED 72       	SBC	HL,SP
611   045B  37          	SCF
612   045C  CB C6       	SET	0,(HL)
613   045E  DD CB 05 C6 	SET	0,(IX+IND)
614   0462  FD CB 05 C6 	SET	0,(IY+IND)
615   0466  CB C7       	SET	0,A
616   0468  CB C0       	SET	0,B
617   046A  CB C1       	SET	0,C
618   046C  CB C2       	SET	0,D
619   046E  CB C3       	SET	0,E
620   0470  CB C4       	SET	0,H
621   0472  CB C5       	SET	0,L
622   0474  CB CE       	SET	1,(HL)
623   0476  DD CB 05 CE 	SET	1,(IX+IND)
624   047A  FD CB 05 CE 	SET	1,(IY+IND)
625   047E  CB CF       	SET	1,A
626   0480  CB C8       	SET	1,B
627   0482  CB C9       	SET	1,C
628   0484  CB CA       	SET	1,D
629   0486  CB CB       	SET	1,E
630   0488  CB CC       	SET	1,H
631   048A  CB CD       	SET	1,L
632   048C  CB D6       	SET	2,(HL)
633   048E  DD CB 05 D6 	SET	2,(IX+IND)
634   0492  FD CB 05 D6 	SET	2,(IY+IND)
635   0496  CB D7       	SET	2,A
636   0498  CB D0       	SET	2,B
637   049A  CB D1       	SET	2,C
638   049C  CB D2       	SET	2,D
639   049E  CB D3       	SET	2,E
640   04A0  CB D4       	SET	2,H
641   04A2  CB D5       	SET	2,L
642   04A4  CB DE       	SET	3,(HL)
643   04A6  DD CB 05 DE 	SET	3,(IX+IND)
644   04AA  FD CB 05 DE 	SET	3,(IY+IND)
645   04AE  CB DF       	SET	3,A
646   04B0  CB D8       	SET	3,B
647   04B2  CB D9       	SET	3,C
648   04B4  CB DA       	SET	3,D
649   04B6  CB DB       	SET	3,E
650   04B8  CB DC       	SET	3,H
651   04BA  CB DD       	SET	3,L
652   04BC  CB E6       	SET	4,(HL)
653   04BE  DD CB 05 E6 	SET	4,(IX+IND)
654   04C2  FD CB 05 E6 	SET	4,(IY+IND)
655   04C6  CB E7       	SET	4,A
656   04C8  CB E0       	SET	4,B
657   04CA  CB E1       	SET	4,C
658   04CC  CB E2       	SET	4,D
659   04CE  CB E3       	SET	4,E
660   04D0  CB E4       	SET	4,H
661   04D2  CB E5       	SET	4,L
662   04D4  CB EE       	SET	5,(HL)
663   04D6  DD CB 05 EE 	SET	5,(IX+IND)
664   04DA  FD CB 05 EE 	SET	5,(IY+IND)
665   04DE  CB EF       	SET	5,A
666   04E0  CB E8       	SET	5,B
667   04E2  CB E9       	SET	5,C
668   04E4  CB EA       	SET	5,D
669   04E6  CB EB       	SET	5,E
670   04E8  CB EC       	SET	5,H
671   04EA  CB ED       	SET	5,L
672   04EC  CB F6       	SET	6,(HL)
673   04EE  DD CB 05 F6 	SET	6,(IX+IND)
674   04F2  FD CB 05 F6 	SET	6,(IY+IND)
675   04F6  CB F7       	SET	6,A
676   04F8  CB F0       	SET	6,B
677   04FA  CB F1       	SET	6,C
678   04FC  CB F2       	SET	6,D
679   04FE  CB F3       	SET	6,E
680   0500  CB F4       	SET	6,H
681   0502  CB F5       	SET	6,L
682   0504  CB FE       	SET	7,(HL)
683   0506  DD CB 05 FE 	SET	7,(IX+IND)
684   050A  FD CB 05 FE 	SET	7,(IY+IND)
685   050E  CB FF       	SET	7,A
686   0510  CB F8       	SET	7,B
687   0512  CB F9       	SET	7,C
688   0514  CB FA       	SET	7,D
689   0516  CB FB       	SET	7,E
690   0518  CB FC       	SET	7,H
691   051A  CB FD       	SET	7,L
692   051C  CB 26       	SLA	(HL)
693   051E  DD CB 05 26 	SLA	(IX+IND)
694   0522  FD CB 05 26 	SLA	(IY+IND)
695   0526  CB 27       	SLA	A
696   0528  CB 20       	SLA	B
697   052A  CB 21       	SLA	C
698   052C  CB 22       	SLA	D
699   052E  CB 23       	SLA	E
700   0530  CB 24       	SLA	H
701   0532  CB 25       	SLA	L
702   0534  CB 2E       	SRA	(HL)
703   0536  DD CB 05 2E 	SRA	(IX+IND)
704   053A  FD CB 05 2E 	SRA	(IY+IND)
705   053E  CB 2F       	SRA	A
706   0540  CB 28       	SRA	B
707   0542  CB 29       	SRA	C
708   0544  CB 2A       	SRA	D
709   0546  CB 2B       	SRA	E
710   0548  CB 2C       	SRA	H
711   054A  CB 2D       	SRA	L
712   054C  CB 3E       	SRL	(HL)
713   054E  DD CB 05 3E 	SRL	(IX+IND)
714   0552  FD CB 05 3E 	SRL	(IY+IND)
715   0556  CB 3F       	SRL	A
716   0558  CB 38       	SRL	B
717   055A  CB 39       	SRL	C
718   055C  CB 3A       	SRL	D
719   055E  CB 3B       	SRL	E
720   0560  CB 3C       	SRL	H
721   0562  CB 3D       	SRL	L
722   0564  96          	SUB	(HL)
723   0565  DD 96 05    	SUB	(IX+IND)
724   0568  FD 96 05    	SUB	(IY+IND)
725   056B  97          	SUB	A
726   056C  90          	SUB	B
727   056D  91          	SUB	C
728   056E  92          	SUB	D
729   056F  93          	SUB	E
730   0570  94          	SUB	H
731   0571  95          	SUB	L
732   0572  D6 20       	SUB	N
733   0574  AE          	XOR	(HL)
734   0575  DD AE 05    	XOR	(IX+IND)
735   0578  FD AE 05    	XOR	(IY+IND)
736   057B  AF          	XOR	A
737   057C  A8          	XOR	B
738   057D  A9          	XOR	C
739   057E  AA          	XOR	D
740   057F  AB          	XOR	E
741   0580  AC          	XOR	H
742   0581  AD          	XOR	L
743   0582  EE 20       	XOR	N
744   0584              
745   0584  00 00       NN:	DEFS	2
746   0586
