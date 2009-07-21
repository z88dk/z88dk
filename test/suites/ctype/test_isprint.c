
#include "ctype_test.h"
void t_isprint_0x00()
{
    Assert(isprint(0)  == 0 ,"isprint should be 0 for 0x00");
}

void t_isprint_0x01()
{
    Assert(isprint(1)  == 0 ,"isprint should be 0 for 0x01");
}

void t_isprint_0x02()
{
    Assert(isprint(2)  == 0 ,"isprint should be 0 for 0x02");
}

void t_isprint_0x03()
{
    Assert(isprint(3)  == 0 ,"isprint should be 0 for 0x03");
}

void t_isprint_0x04()
{
    Assert(isprint(4)  == 0 ,"isprint should be 0 for 0x04");
}

void t_isprint_0x05()
{
    Assert(isprint(5)  == 0 ,"isprint should be 0 for 0x05");
}

void t_isprint_0x06()
{
    Assert(isprint(6)  == 0 ,"isprint should be 0 for 0x06");
}

void t_isprint_0x07()
{
    Assert(isprint(7)  == 0 ,"isprint should be 0 for 0x07");
}

void t_isprint_0x08()
{
    Assert(isprint(8)  == 0 ,"isprint should be 0 for 0x08");
}

void t_isprint_0x09()
{
    Assert(isprint(9)  == 0 ,"isprint should be 0 for 0x09");
}

void t_isprint_0x0a()
{
    Assert(isprint(10)  == 0 ,"isprint should be 0 for 0x0a");
}

void t_isprint_0x0b()
{
    Assert(isprint(11)  == 0 ,"isprint should be 0 for 0x0b");
}

void t_isprint_0x0c()
{
    Assert(isprint(12)  == 0 ,"isprint should be 0 for 0x0c");
}

void t_isprint_0x0d()
{
    Assert(isprint(13)  == 0 ,"isprint should be 0 for 0x0d");
}

void t_isprint_0x0e()
{
    Assert(isprint(14)  == 0 ,"isprint should be 0 for 0x0e");
}

void t_isprint_0x0f()
{
    Assert(isprint(15)  == 0 ,"isprint should be 0 for 0x0f");
}

void t_isprint_0x10()
{
    Assert(isprint(16)  == 0 ,"isprint should be 0 for 0x10");
}

void t_isprint_0x11()
{
    Assert(isprint(17)  == 0 ,"isprint should be 0 for 0x11");
}

void t_isprint_0x12()
{
    Assert(isprint(18)  == 0 ,"isprint should be 0 for 0x12");
}

void t_isprint_0x13()
{
    Assert(isprint(19)  == 0 ,"isprint should be 0 for 0x13");
}

void t_isprint_0x14()
{
    Assert(isprint(20)  == 0 ,"isprint should be 0 for 0x14");
}

void t_isprint_0x15()
{
    Assert(isprint(21)  == 0 ,"isprint should be 0 for 0x15");
}

void t_isprint_0x16()
{
    Assert(isprint(22)  == 0 ,"isprint should be 0 for 0x16");
}

void t_isprint_0x17()
{
    Assert(isprint(23)  == 0 ,"isprint should be 0 for 0x17");
}

void t_isprint_0x18()
{
    Assert(isprint(24)  == 0 ,"isprint should be 0 for 0x18");
}

void t_isprint_0x19()
{
    Assert(isprint(25)  == 0 ,"isprint should be 0 for 0x19");
}

void t_isprint_0x1a()
{
    Assert(isprint(26)  == 0 ,"isprint should be 0 for 0x1a");
}

void t_isprint_0x1b()
{
    Assert(isprint(27)  == 0 ,"isprint should be 0 for 0x1b");
}

void t_isprint_0x1c()
{
    Assert(isprint(28)  == 0 ,"isprint should be 0 for 0x1c");
}

void t_isprint_0x1d()
{
    Assert(isprint(29)  == 0 ,"isprint should be 0 for 0x1d");
}

void t_isprint_0x1e()
{
    Assert(isprint(30)  == 0 ,"isprint should be 0 for 0x1e");
}

void t_isprint_0x1f()
{
    Assert(isprint(31)  == 0 ,"isprint should be 0 for 0x1f");
}

void t_isprint_0x20()
{
    Assert(isprint(32) ,"isprint should be 1 for  ");
}

void t_isprint_0x21()
{
    Assert(isprint(33) ,"isprint should be 1 for !");
}

void t_isprint_0x22()
{
    Assert(isprint(34) ,"isprint should be 1 for 0x22");
}

void t_isprint_0x23()
{
    Assert(isprint(35) ,"isprint should be 1 for #");
}

void t_isprint_0x24()
{
    Assert(isprint(36) ,"isprint should be 1 for $");
}

void t_isprint_0x25()
{
    Assert(isprint(37) ,"isprint should be 1 for %");
}

void t_isprint_0x26()
{
    Assert(isprint(38) ,"isprint should be 1 for &");
}

void t_isprint_0x27()
{
    Assert(isprint(39) ,"isprint should be 1 for '");
}

void t_isprint_0x28()
{
    Assert(isprint(40) ,"isprint should be 1 for (");
}

void t_isprint_0x29()
{
    Assert(isprint(41) ,"isprint should be 1 for )");
}

void t_isprint_0x2a()
{
    Assert(isprint(42) ,"isprint should be 1 for *");
}

void t_isprint_0x2b()
{
    Assert(isprint(43) ,"isprint should be 1 for +");
}

