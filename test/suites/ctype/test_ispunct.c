
#include "ctype_test.h"
void t_ispunct_0x00()
{
    Assert(ispunct(0)  == 0 ,"ispunct should be 0 for 0x00");
}

void t_ispunct_0x01()
{
    Assert(ispunct(1)  == 0 ,"ispunct should be 0 for 0x01");
}

void t_ispunct_0x02()
{
    Assert(ispunct(2)  == 0 ,"ispunct should be 0 for 0x02");
}

void t_ispunct_0x03()
{
    Assert(ispunct(3)  == 0 ,"ispunct should be 0 for 0x03");
}

void t_ispunct_0x04()
{
    Assert(ispunct(4)  == 0 ,"ispunct should be 0 for 0x04");
}

void t_ispunct_0x05()
{
    Assert(ispunct(5)  == 0 ,"ispunct should be 0 for 0x05");
}

void t_ispunct_0x06()
{
    Assert(ispunct(6)  == 0 ,"ispunct should be 0 for 0x06");
}

void t_ispunct_0x07()
{
    Assert(ispunct(7)  == 0 ,"ispunct should be 0 for 0x07");
}

void t_ispunct_0x08()
{
    Assert(ispunct(8)  == 0 ,"ispunct should be 0 for 0x08");
}

void t_ispunct_0x09()
{
    Assert(ispunct(9)  == 0 ,"ispunct should be 0 for 0x09");
}

void t_ispunct_0x0a()
{
    Assert(ispunct(10)  == 0 ,"ispunct should be 0 for 0x0a");
}

void t_ispunct_0x0b()
{
    Assert(ispunct(11)  == 0 ,"ispunct should be 0 for 0x0b");
}

void t_ispunct_0x0c()
{
    Assert(ispunct(12)  == 0 ,"ispunct should be 0 for 0x0c");
}

void t_ispunct_0x0d()
{
    Assert(ispunct(13)  == 0 ,"ispunct should be 0 for 0x0d");
}

void t_ispunct_0x0e()
{
    Assert(ispunct(14)  == 0 ,"ispunct should be 0 for 0x0e");
}

void t_ispunct_0x0f()
{
    Assert(ispunct(15)  == 0 ,"ispunct should be 0 for 0x0f");
}

void t_ispunct_0x10()
{
    Assert(ispunct(16)  == 0 ,"ispunct should be 0 for 0x10");
}

void t_ispunct_0x11()
{
    Assert(ispunct(17)  == 0 ,"ispunct should be 0 for 0x11");
}

void t_ispunct_0x12()
{
    Assert(ispunct(18)  == 0 ,"ispunct should be 0 for 0x12");
}

void t_ispunct_0x13()
{
    Assert(ispunct(19)  == 0 ,"ispunct should be 0 for 0x13");
}

void t_ispunct_0x14()
{
    Assert(ispunct(20)  == 0 ,"ispunct should be 0 for 0x14");
}

void t_ispunct_0x15()
{
    Assert(ispunct(21)  == 0 ,"ispunct should be 0 for 0x15");
}

void t_ispunct_0x16()
{
    Assert(ispunct(22)  == 0 ,"ispunct should be 0 for 0x16");
}

void t_ispunct_0x17()
{
    Assert(ispunct(23)  == 0 ,"ispunct should be 0 for 0x17");
}

void t_ispunct_0x18()
{
    Assert(ispunct(24)  == 0 ,"ispunct should be 0 for 0x18");
}

void t_ispunct_0x19()
{
    Assert(ispunct(25)  == 0 ,"ispunct should be 0 for 0x19");
}

void t_ispunct_0x1a()
{
    Assert(ispunct(26)  == 0 ,"ispunct should be 0 for 0x1a");
}

void t_ispunct_0x1b()
{
    Assert(ispunct(27)  == 0 ,"ispunct should be 0 for 0x1b");
}

void t_ispunct_0x1c()
{
    Assert(ispunct(28)  == 0 ,"ispunct should be 0 for 0x1c");
}

void t_ispunct_0x1d()
{
    Assert(ispunct(29)  == 0 ,"ispunct should be 0 for 0x1d");
}

void t_ispunct_0x1e()
{
    Assert(ispunct(30)  == 0 ,"ispunct should be 0 for 0x1e");
}

void t_ispunct_0x1f()
{
    Assert(ispunct(31)  == 0 ,"ispunct should be 0 for 0x1f");
}

void t_ispunct_0x20()
{
    Assert(ispunct(32)  == 0 ,"ispunct should be 0 for  ");
}

void t_ispunct_0x21()
{
    Assert(ispunct(33) ,"ispunct should be 1 for !");
}

void t_ispunct_0x22()
{
    Assert(ispunct(34) ,"ispunct should be 1 for 0x22");
}

void t_ispunct_0x23()
{
    Assert(ispunct(35) ,"ispunct should be 1 for #");
}

void t_ispunct_0x24()
{
    Assert(ispunct(36) ,"ispunct should be 1 for $");
}

void t_ispunct_0x25()
{
    Assert(ispunct(37) ,"ispunct should be 1 for %");
}

void t_ispunct_0x26()
{
    Assert(ispunct(38) ,"ispunct should be 1 for &");
}

void t_ispunct_0x27()
{
    Assert(ispunct(39) ,"ispunct should be 1 for '");
}

void t_ispunct_0x28()
{
    Assert(ispunct(40) ,"ispunct should be 1 for (");
}

void t_ispunct_0x29()
{
    Assert(ispunct(41) ,"ispunct should be 1 for )");
}

void t_ispunct_0x2a()
{
    Assert(ispunct(42) ,"ispunct should be 1 for *");
}

void t_ispunct_0x2b()
{
    Assert(ispunct(43) ,"ispunct should be 1 for +");
}

void t_ispunct_0x2c()
{
    Assert(ispunct(44) ,"ispunct should be 1 for ,");
}