void t_isprint_0x2c()
{
    Assert(isprint(44) ,"isprint should be 1 for ,");
}

void t_isprint_0x2d()
{
    Assert(isprint(45) ,"isprint should be 1 for -");
}

void t_isprint_0x2e()
{
    Assert(isprint(46) ,"isprint should be 1 for .");
}

void t_isprint_0x2f()
{
    Assert(isprint(47) ,"isprint should be 1 for /");
}

void t_isprint_0x30()
{
    Assert(isprint(48) ,"isprint should be 1 for 0");
}

void t_isprint_0x31()
{
    Assert(isprint(49) ,"isprint should be 1 for 1");
}

void t_isprint_0x32()
{
    Assert(isprint(50) ,"isprint should be 1 for 2");
}

void t_isprint_0x33()
{
    Assert(isprint(51) ,"isprint should be 1 for 3");
}

void t_isprint_0x34()
{
    Assert(isprint(52) ,"isprint should be 1 for 4");
}

void t_isprint_0x35()
{
    Assert(isprint(53) ,"isprint should be 1 for 5");
}

void t_isprint_0x36()
{
    Assert(isprint(54) ,"isprint should be 1 for 6");
}

void t_isprint_0x37()
{
    Assert(isprint(55) ,"isprint should be 1 for 7");
}

void t_isprint_0x38()
{
    Assert(isprint(56) ,"isprint should be 1 for 8");
}

void t_isprint_0x39()
{
    Assert(isprint(57) ,"isprint should be 1 for 9");
}

void t_isprint_0x3a()
{
    Assert(isprint(58) ,"isprint should be 1 for :");
}

void t_isprint_0x3b()
{
    Assert(isprint(59) ,"isprint should be 1 for ;");
}

void t_isprint_0x3c()
{
    Assert(isprint(60) ,"isprint should be 1 for <");
}

void t_isprint_0x3d()
{
    Assert(isprint(61) ,"isprint should be 1 for =");
}

void t_isprint_0x3e()
{
    Assert(isprint(62) ,"isprint should be 1 for >");
}

void t_isprint_0x3f()
{
    Assert(isprint(63) ,"isprint should be 1 for ?");
}

void t_isprint_0x40()
{
    Assert(isprint(64) ,"isprint should be 1 for @");
}

void t_isprint_0x41()
{
    Assert(isprint(65) ,"isprint should be 1 for A");
}

void t_isprint_0x42()
{
    Assert(isprint(66) ,"isprint should be 1 for B");
}

void t_isprint_0x43()
{
    Assert(isprint(67) ,"isprint should be 1 for C");
}

void t_isprint_0x44()
{
    Assert(isprint(68) ,"isprint should be 1 for D");
}

void t_isprint_0x45()
{
    Assert(isprint(69) ,"isprint should be 1 for E");
}

void t_isprint_0x46()
{
    Assert(isprint(70) ,"isprint should be 1 for F");
}

void t_isprint_0x47()
{
    Assert(isprint(71) ,"isprint should be 1 for G");
}

void t_isprint_0x48()
{
    Assert(isprint(72) ,"isprint should be 1 for H");
}

void t_isprint_0x49()
{
    Assert(isprint(73) ,"isprint should be 1 for I");
}

void t_isprint_0x4a()
{
    Assert(isprint(74) ,"isprint should be 1 for J");
}

void t_isprint_0x4b()
{
    Assert(isprint(75) ,"isprint should be 1 for K");
}

void t_isprint_0x4c()
{
    Assert(isprint(76) ,"isprint should be 1 for L");
}

void t_isprint_0x4d()
{
    Assert(isprint(77) ,"isprint should be 1 for M");
}

void t_isprint_0x4e()
{
    Assert(isprint(78) ,"isprint should be 1 for N");
}

void t_isprint_0x4f()
{
    Assert(isprint(79) ,"isprint should be 1 for O");
}

void t_isprint_0x50()
{
    Assert(isprint(80) ,"isprint should be 1 for P");
}

void t_isprint_0x51()
{
    Assert(isprint(81) ,"isprint should be 1 for Q");
}

void t_isprint_0x52()
{
    Assert(isprint(82) ,"isprint should be 1 for R");
}

void t_isprint_0x53()
{
    Assert(isprint(83) ,"isprint should be 1 for S");
}

void t_isprint_0x54()
{
    Assert(isprint(84) ,"isprint should be 1 for T");
}

void t_isprint_0x55()
{
    Assert(isprint(85) ,"isprint should be 1 for U");
}

void t_isprint_0x56()
{
    Assert(isprint(86) ,"isprint should be 1 for V");
}

void t_isprint_0x57()
{
    Assert(isprint(87) ,"isprint should be 1 for W");
}

void t_isprint_0x58()
{
    Assert(isprint(88) ,"isprint should be 1 for X");
}

void t_isprint_0x59()
{
    Assert(isprint(89) ,"isprint should be 1 for Y");
}

void t_isprint_0x5a()
{
    Assert(isprint(90) ,"isprint should be 1 for Z");
}

void t_isprint_0x5b()
{
    Assert(isprint(91) ,"isprint should be 1 for [");
}

void t_isprint_0x5c()
{
    Assert(isprint(92) ,"isprint should be 1 for 0x5c");
}

void t_isprint_0x5d()
{
    Assert(isprint(93) ,"isprint should be 1 for ]");
}

void t_isprint_0x5e()
{
    Assert(isprint(94) ,"isprint should be 1 for ^");
}