void t_ispunct_0x2d()
{
    Assert(ispunct(45) ,"ispunct should be 1 for -");
}

void t_ispunct_0x2e()
{
    Assert(ispunct(46) ,"ispunct should be 1 for .");
}

void t_ispunct_0x2f()
{
    Assert(ispunct(47) ,"ispunct should be 1 for /");
}

void t_ispunct_0x30()
{
    Assert(ispunct(48)  == 0 ,"ispunct should be 0 for 0");
}

void t_ispunct_0x31()
{
    Assert(ispunct(49)  == 0 ,"ispunct should be 0 for 1");
}

void t_ispunct_0x32()
{
    Assert(ispunct(50)  == 0 ,"ispunct should be 0 for 2");
}

void t_ispunct_0x33()
{
    Assert(ispunct(51)  == 0 ,"ispunct should be 0 for 3");
}

void t_ispunct_0x34()
{
    Assert(ispunct(52)  == 0 ,"ispunct should be 0 for 4");
}

void t_ispunct_0x35()
{
    Assert(ispunct(53)  == 0 ,"ispunct should be 0 for 5");
}

void t_ispunct_0x36()
{
    Assert(ispunct(54)  == 0 ,"ispunct should be 0 for 6");
}

void t_ispunct_0x37()
{
    Assert(ispunct(55)  == 0 ,"ispunct should be 0 for 7");
}

void t_ispunct_0x38()
{
    Assert(ispunct(56)  == 0 ,"ispunct should be 0 for 8");
}

void t_ispunct_0x39()
{
    Assert(ispunct(57)  == 0 ,"ispunct should be 0 for 9");
}

void t_ispunct_0x3a()
{
    Assert(ispunct(58) ,"ispunct should be 1 for :");
}

void t_ispunct_0x3b()
{
    Assert(ispunct(59) ,"ispunct should be 1 for ;");
}

void t_ispunct_0x3c()
{
    Assert(ispunct(60) ,"ispunct should be 1 for <");
}

void t_ispunct_0x3d()
{
    Assert(ispunct(61) ,"ispunct should be 1 for =");
}

void t_ispunct_0x3e()
{
    Assert(ispunct(62) ,"ispunct should be 1 for >");
}

void t_ispunct_0x3f()
{
    Assert(ispunct(63) ,"ispunct should be 1 for ?");
}

void t_ispunct_0x40()
{
    Assert(ispunct(64) ,"ispunct should be 1 for @");
}

void t_ispunct_0x41()
{
    Assert(ispunct(65)  == 0 ,"ispunct should be 0 for A");
}

void t_ispunct_0x42()
{
    Assert(ispunct(66)  == 0 ,"ispunct should be 0 for B");
}

void t_ispunct_0x43()
{
    Assert(ispunct(67)  == 0 ,"ispunct should be 0 for C");
}

void t_ispunct_0x44()
{
    Assert(ispunct(68)  == 0 ,"ispunct should be 0 for D");
}

void t_ispunct_0x45()
{
    Assert(ispunct(69)  == 0 ,"ispunct should be 0 for E");
}

void t_ispunct_0x46()
{
    Assert(ispunct(70)  == 0 ,"ispunct should be 0 for F");
}

void t_ispunct_0x47()
{
    Assert(ispunct(71)  == 0 ,"ispunct should be 0 for G");
}

void t_ispunct_0x48()
{
    Assert(ispunct(72)  == 0 ,"ispunct should be 0 for H");
}

void t_ispunct_0x49()
{
    Assert(ispunct(73)  == 0 ,"ispunct should be 0 for I");
}

void t_ispunct_0x4a()
{
    Assert(ispunct(74)  == 0 ,"ispunct should be 0 for J");
}

void t_ispunct_0x4b()
{
    Assert(ispunct(75)  == 0 ,"ispunct should be 0 for K");
}

void t_ispunct_0x4c()
{
    Assert(ispunct(76)  == 0 ,"ispunct should be 0 for L");
}

void t_ispunct_0x4d()
{
    Assert(ispunct(77)  == 0 ,"ispunct should be 0 for M");
}

void t_ispunct_0x4e()
{
    Assert(ispunct(78)  == 0 ,"ispunct should be 0 for N");
}

void t_ispunct_0x4f()
{
    Assert(ispunct(79)  == 0 ,"ispunct should be 0 for O");
}

void t_ispunct_0x50()
{
    Assert(ispunct(80)  == 0 ,"ispunct should be 0 for P");
}

void t_ispunct_0x51()
{
    Assert(ispunct(81)  == 0 ,"ispunct should be 0 for Q");
}

void t_ispunct_0x52()
{
    Assert(ispunct(82)  == 0 ,"ispunct should be 0 for R");
}

void t_ispunct_0x53()
{
    Assert(ispunct(83)  == 0 ,"ispunct should be 0 for S");
}

void t_ispunct_0x54()
{
    Assert(ispunct(84)  == 0 ,"ispunct should be 0 for T");
}

void t_ispunct_0x55()
{
    Assert(ispunct(85)  == 0 ,"ispunct should be 0 for U");
}

void t_ispunct_0x56()
{
    Assert(ispunct(86)  == 0 ,"ispunct should be 0 for V");
}

void t_ispunct_0x57()
{
    Assert(ispunct(87)  == 0 ,"ispunct should be 0 for W");
}

void t_ispunct_0x58()
{
    Assert(ispunct(88)  == 0 ,"ispunct should be 0 for X");
}

void t_ispunct_0x59()
{
    Assert(ispunct(89)  == 0 ,"ispunct should be 0 for Y");
}

void t_ispunct_0x5a()
{
    Assert(ispunct(90)  == 0 ,"ispunct should be 0 for Z");
}

void t_ispunct_0x5b()
{
    Assert(ispunct(91) ,"ispunct should be 1 for [");
}

void t_ispunct_0x5c()
{
    Assert(ispunct(92) ,"ispunct should be 1 for 0x5c");
}

void t_ispunct_0x5d()
{
    Assert(ispunct(93) ,"ispunct should be 1 for ]");
}

void t_ispunct_0x5e()
{
    Assert(ispunct(94) ,"ispunct should be 1 for ^");
}

void t_ispunct_0x5f()
{
    Assert(ispunct(95) ,"ispunct should be 1 for _");
}

void t_ispunct_0x60()
{
    Assert(ispunct(96) ,"ispunct should be 1 for `");
}

void t_ispunct_0x61()
{
    Assert(ispunct(97)  == 0 ,"ispunct should be 0 for a");
}

void t_ispunct_0x62()
{
    Assert(ispunct(98)  == 0 ,"ispunct should be 0 for b");
}

void t_ispunct_0x63()
{
    Assert(ispunct(99)  == 0 ,"ispunct should be 0 for c");
}

void t_ispunct_0x64()
{
    Assert(ispunct(100)  == 0 ,"ispunct should be 0 for d");
}

void t_ispunct_0x65()
{
    Assert(ispunct(101)  == 0 ,"ispunct should be 0 for e");
}

void t_ispunct_0x66()
{
    Assert(ispunct(102)  == 0 ,"ispunct should be 0 for f");
}

void t_ispunct_0x67()
{
    Assert(ispunct(103)  == 0 ,"ispunct should be 0 for g");
}

void t_ispunct_0x68()
{
    Assert(ispunct(104)  == 0 ,"ispunct should be 0 for h");
}

void t_ispunct_0x69()
{
    Assert(ispunct(105)  == 0 ,"ispunct should be 0 for i");
}

void t_ispunct_0x6a()
{
    Assert(ispunct(106)  == 0 ,"ispunct should be 0 for j");
}

void t_ispunct_0x6b()
{
    Assert(ispunct(107)  == 0 ,"ispunct should be 0 for k");
}

void t_ispunct_0x6c()
{
    Assert(ispunct(108)  == 0 ,"ispunct should be 0 for l");
}

void t_ispunct_0x6d()
{
    Assert(ispunct(109)  == 0 ,"ispunct should be 0 for m");
}

void t_ispunct_0x6e()
{
    Assert(ispunct(110)  == 0 ,"ispunct should be 0 for n");
}

void t_ispunct_0x6f()
{
    Assert(ispunct(111)  == 0 ,"ispunct should be 0 for o");
}

void t_ispunct_0x70()
{
    Assert(ispunct(112)  == 0 ,"ispunct should be 0 for p");
}

void t_ispunct_0x71()
{
    Assert(ispunct(113)  == 0 ,"ispunct should be 0 for q");
}

void t_ispunct_0x72()
{
    Assert(ispunct(114)  == 0 ,"ispunct should be 0 for r");
}

void t_ispunct_0x73()
{
    Assert(ispunct(115)  == 0 ,"ispunct should be 0 for s");
}

void t_ispunct_0x74()
{
    Assert(ispunct(116)  == 0 ,"ispunct should be 0 for t");
}

void t_ispunct_0x75()
{
    Assert(ispunct(117)  == 0 ,"ispunct should be 0 for u");
}

void t_ispunct_0x76()
{
    Assert(ispunct(118)  == 0 ,"ispunct should be 0 for v");
}

void t_ispunct_0x77()
{
    Assert(ispunct(119)  == 0 ,"ispunct should be 0 for w");
}

void t_ispunct_0x78()
{
    Assert(ispunct(120)  == 0 ,"ispunct should be 0 for x");
}

void t_ispunct_0x79()
{
    Assert(ispunct(121)  == 0 ,"ispunct should be 0 for y");
}

void t_ispunct_0x7a()
{
    Assert(ispunct(122)  == 0 ,"ispunct should be 0 for z");
}

void t_ispunct_0x7b()
{
    Assert(ispunct(123) ,"ispunct should be 1 for {");
}

void t_ispunct_0x7c()
{
    Assert(ispunct(124) ,"ispunct should be 1 for |");
}

void t_ispunct_0x7d()
{
    Assert(ispunct(125) ,"ispunct should be 1 for }");
}

void t_ispunct_0x7e()
{
    Assert(ispunct(126) ,"ispunct should be 1 for ~");
}

void t_ispunct_0x7f()
{
    Assert(ispunct(127)  == 0 ,"ispunct should be 0 for 0x7f");
}

void t_ispunct_0x80()
{
    Assert(ispunct(128)  == 0 ,"ispunct should be 0 for 0x80");
}

void t_ispunct_0x81()
{
    Assert(ispunct(129)  == 0 ,"ispunct should be 0 for 0x81");
}

void t_ispunct_0x82()
{
    Assert(ispunct(130)  == 0 ,"ispunct should be 0 for 0x82");
}

void t_ispunct_0x83()
{
    Assert(ispunct(131)  == 0 ,"ispunct should be 0 for 0x83");
}

void t_ispunct_0x84()
{
    Assert(ispunct(132)  == 0 ,"ispunct should be 0 for 0x84");
}

void t_ispunct_0x85()
{
    Assert(ispunct(133)  == 0 ,"ispunct should be 0 for 0x85");
}

void t_ispunct_0x86()
{
    Assert(ispunct(134)  == 0 ,"ispunct should be 0 for 0x86");
}

void t_ispunct_0x87()
{
    Assert(ispunct(135)  == 0 ,"ispunct should be 0 for 0x87");
}

void t_ispunct_0x88()
{
    Assert(ispunct(136)  == 0 ,"ispunct should be 0 for 0x88");
}

void t_ispunct_0x89()
{
    Assert(ispunct(137)  == 0 ,"ispunct should be 0 for 0x89");
}

void t_ispunct_0x8a()
{
    Assert(ispunct(138)  == 0 ,"ispunct should be 0 for 0x8a");
}