void t_isprint_0x5f()
{
    Assert(isprint(95) ,"isprint should be 1 for _");
}

void t_isprint_0x60()
{
    Assert(isprint(96) ,"isprint should be 1 for `");
}

void t_isprint_0x61()
{
    Assert(isprint(97) ,"isprint should be 1 for a");
}

void t_isprint_0x62()
{
    Assert(isprint(98) ,"isprint should be 1 for b");
}

void t_isprint_0x63()
{
    Assert(isprint(99) ,"isprint should be 1 for c");
}

void t_isprint_0x64()
{
    Assert(isprint(100) ,"isprint should be 1 for d");
}

void t_isprint_0x65()
{
    Assert(isprint(101) ,"isprint should be 1 for e");
}

void t_isprint_0x66()
{
    Assert(isprint(102) ,"isprint should be 1 for f");
}

void t_isprint_0x67()
{
    Assert(isprint(103) ,"isprint should be 1 for g");
}

void t_isprint_0x68()
{
    Assert(isprint(104) ,"isprint should be 1 for h");
}

void t_isprint_0x69()
{
    Assert(isprint(105) ,"isprint should be 1 for i");
}

void t_isprint_0x6a()
{
    Assert(isprint(106) ,"isprint should be 1 for j");
}

void t_isprint_0x6b()
{
    Assert(isprint(107) ,"isprint should be 1 for k");
}

void t_isprint_0x6c()
{
    Assert(isprint(108) ,"isprint should be 1 for l");
}

void t_isprint_0x6d()
{
    Assert(isprint(109) ,"isprint should be 1 for m");
}

void t_isprint_0x6e()
{
    Assert(isprint(110) ,"isprint should be 1 for n");
}

void t_isprint_0x6f()
{
    Assert(isprint(111) ,"isprint should be 1 for o");
}

void t_isprint_0x70()
{
    Assert(isprint(112) ,"isprint should be 1 for p");
}

void t_isprint_0x71()
{
    Assert(isprint(113) ,"isprint should be 1 for q");
}

void t_isprint_0x72()
{
    Assert(isprint(114) ,"isprint should be 1 for r");
}

void t_isprint_0x73()
{
    Assert(isprint(115) ,"isprint should be 1 for s");
}

void t_isprint_0x74()
{
    Assert(isprint(116) ,"isprint should be 1 for t");
}

void t_isprint_0x75()
{
    Assert(isprint(117) ,"isprint should be 1 for u");
}

void t_isprint_0x76()
{
    Assert(isprint(118) ,"isprint should be 1 for v");
}

void t_isprint_0x77()
{
    Assert(isprint(119) ,"isprint should be 1 for w");
}

void t_isprint_0x78()
{
    Assert(isprint(120) ,"isprint should be 1 for x");
}

void t_isprint_0x79()
{
    Assert(isprint(121) ,"isprint should be 1 for y");
}

void t_isprint_0x7a()
{
    Assert(isprint(122) ,"isprint should be 1 for z");
}

void t_isprint_0x7b()
{
    Assert(isprint(123) ,"isprint should be 1 for {");
}

void t_isprint_0x7c()
{
    Assert(isprint(124) ,"isprint should be 1 for |");
}

void t_isprint_0x7d()
{
    Assert(isprint(125) ,"isprint should be 1 for }");
}

void t_isprint_0x7e()
{
    Assert(isprint(126) ,"isprint should be 1 for ~");
}

void t_isprint_0x7f()
{
    Assert(isprint(127)  == 0 ,"isprint should be 0 for 0x7f");
}

void t_isprint_0x80()
{
    Assert(isprint(128)  == 0 ,"isprint should be 0 for 0x80");
}

void t_isprint_0x81()
{
    Assert(isprint(129)  == 0 ,"isprint should be 0 for 0x81");
}

void t_isprint_0x82()
{
    Assert(isprint(130)  == 0 ,"isprint should be 0 for 0x82");
}

void t_isprint_0x83()
{
    Assert(isprint(131)  == 0 ,"isprint should be 0 for 0x83");
}

void t_isprint_0x84()
{
    Assert(isprint(132)  == 0 ,"isprint should be 0 for 0x84");
}

void t_isprint_0x85()
{
    Assert(isprint(133)  == 0 ,"isprint should be 0 for 0x85");
}

void t_isprint_0x86()
{
    Assert(isprint(134)  == 0 ,"isprint should be 0 for 0x86");
}

void t_isprint_0x87()
{
    Assert(isprint(135)  == 0 ,"isprint should be 0 for 0x87");
}

void t_isprint_0x88()
{
    Assert(isprint(136)  == 0 ,"isprint should be 0 for 0x88");
}

void t_isprint_0x89()
{
    Assert(isprint(137)  == 0 ,"isprint should be 0 for 0x89");
}

void t_isprint_0x8a()
{
    Assert(isprint(138)  == 0 ,"isprint should be 0 for 0x8a");
}

void t_isprint_0x8b()
{
    Assert(isprint(139)  == 0 ,"isprint should be 0 for 0x8b");
}

void t_isprint_0x8c()
{
    Assert(isprint(140)  == 0 ,"isprint should be 0 for 0x8c");
}

void t_isprint_0x8d()
{
    Assert(isprint(141)  == 0 ,"isprint should be 0 for 0x8d");
}

void t_isprint_0x8e()
{
    Assert(isprint(142)  == 0 ,"isprint should be 0 for 0x8e");
}