void t_ispunct_0x8b()
{
    Assert(ispunct(139)  == 0 ,"ispunct should be 0 for 0x8b");
}

void t_ispunct_0x8c()
{
    Assert(ispunct(140)  == 0 ,"ispunct should be 0 for 0x8c");
}

void t_ispunct_0x8d()
{
    Assert(ispunct(141)  == 0 ,"ispunct should be 0 for 0x8d");
}

void t_ispunct_0x8e()
{
    Assert(ispunct(142)  == 0 ,"ispunct should be 0 for 0x8e");
}

void t_ispunct_0x8f()
{
    Assert(ispunct(143)  == 0 ,"ispunct should be 0 for 0x8f");
}

void t_ispunct_0x90()
{
    Assert(ispunct(144)  == 0 ,"ispunct should be 0 for 0x90");
}

void t_ispunct_0x91()
{
    Assert(ispunct(145)  == 0 ,"ispunct should be 0 for 0x91");
}

void t_ispunct_0x92()
{
    Assert(ispunct(146)  == 0 ,"ispunct should be 0 for 0x92");
}

void t_ispunct_0x93()
{
    Assert(ispunct(147)  == 0 ,"ispunct should be 0 for 0x93");
}

void t_ispunct_0x94()
{
    Assert(ispunct(148)  == 0 ,"ispunct should be 0 for 0x94");
}

void t_ispunct_0x95()
{
    Assert(ispunct(149)  == 0 ,"ispunct should be 0 for 0x95");
}

void t_ispunct_0x96()
{
    Assert(ispunct(150)  == 0 ,"ispunct should be 0 for 0x96");
}

void t_ispunct_0x97()
{
    Assert(ispunct(151)  == 0 ,"ispunct should be 0 for 0x97");
}

void t_ispunct_0x98()
{
    Assert(ispunct(152)  == 0 ,"ispunct should be 0 for 0x98");
}

void t_ispunct_0x99()
{
    Assert(ispunct(153)  == 0 ,"ispunct should be 0 for 0x99");
}

void t_ispunct_0x9a()
{
    Assert(ispunct(154)  == 0 ,"ispunct should be 0 for 0x9a");
}

void t_ispunct_0x9b()
{
    Assert(ispunct(155)  == 0 ,"ispunct should be 0 for 0x9b");
}

void t_ispunct_0x9c()
{
    Assert(ispunct(156)  == 0 ,"ispunct should be 0 for 0x9c");
}

void t_ispunct_0x9d()
{
    Assert(ispunct(157)  == 0 ,"ispunct should be 0 for 0x9d");
}

void t_ispunct_0x9e()
{
    Assert(ispunct(158)  == 0 ,"ispunct should be 0 for 0x9e");
}

void t_ispunct_0x9f()
{
    Assert(ispunct(159)  == 0 ,"ispunct should be 0 for 0x9f");
}

void t_ispunct_0xa0()
{
    Assert(ispunct(160)  == 0 ,"ispunct should be 0 for 0xa0");
}

void t_ispunct_0xa1()
{
    Assert(ispunct(161)  == 0 ,"ispunct should be 0 for 0xa1");
}

void t_ispunct_0xa2()
{
    Assert(ispunct(162)  == 0 ,"ispunct should be 0 for 0xa2");
}

void t_ispunct_0xa3()
{
    Assert(ispunct(163)  == 0 ,"ispunct should be 0 for 0xa3");
}

void t_ispunct_0xa4()
{
    Assert(ispunct(164)  == 0 ,"ispunct should be 0 for 0xa4");
}

void t_ispunct_0xa5()
{
    Assert(ispunct(165)  == 0 ,"ispunct should be 0 for 0xa5");
}

void t_ispunct_0xa6()
{
    Assert(ispunct(166)  == 0 ,"ispunct should be 0 for 0xa6");
}

void t_ispunct_0xa7()
{
    Assert(ispunct(167)  == 0 ,"ispunct should be 0 for 0xa7");
}

void t_ispunct_0xa8()
{
    Assert(ispunct(168)  == 0 ,"ispunct should be 0 for 0xa8");
}

void t_ispunct_0xa9()
{
    Assert(ispunct(169)  == 0 ,"ispunct should be 0 for 0xa9");
}

void t_ispunct_0xaa()
{
    Assert(ispunct(170)  == 0 ,"ispunct should be 0 for 0xaa");
}

void t_ispunct_0xab()
{
    Assert(ispunct(171)  == 0 ,"ispunct should be 0 for 0xab");
}

void t_ispunct_0xac()
{
    Assert(ispunct(172)  == 0 ,"ispunct should be 0 for 0xac");
}

void t_ispunct_0xad()
{
    Assert(ispunct(173)  == 0 ,"ispunct should be 0 for 0xad");
}

void t_ispunct_0xae()
{
    Assert(ispunct(174)  == 0 ,"ispunct should be 0 for 0xae");
}

void t_ispunct_0xaf()
{
    Assert(ispunct(175)  == 0 ,"ispunct should be 0 for 0xaf");
}

void t_ispunct_0xb0()
{
    Assert(ispunct(176)  == 0 ,"ispunct should be 0 for 0xb0");
}

void t_ispunct_0xb1()
{
    Assert(ispunct(177)  == 0 ,"ispunct should be 0 for 0xb1");
}

void t_ispunct_0xb2()
{
    Assert(ispunct(178)  == 0 ,"ispunct should be 0 for 0xb2");
}

void t_ispunct_0xb3()
{
    Assert(ispunct(179)  == 0 ,"ispunct should be 0 for 0xb3");
}

void t_ispunct_0xb4()
{
    Assert(ispunct(180)  == 0 ,"ispunct should be 0 for 0xb4");
}

void t_ispunct_0xb5()
{
    Assert(ispunct(181)  == 0 ,"ispunct should be 0 for 0xb5");
}

void t_ispunct_0xb6()
{
    Assert(ispunct(182)  == 0 ,"ispunct should be 0 for 0xb6");
}

void t_ispunct_0xb7()
{
    Assert(ispunct(183)  == 0 ,"ispunct should be 0 for 0xb7");
}

void t_ispunct_0xb8()
{
    Assert(ispunct(184)  == 0 ,"ispunct should be 0 for 0xb8");
}

void t_ispunct_0xb9()
{
    Assert(ispunct(185)  == 0 ,"ispunct should be 0 for 0xb9");
}

void t_ispunct_0xba()
{
    Assert(ispunct(186)  == 0 ,"ispunct should be 0 for 0xba");
}

void t_ispunct_0xbb()
{
    Assert(ispunct(187)  == 0 ,"ispunct should be 0 for 0xbb");
}

void t_ispunct_0xbc()
{
    Assert(ispunct(188)  == 0 ,"ispunct should be 0 for 0xbc");
}

void t_ispunct_0xbd()
{
    Assert(ispunct(189)  == 0 ,"ispunct should be 0 for 0xbd");
}

void t_ispunct_0xbe()
{
    Assert(ispunct(190)  == 0 ,"ispunct should be 0 for 0xbe");
}

void t_ispunct_0xbf()
{
    Assert(ispunct(191)  == 0 ,"ispunct should be 0 for 0xbf");
}

void t_ispunct_0xc0()
{
    Assert(ispunct(192)  == 0 ,"ispunct should be 0 for 0xc0");
}

void t_ispunct_0xc1()
{
    Assert(ispunct(193)  == 0 ,"ispunct should be 0 for 0xc1");
}

void t_ispunct_0xc2()
{
    Assert(ispunct(194)  == 0 ,"ispunct should be 0 for 0xc2");
}

void t_ispunct_0xc3()
{
    Assert(ispunct(195)  == 0 ,"ispunct should be 0 for 0xc3");
}

void t_ispunct_0xc4()
{
    Assert(ispunct(196)  == 0 ,"ispunct should be 0 for 0xc4");
}

void t_ispunct_0xc5()
{
    Assert(ispunct(197)  == 0 ,"ispunct should be 0 for 0xc5");
}

void t_ispunct_0xc6()
{
    Assert(ispunct(198)  == 0 ,"ispunct should be 0 for 0xc6");
}

void t_ispunct_0xc7()
{
    Assert(ispunct(199)  == 0 ,"ispunct should be 0 for 0xc7");
}

void t_ispunct_0xc8()
{
    Assert(ispunct(200)  == 0 ,"ispunct should be 0 for 0xc8");
}

void t_ispunct_0xc9()
{
    Assert(ispunct(201)  == 0 ,"ispunct should be 0 for 0xc9");
}

void t_ispunct_0xca()
{
    Assert(ispunct(202)  == 0 ,"ispunct should be 0 for 0xca");
}

void t_ispunct_0xcb()
{
    Assert(ispunct(203)  == 0 ,"ispunct should be 0 for 0xcb");
}

void t_ispunct_0xcc()
{
    Assert(ispunct(204)  == 0 ,"ispunct should be 0 for 0xcc");
}

void t_ispunct_0xcd()
{
    Assert(ispunct(205)  == 0 ,"ispunct should be 0 for 0xcd");
}

void t_ispunct_0xce()
{
    Assert(ispunct(206)  == 0 ,"ispunct should be 0 for 0xce");
}

void t_ispunct_0xcf()
{
    Assert(ispunct(207)  == 0 ,"ispunct should be 0 for 0xcf");
}

void t_ispunct_0xd0()
{
    Assert(ispunct(208)  == 0 ,"ispunct should be 0 for 0xd0");
}

void t_ispunct_0xd1()
{
    Assert(ispunct(209)  == 0 ,"ispunct should be 0 for 0xd1");
}

void t_ispunct_0xd2()
{
    Assert(ispunct(210)  == 0 ,"ispunct should be 0 for 0xd2");
}

void t_ispunct_0xd3()
{
    Assert(ispunct(211)  == 0 ,"ispunct should be 0 for 0xd3");
}

void t_ispunct_0xd4()
{
    Assert(ispunct(212)  == 0 ,"ispunct should be 0 for 0xd4");
}

void t_ispunct_0xd5()
{
    Assert(ispunct(213)  == 0 ,"ispunct should be 0 for 0xd5");
}

void t_ispunct_0xd6()
{
    Assert(ispunct(214)  == 0 ,"ispunct should be 0 for 0xd6");
}

void t_ispunct_0xd7()
{
    Assert(ispunct(215)  == 0 ,"ispunct should be 0 for 0xd7");
}

void t_ispunct_0xd8()
{
    Assert(ispunct(216)  == 0 ,"ispunct should be 0 for 0xd8");
}

void t_ispunct_0xd9()
{
    Assert(ispunct(217)  == 0 ,"ispunct should be 0 for 0xd9");
}

void t_ispunct_0xda()
{
    Assert(ispunct(218)  == 0 ,"ispunct should be 0 for 0xda");
}

void t_ispunct_0xdb()
{
    Assert(ispunct(219)  == 0 ,"ispunct should be 0 for 0xdb");
}

void t_ispunct_0xdc()
{
    Assert(ispunct(220)  == 0 ,"ispunct should be 0 for 0xdc");
}

void t_ispunct_0xdd()
{
    Assert(ispunct(221)  == 0 ,"ispunct should be 0 for 0xdd");
}

void t_ispunct_0xde()
{
    Assert(ispunct(222)  == 0 ,"ispunct should be 0 for 0xde");
}

void t_ispunct_0xdf()
{
    Assert(ispunct(223)  == 0 ,"ispunct should be 0 for 0xdf");
}