void t_isprint_0x8f()
{
    Assert(isprint(143)  == 0 ,"isprint should be 0 for 0x8f");
}

void t_isprint_0x90()
{
    Assert(isprint(144)  == 0 ,"isprint should be 0 for 0x90");
}

void t_isprint_0x91()
{
    Assert(isprint(145)  == 0 ,"isprint should be 0 for 0x91");
}

void t_isprint_0x92()
{
    Assert(isprint(146)  == 0 ,"isprint should be 0 for 0x92");
}

void t_isprint_0x93()
{
    Assert(isprint(147)  == 0 ,"isprint should be 0 for 0x93");
}

void t_isprint_0x94()
{
    Assert(isprint(148)  == 0 ,"isprint should be 0 for 0x94");
}

void t_isprint_0x95()
{
    Assert(isprint(149)  == 0 ,"isprint should be 0 for 0x95");
}

void t_isprint_0x96()
{
    Assert(isprint(150)  == 0 ,"isprint should be 0 for 0x96");
}

void t_isprint_0x97()
{
    Assert(isprint(151)  == 0 ,"isprint should be 0 for 0x97");
}

void t_isprint_0x98()
{
    Assert(isprint(152)  == 0 ,"isprint should be 0 for 0x98");
}

void t_isprint_0x99()
{
    Assert(isprint(153)  == 0 ,"isprint should be 0 for 0x99");
}

void t_isprint_0x9a()
{
    Assert(isprint(154)  == 0 ,"isprint should be 0 for 0x9a");
}

void t_isprint_0x9b()
{
    Assert(isprint(155)  == 0 ,"isprint should be 0 for 0x9b");
}

void t_isprint_0x9c()
{
    Assert(isprint(156)  == 0 ,"isprint should be 0 for 0x9c");
}

void t_isprint_0x9d()
{
    Assert(isprint(157)  == 0 ,"isprint should be 0 for 0x9d");
}

void t_isprint_0x9e()
{
    Assert(isprint(158)  == 0 ,"isprint should be 0 for 0x9e");
}

void t_isprint_0x9f()
{
    Assert(isprint(159)  == 0 ,"isprint should be 0 for 0x9f");
}

void t_isprint_0xa0()
{
    Assert(isprint(160)  == 0 ,"isprint should be 0 for 0xa0");
}

void t_isprint_0xa1()
{
    Assert(isprint(161)  == 0 ,"isprint should be 0 for 0xa1");
}

void t_isprint_0xa2()
{
    Assert(isprint(162)  == 0 ,"isprint should be 0 for 0xa2");
}

void t_isprint_0xa3()
{
    Assert(isprint(163)  == 0 ,"isprint should be 0 for 0xa3");
}

void t_isprint_0xa4()
{
    Assert(isprint(164)  == 0 ,"isprint should be 0 for 0xa4");
}

void t_isprint_0xa5()
{
    Assert(isprint(165)  == 0 ,"isprint should be 0 for 0xa5");
}

void t_isprint_0xa6()
{
    Assert(isprint(166)  == 0 ,"isprint should be 0 for 0xa6");
}

void t_isprint_0xa7()
{
    Assert(isprint(167)  == 0 ,"isprint should be 0 for 0xa7");
}

void t_isprint_0xa8()
{
    Assert(isprint(168)  == 0 ,"isprint should be 0 for 0xa8");
}

void t_isprint_0xa9()
{
    Assert(isprint(169)  == 0 ,"isprint should be 0 for 0xa9");
}

void t_isprint_0xaa()
{
    Assert(isprint(170)  == 0 ,"isprint should be 0 for 0xaa");
}

void t_isprint_0xab()
{
    Assert(isprint(171)  == 0 ,"isprint should be 0 for 0xab");
}

void t_isprint_0xac()
{
    Assert(isprint(172)  == 0 ,"isprint should be 0 for 0xac");
}

void t_isprint_0xad()
{
    Assert(isprint(173)  == 0 ,"isprint should be 0 for 0xad");
}

void t_isprint_0xae()
{
    Assert(isprint(174)  == 0 ,"isprint should be 0 for 0xae");
}

void t_isprint_0xaf()
{
    Assert(isprint(175)  == 0 ,"isprint should be 0 for 0xaf");
}

void t_isprint_0xb0()
{
    Assert(isprint(176)  == 0 ,"isprint should be 0 for 0xb0");
}

void t_isprint_0xb1()
{
    Assert(isprint(177)  == 0 ,"isprint should be 0 for 0xb1");
}

void t_isprint_0xb2()
{
    Assert(isprint(178)  == 0 ,"isprint should be 0 for 0xb2");
}

void t_isprint_0xb3()
{
    Assert(isprint(179)  == 0 ,"isprint should be 0 for 0xb3");
}

void t_isprint_0xb4()
{
    Assert(isprint(180)  == 0 ,"isprint should be 0 for 0xb4");
}

void t_isprint_0xb5()
{
    Assert(isprint(181)  == 0 ,"isprint should be 0 for 0xb5");
}

void t_isprint_0xb6()
{
    Assert(isprint(182)  == 0 ,"isprint should be 0 for 0xb6");
}

void t_isprint_0xb7()
{
    Assert(isprint(183)  == 0 ,"isprint should be 0 for 0xb7");
}

void t_isprint_0xb8()
{
    Assert(isprint(184)  == 0 ,"isprint should be 0 for 0xb8");
}