void t_ispunct_0xe0()
{
    Assert(ispunct(224)  == 0 ,"ispunct should be 0 for 0xe0");
}

void t_ispunct_0xe1()
{
    Assert(ispunct(225)  == 0 ,"ispunct should be 0 for 0xe1");
}

void t_ispunct_0xe2()
{
    Assert(ispunct(226)  == 0 ,"ispunct should be 0 for 0xe2");
}

void t_ispunct_0xe3()
{
    Assert(ispunct(227)  == 0 ,"ispunct should be 0 for 0xe3");
}

void t_ispunct_0xe4()
{
    Assert(ispunct(228)  == 0 ,"ispunct should be 0 for 0xe4");
}

void t_ispunct_0xe5()
{
    Assert(ispunct(229)  == 0 ,"ispunct should be 0 for 0xe5");
}

void t_ispunct_0xe6()
{
    Assert(ispunct(230)  == 0 ,"ispunct should be 0 for 0xe6");
}

void t_ispunct_0xe7()
{
    Assert(ispunct(231)  == 0 ,"ispunct should be 0 for 0xe7");
}

void t_ispunct_0xe8()
{
    Assert(ispunct(232)  == 0 ,"ispunct should be 0 for 0xe8");
}

void t_ispunct_0xe9()
{
    Assert(ispunct(233)  == 0 ,"ispunct should be 0 for 0xe9");
}

void t_ispunct_0xea()
{
    Assert(ispunct(234)  == 0 ,"ispunct should be 0 for 0xea");
}

void t_ispunct_0xeb()
{
    Assert(ispunct(235)  == 0 ,"ispunct should be 0 for 0xeb");
}

void t_ispunct_0xec()
{
    Assert(ispunct(236)  == 0 ,"ispunct should be 0 for 0xec");
}

void t_ispunct_0xed()
{
    Assert(ispunct(237)  == 0 ,"ispunct should be 0 for 0xed");
}

void t_ispunct_0xee()
{
    Assert(ispunct(238)  == 0 ,"ispunct should be 0 for 0xee");
}

void t_ispunct_0xef()
{
    Assert(ispunct(239)  == 0 ,"ispunct should be 0 for 0xef");
}

void t_ispunct_0xf0()
{
    Assert(ispunct(240)  == 0 ,"ispunct should be 0 for 0xf0");
}

void t_ispunct_0xf1()
{
    Assert(ispunct(241)  == 0 ,"ispunct should be 0 for 0xf1");
}

void t_ispunct_0xf2()
{
    Assert(ispunct(242)  == 0 ,"ispunct should be 0 for 0xf2");
}

void t_ispunct_0xf3()
{
    Assert(ispunct(243)  == 0 ,"ispunct should be 0 for 0xf3");
}

void t_ispunct_0xf4()
{
    Assert(ispunct(244)  == 0 ,"ispunct should be 0 for 0xf4");
}

void t_ispunct_0xf5()
{
    Assert(ispunct(245)  == 0 ,"ispunct should be 0 for 0xf5");
}

void t_ispunct_0xf6()
{
    Assert(ispunct(246)  == 0 ,"ispunct should be 0 for 0xf6");
}

void t_ispunct_0xf7()
{
    Assert(ispunct(247)  == 0 ,"ispunct should be 0 for 0xf7");
}

void t_ispunct_0xf8()
{
    Assert(ispunct(248)  == 0 ,"ispunct should be 0 for 0xf8");
}

void t_ispunct_0xf9()
{
    Assert(ispunct(249)  == 0 ,"ispunct should be 0 for 0xf9");
}

void t_ispunct_0xfa()
{
    Assert(ispunct(250)  == 0 ,"ispunct should be 0 for 0xfa");
}

void t_ispunct_0xfb()
{
    Assert(ispunct(251)  == 0 ,"ispunct should be 0 for 0xfb");
}

void t_ispunct_0xfc()
{
    Assert(ispunct(252)  == 0 ,"ispunct should be 0 for 0xfc");
}

void t_ispunct_0xfd()
{
    Assert(ispunct(253)  == 0 ,"ispunct should be 0 for 0xfd");
}

void t_ispunct_0xfe()
{
    Assert(ispunct(254)  == 0 ,"ispunct should be 0 for 0xfe");
}

void t_ispunct_0xff()
{
    Assert(ispunct(255)  == 0 ,"ispunct should be 0 for 0xff");
}