void t_isprint_0xb9()
{
    Assert(isprint(185)  == 0 ,"isprint should be 0 for 0xb9");
}

void t_isprint_0xba()
{
    Assert(isprint(186)  == 0 ,"isprint should be 0 for 0xba");
}

void t_isprint_0xbb()
{
    Assert(isprint(187)  == 0 ,"isprint should be 0 for 0xbb");
}

void t_isprint_0xbc()
{
    Assert(isprint(188)  == 0 ,"isprint should be 0 for 0xbc");
}

void t_isprint_0xbd()
{
    Assert(isprint(189)  == 0 ,"isprint should be 0 for 0xbd");
}

void t_isprint_0xbe()
{
    Assert(isprint(190)  == 0 ,"isprint should be 0 for 0xbe");
}

void t_isprint_0xbf()
{
    Assert(isprint(191)  == 0 ,"isprint should be 0 for 0xbf");
}

void t_isprint_0xc0()
{
    Assert(isprint(192)  == 0 ,"isprint should be 0 for 0xc0");
}

void t_isprint_0xc1()
{
    Assert(isprint(193)  == 0 ,"isprint should be 0 for 0xc1");
}

void t_isprint_0xc2()
{
    Assert(isprint(194)  == 0 ,"isprint should be 0 for 0xc2");
}

void t_isprint_0xc3()
{
    Assert(isprint(195)  == 0 ,"isprint should be 0 for 0xc3");
}

void t_isprint_0xc4()
{
    Assert(isprint(196)  == 0 ,"isprint should be 0 for 0xc4");
}

void t_isprint_0xc5()
{
    Assert(isprint(197)  == 0 ,"isprint should be 0 for 0xc5");
}

void t_isprint_0xc6()
{
    Assert(isprint(198)  == 0 ,"isprint should be 0 for 0xc6");
}

void t_isprint_0xc7()
{
    Assert(isprint(199)  == 0 ,"isprint should be 0 for 0xc7");
}

void t_isprint_0xc8()
{
    Assert(isprint(200)  == 0 ,"isprint should be 0 for 0xc8");
}

void t_isprint_0xc9()
{
    Assert(isprint(201)  == 0 ,"isprint should be 0 for 0xc9");
}

void t_isprint_0xca()
{
    Assert(isprint(202)  == 0 ,"isprint should be 0 for 0xca");
}

void t_isprint_0xcb()
{
    Assert(isprint(203)  == 0 ,"isprint should be 0 for 0xcb");
}

void t_isprint_0xcc()
{
    Assert(isprint(204)  == 0 ,"isprint should be 0 for 0xcc");
}

void t_isprint_0xcd()
{
    Assert(isprint(205)  == 0 ,"isprint should be 0 for 0xcd");
}

void t_isprint_0xce()
{
    Assert(isprint(206)  == 0 ,"isprint should be 0 for 0xce");
}

void t_isprint_0xcf()
{
    Assert(isprint(207)  == 0 ,"isprint should be 0 for 0xcf");
}

void t_isprint_0xd0()
{
    Assert(isprint(208)  == 0 ,"isprint should be 0 for 0xd0");
}

void t_isprint_0xd1()
{
    Assert(isprint(209)  == 0 ,"isprint should be 0 for 0xd1");
}

void t_isprint_0xd2()
{
    Assert(isprint(210)  == 0 ,"isprint should be 0 for 0xd2");
}

void t_isprint_0xd3()
{
    Assert(isprint(211)  == 0 ,"isprint should be 0 for 0xd3");
}

void t_isprint_0xd4()
{
    Assert(isprint(212)  == 0 ,"isprint should be 0 for 0xd4");
}

void t_isprint_0xd5()
{
    Assert(isprint(213)  == 0 ,"isprint should be 0 for 0xd5");
}

void t_isprint_0xd6()
{
    Assert(isprint(214)  == 0 ,"isprint should be 0 for 0xd6");
}

void t_isprint_0xd7()
{
    Assert(isprint(215)  == 0 ,"isprint should be 0 for 0xd7");
}

void t_isprint_0xd8()
{
    Assert(isprint(216)  == 0 ,"isprint should be 0 for 0xd8");
}

void t_isprint_0xd9()
{
    Assert(isprint(217)  == 0 ,"isprint should be 0 for 0xd9");
}

void t_isprint_0xda()
{
    Assert(isprint(218)  == 0 ,"isprint should be 0 for 0xda");
}

void t_isprint_0xdb()
{
    Assert(isprint(219)  == 0 ,"isprint should be 0 for 0xdb");
}

void t_isprint_0xdc()
{
    Assert(isprint(220)  == 0 ,"isprint should be 0 for 0xdc");
}

void t_isprint_0xdd()
{
    Assert(isprint(221)  == 0 ,"isprint should be 0 for 0xdd");
}

void t_isprint_0xde()
{
    Assert(isprint(222)  == 0 ,"isprint should be 0 for 0xde");
}

void t_isprint_0xdf()
{
    Assert(isprint(223)  == 0 ,"isprint should be 0 for 0xdf");
}

void t_isprint_0xe0()
{
    Assert(isprint(224)  == 0 ,"isprint should be 0 for 0xe0");
}

void t_isprint_0xe1()
{
    Assert(isprint(225)  == 0 ,"isprint should be 0 for 0xe1");
}

void t_isprint_0xe2()
{
    Assert(isprint(226)  == 0 ,"isprint should be 0 for 0xe2");
}

void t_isprint_0xe3()
{
    Assert(isprint(227)  == 0 ,"isprint should be 0 for 0xe3");
}

void t_isprint_0xe4()
{
    Assert(isprint(228)  == 0 ,"isprint should be 0 for 0xe4");
}

void t_isprint_0xe5()
{
    Assert(isprint(229)  == 0 ,"isprint should be 0 for 0xe5");
}

void t_isprint_0xe6()
{
    Assert(isprint(230)  == 0 ,"isprint should be 0 for 0xe6");
}

void t_isprint_0xe7()
{
    Assert(isprint(231)  == 0 ,"isprint should be 0 for 0xe7");
}

void t_isprint_0xe8()
{
    Assert(isprint(232)  == 0 ,"isprint should be 0 for 0xe8");
}

void t_isprint_0xe9()
{
    Assert(isprint(233)  == 0 ,"isprint should be 0 for 0xe9");
}

void t_isprint_0xea()
{
    Assert(isprint(234)  == 0 ,"isprint should be 0 for 0xea");
}

void t_isprint_0xeb()
{
    Assert(isprint(235)  == 0 ,"isprint should be 0 for 0xeb");
}

void t_isprint_0xec()
{
    Assert(isprint(236)  == 0 ,"isprint should be 0 for 0xec");
}

void t_isprint_0xed()
{
    Assert(isprint(237)  == 0 ,"isprint should be 0 for 0xed");
}

void t_isprint_0xee()
{
    Assert(isprint(238)  == 0 ,"isprint should be 0 for 0xee");
}

void t_isprint_0xef()
{
    Assert(isprint(239)  == 0 ,"isprint should be 0 for 0xef");
}

void t_isprint_0xf0()
{
    Assert(isprint(240)  == 0 ,"isprint should be 0 for 0xf0");
}

void t_isprint_0xf1()
{
    Assert(isprint(241)  == 0 ,"isprint should be 0 for 0xf1");
}

void t_isprint_0xf2()
{
    Assert(isprint(242)  == 0 ,"isprint should be 0 for 0xf2");
}

void t_isprint_0xf3()
{
    Assert(isprint(243)  == 0 ,"isprint should be 0 for 0xf3");
}

void t_isprint_0xf4()
{
    Assert(isprint(244)  == 0 ,"isprint should be 0 for 0xf4");
}

void t_isprint_0xf5()
{
    Assert(isprint(245)  == 0 ,"isprint should be 0 for 0xf5");
}

void t_isprint_0xf6()
{
    Assert(isprint(246)  == 0 ,"isprint should be 0 for 0xf6");
}

void t_isprint_0xf7()
{
    Assert(isprint(247)  == 0 ,"isprint should be 0 for 0xf7");
}

void t_isprint_0xf8()
{
    Assert(isprint(248)  == 0 ,"isprint should be 0 for 0xf8");
}

void t_isprint_0xf9()
{
    Assert(isprint(249)  == 0 ,"isprint should be 0 for 0xf9");
}

void t_isprint_0xfa()
{
    Assert(isprint(250)  == 0 ,"isprint should be 0 for 0xfa");
}

void t_isprint_0xfb()
{
    Assert(isprint(251)  == 0 ,"isprint should be 0 for 0xfb");
}

void t_isprint_0xfc()
{
    Assert(isprint(252)  == 0 ,"isprint should be 0 for 0xfc");
}

void t_isprint_0xfd()
{
    Assert(isprint(253)  == 0 ,"isprint should be 0 for 0xfd");
}

void t_isprint_0xfe()
{
    Assert(isprint(254)  == 0 ,"isprint should be 0 for 0xfe");
}

void t_isprint_0xff()
{
    Assert(isprint(255)  == 0 ,"isprint should be 0 for 0xff");
}