int test_ispunct()
{
    suite_setup("ispunct");
    suite_add_test(t_ispunct_0x00);
    suite_add_test(t_ispunct_0x01);
    suite_add_test(t_ispunct_0x02);
    suite_add_test(t_ispunct_0x03);
    suite_add_test(t_ispunct_0x04);
    suite_add_test(t_ispunct_0x05);
    suite_add_test(t_ispunct_0x06);
    suite_add_test(t_ispunct_0x07);
    suite_add_test(t_ispunct_0x08);
    suite_add_test(t_ispunct_0x09);
    suite_add_test(t_ispunct_0x0a);
    suite_add_test(t_ispunct_0x0b);
    suite_add_test(t_ispunct_0x0c);
    suite_add_test(t_ispunct_0x0d);
    suite_add_test(t_ispunct_0x0e);
    suite_add_test(t_ispunct_0x0f);
    suite_add_test(t_ispunct_0x10);
    suite_add_test(t_ispunct_0x11);
    suite_add_test(t_ispunct_0x12);
    suite_add_test(t_ispunct_0x13);
    suite_add_test(t_ispunct_0x14);
    suite_add_test(t_ispunct_0x15);
    suite_add_test(t_ispunct_0x16);
    suite_add_test(t_ispunct_0x17);
    suite_add_test(t_ispunct_0x18);
    suite_add_test(t_ispunct_0x19);
    suite_add_test(t_ispunct_0x1a);
    suite_add_test(t_ispunct_0x1b);
    suite_add_test(t_ispunct_0x1c);
    suite_add_test(t_ispunct_0x1d);
    suite_add_test(t_ispunct_0x1e);
    suite_add_test(t_ispunct_0x1f);
    suite_add_test(t_ispunct_0x20);
    suite_add_test(t_ispunct_0x21);
    suite_add_test(t_ispunct_0x22);
    suite_add_test(t_ispunct_0x23);
    suite_add_test(t_ispunct_0x24);
    suite_add_test(t_ispunct_0x25);
    suite_add_test(t_ispunct_0x26);
    suite_add_test(t_ispunct_0x27);
    suite_add_test(t_ispunct_0x28);
    suite_add_test(t_ispunct_0x29);
    suite_add_test(t_ispunct_0x2a);
    suite_add_test(t_ispunct_0x2b);
    suite_add_test(t_ispunct_0x2c);
    suite_add_test(t_ispunct_0x2d);
    suite_add_test(t_ispunct_0x2e);
    suite_add_test(t_ispunct_0x2f);
    suite_add_test(t_ispunct_0x30);
    suite_add_test(t_ispunct_0x31);
    suite_add_test(t_ispunct_0x32);
    suite_add_test(t_ispunct_0x33);
    suite_add_test(t_ispunct_0x34);
    suite_add_test(t_ispunct_0x35);
    suite_add_test(t_ispunct_0x36);
    suite_add_test(t_ispunct_0x37);
    suite_add_test(t_ispunct_0x38);
    suite_add_test(t_ispunct_0x39);
    suite_add_test(t_ispunct_0x3a);
    suite_add_test(t_ispunct_0x3b);
    suite_add_test(t_ispunct_0x3c);
    suite_add_test(t_ispunct_0x3d);
    suite_add_test(t_ispunct_0x3e);
    suite_add_test(t_ispunct_0x3f);
    suite_add_test(t_ispunct_0x40);
    suite_add_test(t_ispunct_0x41);
    suite_add_test(t_ispunct_0x42);
    suite_add_test(t_ispunct_0x43);
    suite_add_test(t_ispunct_0x44);
    suite_add_test(t_ispunct_0x45);
    suite_add_test(t_ispunct_0x46);
    suite_add_test(t_ispunct_0x47);
    suite_add_test(t_ispunct_0x48);
    suite_add_test(t_ispunct_0x49);
    suite_add_test(t_ispunct_0x4a);
    suite_add_test(t_ispunct_0x4b);
    suite_add_test(t_ispunct_0x4c);
    suite_add_test(t_ispunct_0x4d);
    suite_add_test(t_ispunct_0x4e);
    suite_add_test(t_ispunct_0x4f);
    suite_add_test(t_ispunct_0x50);
    suite_add_test(t_ispunct_0x51);
    suite_add_test(t_ispunct_0x52);
    suite_add_test(t_ispunct_0x53);
    suite_add_test(t_ispunct_0x54);
    suite_add_test(t_ispunct_0x55);
    suite_add_test(t_ispunct_0x56);
    suite_add_test(t_ispunct_0x57);
    suite_add_test(t_ispunct_0x58);
    suite_add_test(t_ispunct_0x59);
    suite_add_test(t_ispunct_0x5a);
    suite_add_test(t_ispunct_0x5b);
    suite_add_test(t_ispunct_0x5c);
    suite_add_test(t_ispunct_0x5d);
    suite_add_test(t_ispunct_0x5e);
    suite_add_test(t_ispunct_0x5f);
    suite_add_test(t_ispunct_0x60);
    suite_add_test(t_ispunct_0x61);
    suite_add_test(t_ispunct_0x62);
    suite_add_test(t_ispunct_0x63);
    suite_add_test(t_ispunct_0x64);
    suite_add_test(t_ispunct_0x65);
    suite_add_test(t_ispunct_0x66);
    suite_add_test(t_ispunct_0x67);
    suite_add_test(t_ispunct_0x68);
    suite_add_test(t_ispunct_0x69);
    suite_add_test(t_ispunct_0x6a);
    suite_add_test(t_ispunct_0x6b);
    suite_add_test(t_ispunct_0x6c);
    suite_add_test(t_ispunct_0x6d);
    suite_add_test(t_ispunct_0x6e);
    suite_add_test(t_ispunct_0x6f);
    suite_add_test(t_ispunct_0x70);
    suite_add_test(t_ispunct_0x71);
    suite_add_test(t_ispunct_0x72);
    suite_add_test(t_ispunct_0x73);
    suite_add_test(t_ispunct_0x74);
    suite_add_test(t_ispunct_0x75);
    suite_add_test(t_ispunct_0x76);
    suite_add_test(t_ispunct_0x77);
    suite_add_test(t_ispunct_0x78);
    suite_add_test(t_ispunct_0x79);
    suite_add_test(t_ispunct_0x7a);
    suite_add_test(t_ispunct_0x7b);
    suite_add_test(t_ispunct_0x7c);
    suite_add_test(t_ispunct_0x7d);
    suite_add_test(t_ispunct_0x7e);
    suite_add_test(t_ispunct_0x7f);
    suite_add_test(t_ispunct_0x80);
    suite_add_test(t_ispunct_0x81);
    suite_add_test(t_ispunct_0x82);
    suite_add_test(t_ispunct_0x83);
    suite_add_test(t_ispunct_0x84);
    suite_add_test(t_ispunct_0x85);
    suite_add_test(t_ispunct_0x86);
    suite_add_test(t_ispunct_0x87);
    suite_add_test(t_ispunct_0x88);
    suite_add_test(t_ispunct_0x89);
    suite_add_test(t_ispunct_0x8a);
    suite_add_test(t_ispunct_0x8b);
    suite_add_test(t_ispunct_0x8c);
    suite_add_test(t_ispunct_0x8d);
    suite_add_test(t_ispunct_0x8e);
    suite_add_test(t_ispunct_0x8f);
    suite_add_test(t_ispunct_0x90);
    suite_add_test(t_ispunct_0x91);
    suite_add_test(t_ispunct_0x92);
    suite_add_test(t_ispunct_0x93);
    suite_add_test(t_ispunct_0x94);
    suite_add_test(t_ispunct_0x95);
    suite_add_test(t_ispunct_0x96);
    suite_add_test(t_ispunct_0x97);
    suite_add_test(t_ispunct_0x98);
    suite_add_test(t_ispunct_0x99);
    suite_add_test(t_ispunct_0x9a);
    suite_add_test(t_ispunct_0x9b);
    suite_add_test(t_ispunct_0x9c);
    suite_add_test(t_ispunct_0x9d);
    suite_add_test(t_ispunct_0x9e);
    suite_add_test(t_ispunct_0x9f);
    suite_add_test(t_ispunct_0xa0);
    suite_add_test(t_ispunct_0xa1);
    suite_add_test(t_ispunct_0xa2);
    suite_add_test(t_ispunct_0xa3);
    suite_add_test(t_ispunct_0xa4);
    suite_add_test(t_ispunct_0xa5);
    suite_add_test(t_ispunct_0xa6);
    suite_add_test(t_ispunct_0xa7);
    suite_add_test(t_ispunct_0xa8);
    suite_add_test(t_ispunct_0xa9);
    suite_add_test(t_ispunct_0xaa);
    suite_add_test(t_ispunct_0xab);
    suite_add_test(t_ispunct_0xac);
    suite_add_test(t_ispunct_0xad);
    suite_add_test(t_ispunct_0xae);
    suite_add_test(t_ispunct_0xaf);
    suite_add_test(t_ispunct_0xb0);
    suite_add_test(t_ispunct_0xb1);
    suite_add_test(t_ispunct_0xb2);
    suite_add_test(t_ispunct_0xb3);
    suite_add_test(t_ispunct_0xb4);
    suite_add_test(t_ispunct_0xb5);
    suite_add_test(t_ispunct_0xb6);
    suite_add_test(t_ispunct_0xb7);
    suite_add_test(t_ispunct_0xb8);
    suite_add_test(t_ispunct_0xb9);
    suite_add_test(t_ispunct_0xba);
    suite_add_test(t_ispunct_0xbb);
    suite_add_test(t_ispunct_0xbc);
    suite_add_test(t_ispunct_0xbd);
    suite_add_test(t_ispunct_0xbe);
    suite_add_test(t_ispunct_0xbf);
    suite_add_test(t_ispunct_0xc0);
    suite_add_test(t_ispunct_0xc1);
    suite_add_test(t_ispunct_0xc2);
    suite_add_test(t_ispunct_0xc3);
    suite_add_test(t_ispunct_0xc4);
    suite_add_test(t_ispunct_0xc5);
    suite_add_test(t_ispunct_0xc6);
    suite_add_test(t_ispunct_0xc7);
    suite_add_test(t_ispunct_0xc8);
    suite_add_test(t_ispunct_0xc9);
    suite_add_test(t_ispunct_0xca);
    suite_add_test(t_ispunct_0xcb);
    suite_add_test(t_ispunct_0xcc);
    suite_add_test(t_ispunct_0xcd);
    suite_add_test(t_ispunct_0xce);
    suite_add_test(t_ispunct_0xcf);
    suite_add_test(t_ispunct_0xd0);
    suite_add_test(t_ispunct_0xd1);
    suite_add_test(t_ispunct_0xd2);
    suite_add_test(t_ispunct_0xd3);
    suite_add_test(t_ispunct_0xd4);
    suite_add_test(t_ispunct_0xd5);
    suite_add_test(t_ispunct_0xd6);
    suite_add_test(t_ispunct_0xd7);
    suite_add_test(t_ispunct_0xd8);
    suite_add_test(t_ispunct_0xd9);
    suite_add_test(t_ispunct_0xda);
    suite_add_test(t_ispunct_0xdb);
    suite_add_test(t_ispunct_0xdc);
    suite_add_test(t_ispunct_0xdd);
    suite_add_test(t_ispunct_0xde);
    suite_add_test(t_ispunct_0xdf);
    suite_add_test(t_ispunct_0xe0);
    suite_add_test(t_ispunct_0xe1);
    suite_add_test(t_ispunct_0xe2);
    suite_add_test(t_ispunct_0xe3);
    suite_add_test(t_ispunct_0xe4);
    suite_add_test(t_ispunct_0xe5);
    suite_add_test(t_ispunct_0xe6);
    suite_add_test(t_ispunct_0xe7);
    suite_add_test(t_ispunct_0xe8);
    suite_add_test(t_ispunct_0xe9);
    suite_add_test(t_ispunct_0xea);
    suite_add_test(t_ispunct_0xeb);
    suite_add_test(t_ispunct_0xec);
    suite_add_test(t_ispunct_0xed);
    suite_add_test(t_ispunct_0xee);
    suite_add_test(t_ispunct_0xef);
    suite_add_test(t_ispunct_0xf0);
    suite_add_test(t_ispunct_0xf1);
    suite_add_test(t_ispunct_0xf2);
    suite_add_test(t_ispunct_0xf3);
    suite_add_test(t_ispunct_0xf4);
    suite_add_test(t_ispunct_0xf5);
    suite_add_test(t_ispunct_0xf6);
    suite_add_test(t_ispunct_0xf7);
    suite_add_test(t_ispunct_0xf8);
    suite_add_test(t_ispunct_0xf9);
    suite_add_test(t_ispunct_0xfa);
    suite_add_test(t_ispunct_0xfb);
    suite_add_test(t_ispunct_0xfc);
    suite_add_test(t_ispunct_0xfd);
    suite_add_test(t_ispunct_0xfe);
    suite_add_test(t_ispunct_0xff);
     return suite_run();
}