int test_isprint()
{
    suite_setup("isprint");
    suite_add_test(t_isprint_0x00);
    suite_add_test(t_isprint_0x01);
    suite_add_test(t_isprint_0x02);
    suite_add_test(t_isprint_0x03);
    suite_add_test(t_isprint_0x04);
    suite_add_test(t_isprint_0x05);
    suite_add_test(t_isprint_0x06);
    suite_add_test(t_isprint_0x07);
    suite_add_test(t_isprint_0x08);
    suite_add_test(t_isprint_0x09);
    suite_add_test(t_isprint_0x0a);
    suite_add_test(t_isprint_0x0b);
    suite_add_test(t_isprint_0x0c);
    suite_add_test(t_isprint_0x0d);
    suite_add_test(t_isprint_0x0e);
    suite_add_test(t_isprint_0x0f);
    suite_add_test(t_isprint_0x10);
    suite_add_test(t_isprint_0x11);
    suite_add_test(t_isprint_0x12);
    suite_add_test(t_isprint_0x13);
    suite_add_test(t_isprint_0x14);
    suite_add_test(t_isprint_0x15);
    suite_add_test(t_isprint_0x16);
    suite_add_test(t_isprint_0x17);
    suite_add_test(t_isprint_0x18);
    suite_add_test(t_isprint_0x19);
    suite_add_test(t_isprint_0x1a);
    suite_add_test(t_isprint_0x1b);
    suite_add_test(t_isprint_0x1c);
    suite_add_test(t_isprint_0x1d);
    suite_add_test(t_isprint_0x1e);
    suite_add_test(t_isprint_0x1f);
    suite_add_test(t_isprint_0x20);
    suite_add_test(t_isprint_0x21);
    suite_add_test(t_isprint_0x22);
    suite_add_test(t_isprint_0x23);
    suite_add_test(t_isprint_0x24);
    suite_add_test(t_isprint_0x25);
    suite_add_test(t_isprint_0x26);
    suite_add_test(t_isprint_0x27);
    suite_add_test(t_isprint_0x28);
    suite_add_test(t_isprint_0x29);
    suite_add_test(t_isprint_0x2a);
    suite_add_test(t_isprint_0x2b);
    suite_add_test(t_isprint_0x2c);
    suite_add_test(t_isprint_0x2d);
    suite_add_test(t_isprint_0x2e);
    suite_add_test(t_isprint_0x2f);
    suite_add_test(t_isprint_0x30);
    suite_add_test(t_isprint_0x31);
    suite_add_test(t_isprint_0x32);
    suite_add_test(t_isprint_0x33);
    suite_add_test(t_isprint_0x34);
    suite_add_test(t_isprint_0x35);
    suite_add_test(t_isprint_0x36);
    suite_add_test(t_isprint_0x37);
    suite_add_test(t_isprint_0x38);
    suite_add_test(t_isprint_0x39);
    suite_add_test(t_isprint_0x3a);
    suite_add_test(t_isprint_0x3b);
    suite_add_test(t_isprint_0x3c);
    suite_add_test(t_isprint_0x3d);
    suite_add_test(t_isprint_0x3e);
    suite_add_test(t_isprint_0x3f);
    suite_add_test(t_isprint_0x40);
    suite_add_test(t_isprint_0x41);
    suite_add_test(t_isprint_0x42);
    suite_add_test(t_isprint_0x43);
    suite_add_test(t_isprint_0x44);
    suite_add_test(t_isprint_0x45);
    suite_add_test(t_isprint_0x46);
    suite_add_test(t_isprint_0x47);
    suite_add_test(t_isprint_0x48);
    suite_add_test(t_isprint_0x49);
    suite_add_test(t_isprint_0x4a);
    suite_add_test(t_isprint_0x4b);
    suite_add_test(t_isprint_0x4c);
    suite_add_test(t_isprint_0x4d);
    suite_add_test(t_isprint_0x4e);
    suite_add_test(t_isprint_0x4f);
    suite_add_test(t_isprint_0x50);
    suite_add_test(t_isprint_0x51);
    suite_add_test(t_isprint_0x52);
    suite_add_test(t_isprint_0x53);
    suite_add_test(t_isprint_0x54);
    suite_add_test(t_isprint_0x55);
    suite_add_test(t_isprint_0x56);
    suite_add_test(t_isprint_0x57);
    suite_add_test(t_isprint_0x58);
    suite_add_test(t_isprint_0x59);
    suite_add_test(t_isprint_0x5a);
    suite_add_test(t_isprint_0x5b);
    suite_add_test(t_isprint_0x5c);
    suite_add_test(t_isprint_0x5d);
    suite_add_test(t_isprint_0x5e);
    suite_add_test(t_isprint_0x5f);
    suite_add_test(t_isprint_0x60);
    suite_add_test(t_isprint_0x61);
    suite_add_test(t_isprint_0x62);
    suite_add_test(t_isprint_0x63);
    suite_add_test(t_isprint_0x64);
    suite_add_test(t_isprint_0x65);
    suite_add_test(t_isprint_0x66);
    suite_add_test(t_isprint_0x67);
    suite_add_test(t_isprint_0x68);
    suite_add_test(t_isprint_0x69);
    suite_add_test(t_isprint_0x6a);
    suite_add_test(t_isprint_0x6b);
    suite_add_test(t_isprint_0x6c);
    suite_add_test(t_isprint_0x6d);
    suite_add_test(t_isprint_0x6e);
    suite_add_test(t_isprint_0x6f);
    suite_add_test(t_isprint_0x70);
    suite_add_test(t_isprint_0x71);
    suite_add_test(t_isprint_0x72);
    suite_add_test(t_isprint_0x73);
    suite_add_test(t_isprint_0x74);
    suite_add_test(t_isprint_0x75);
    suite_add_test(t_isprint_0x76);
    suite_add_test(t_isprint_0x77);
    suite_add_test(t_isprint_0x78);
    suite_add_test(t_isprint_0x79);
    suite_add_test(t_isprint_0x7a);
    suite_add_test(t_isprint_0x7b);
    suite_add_test(t_isprint_0x7c);
    suite_add_test(t_isprint_0x7d);
    suite_add_test(t_isprint_0x7e);
    suite_add_test(t_isprint_0x7f);
    suite_add_test(t_isprint_0x80);
    suite_add_test(t_isprint_0x81);
    suite_add_test(t_isprint_0x82);
    suite_add_test(t_isprint_0x83);
    suite_add_test(t_isprint_0x84);
    suite_add_test(t_isprint_0x85);
    suite_add_test(t_isprint_0x86);
    suite_add_test(t_isprint_0x87);
    suite_add_test(t_isprint_0x88);
    suite_add_test(t_isprint_0x89);
    suite_add_test(t_isprint_0x8a);
    suite_add_test(t_isprint_0x8b);
    suite_add_test(t_isprint_0x8c);
    suite_add_test(t_isprint_0x8d);
    suite_add_test(t_isprint_0x8e);
    suite_add_test(t_isprint_0x8f);
    suite_add_test(t_isprint_0x90);
    suite_add_test(t_isprint_0x91);
    suite_add_test(t_isprint_0x92);
    suite_add_test(t_isprint_0x93);
    suite_add_test(t_isprint_0x94);
    suite_add_test(t_isprint_0x95);
    suite_add_test(t_isprint_0x96);
    suite_add_test(t_isprint_0x97);
    suite_add_test(t_isprint_0x98);
    suite_add_test(t_isprint_0x99);
    suite_add_test(t_isprint_0x9a);
    suite_add_test(t_isprint_0x9b);
    suite_add_test(t_isprint_0x9c);
    suite_add_test(t_isprint_0x9d);
    suite_add_test(t_isprint_0x9e);
    suite_add_test(t_isprint_0x9f);
    suite_add_test(t_isprint_0xa0);
    suite_add_test(t_isprint_0xa1);
    suite_add_test(t_isprint_0xa2);
    suite_add_test(t_isprint_0xa3);
    suite_add_test(t_isprint_0xa4);
    suite_add_test(t_isprint_0xa5);
    suite_add_test(t_isprint_0xa6);
    suite_add_test(t_isprint_0xa7);
    suite_add_test(t_isprint_0xa8);
    suite_add_test(t_isprint_0xa9);
    suite_add_test(t_isprint_0xaa);
    suite_add_test(t_isprint_0xab);
    suite_add_test(t_isprint_0xac);
    suite_add_test(t_isprint_0xad);
    suite_add_test(t_isprint_0xae);
    suite_add_test(t_isprint_0xaf);
    suite_add_test(t_isprint_0xb0);
    suite_add_test(t_isprint_0xb1);
    suite_add_test(t_isprint_0xb2);
    suite_add_test(t_isprint_0xb3);
    suite_add_test(t_isprint_0xb4);
    suite_add_test(t_isprint_0xb5);
    suite_add_test(t_isprint_0xb6);
    suite_add_test(t_isprint_0xb7);
    suite_add_test(t_isprint_0xb8);
    suite_add_test(t_isprint_0xb9);
    suite_add_test(t_isprint_0xba);
    suite_add_test(t_isprint_0xbb);
    suite_add_test(t_isprint_0xbc);
    suite_add_test(t_isprint_0xbd);
    suite_add_test(t_isprint_0xbe);
    suite_add_test(t_isprint_0xbf);
    suite_add_test(t_isprint_0xc0);
    suite_add_test(t_isprint_0xc1);
    suite_add_test(t_isprint_0xc2);
    suite_add_test(t_isprint_0xc3);
    suite_add_test(t_isprint_0xc4);
    suite_add_test(t_isprint_0xc5);
    suite_add_test(t_isprint_0xc6);
    suite_add_test(t_isprint_0xc7);
    suite_add_test(t_isprint_0xc8);
    suite_add_test(t_isprint_0xc9);
    suite_add_test(t_isprint_0xca);
    suite_add_test(t_isprint_0xcb);
    suite_add_test(t_isprint_0xcc);
    suite_add_test(t_isprint_0xcd);
    suite_add_test(t_isprint_0xce);
    suite_add_test(t_isprint_0xcf);
    suite_add_test(t_isprint_0xd0);
    suite_add_test(t_isprint_0xd1);
    suite_add_test(t_isprint_0xd2);
    suite_add_test(t_isprint_0xd3);
    suite_add_test(t_isprint_0xd4);
    suite_add_test(t_isprint_0xd5);
    suite_add_test(t_isprint_0xd6);
    suite_add_test(t_isprint_0xd7);
    suite_add_test(t_isprint_0xd8);
    suite_add_test(t_isprint_0xd9);
    suite_add_test(t_isprint_0xda);
    suite_add_test(t_isprint_0xdb);
    suite_add_test(t_isprint_0xdc);
    suite_add_test(t_isprint_0xdd);
    suite_add_test(t_isprint_0xde);
    suite_add_test(t_isprint_0xdf);
    suite_add_test(t_isprint_0xe0);
    suite_add_test(t_isprint_0xe1);
    suite_add_test(t_isprint_0xe2);
    suite_add_test(t_isprint_0xe3);
    suite_add_test(t_isprint_0xe4);
    suite_add_test(t_isprint_0xe5);
    suite_add_test(t_isprint_0xe6);
    suite_add_test(t_isprint_0xe7);
    suite_add_test(t_isprint_0xe8);
    suite_add_test(t_isprint_0xe9);
    suite_add_test(t_isprint_0xea);
    suite_add_test(t_isprint_0xeb);
    suite_add_test(t_isprint_0xec);
    suite_add_test(t_isprint_0xed);
    suite_add_test(t_isprint_0xee);
    suite_add_test(t_isprint_0xef);
    suite_add_test(t_isprint_0xf0);
    suite_add_test(t_isprint_0xf1);
    suite_add_test(t_isprint_0xf2);
    suite_add_test(t_isprint_0xf3);
    suite_add_test(t_isprint_0xf4);
    suite_add_test(t_isprint_0xf5);
    suite_add_test(t_isprint_0xf6);
    suite_add_test(t_isprint_0xf7);
    suite_add_test(t_isprint_0xf8);
    suite_add_test(t_isprint_0xf9);
    suite_add_test(t_isprint_0xfa);
    suite_add_test(t_isprint_0xfb);
    suite_add_test(t_isprint_0xfc);
    suite_add_test(t_isprint_0xfd);
    suite_add_test(t_isprint_0xfe);
    suite_add_test(t_isprint_0xff);
     return suite_run();
}
