
#include "ctype_test.h"
void t_isspace_0x00()
{
    Assert(isspace(0)  == 0 ,"isspace should be 0 for 0x00");
}

void t_isspace_0x01()
{
    Assert(isspace(1)  == 0 ,"isspace should be 0 for 0x01");
}

void t_isspace_0x02()
{
    Assert(isspace(2)  == 0 ,"isspace should be 0 for 0x02");
}

void t_isspace_0x03()
{
    Assert(isspace(3)  == 0 ,"isspace should be 0 for 0x03");
}

void t_isspace_0x04()
{
    Assert(isspace(4)  == 0 ,"isspace should be 0 for 0x04");
}

void t_isspace_0x05()
{
    Assert(isspace(5)  == 0 ,"isspace should be 0 for 0x05");
}

void t_isspace_0x06()
{
    Assert(isspace(6)  == 0 ,"isspace should be 0 for 0x06");
}

void t_isspace_0x07()
{
    Assert(isspace(7)  == 0 ,"isspace should be 0 for 0x07");
}

void t_isspace_0x08()
{
    Assert(isspace(8)  == 0 ,"isspace should be 0 for 0x08");
}

void t_isspace_0x09()
{
    Assert(isspace(9) ,"isspace should be 1 for 0x09");
}

void t_isspace_0x0a()
{
    Assert(isspace(10) ,"isspace should be 1 for 0x0a");
}

void t_isspace_0x0b()
{
    Assert(isspace(11) ,"isspace should be 1 for 0x0b");
}

void t_isspace_0x0c()
{
    Assert(isspace(12) ,"isspace should be 1 for 0x0c");
}

void t_isspace_0x0d()
{
    Assert(isspace(13) ,"isspace should be 1 for 0x0d");
}

void t_isspace_0x0e()
{
    Assert(isspace(14)  == 0 ,"isspace should be 0 for 0x0e");
}

void t_isspace_0x0f()
{
    Assert(isspace(15)  == 0 ,"isspace should be 0 for 0x0f");
}

void t_isspace_0x10()
{
    Assert(isspace(16)  == 0 ,"isspace should be 0 for 0x10");
}

void t_isspace_0x11()
{
    Assert(isspace(17)  == 0 ,"isspace should be 0 for 0x11");
}

void t_isspace_0x12()
{
    Assert(isspace(18)  == 0 ,"isspace should be 0 for 0x12");
}

void t_isspace_0x13()
{
    Assert(isspace(19)  == 0 ,"isspace should be 0 for 0x13");
}

void t_isspace_0x14()
{
    Assert(isspace(20)  == 0 ,"isspace should be 0 for 0x14");
}

void t_isspace_0x15()
{
    Assert(isspace(21)  == 0 ,"isspace should be 0 for 0x15");
}

void t_isspace_0x16()
{
    Assert(isspace(22)  == 0 ,"isspace should be 0 for 0x16");
}

void t_isspace_0x17()
{
    Assert(isspace(23)  == 0 ,"isspace should be 0 for 0x17");
}

void t_isspace_0x18()
{
    Assert(isspace(24)  == 0 ,"isspace should be 0 for 0x18");
}

void t_isspace_0x19()
{
    Assert(isspace(25)  == 0 ,"isspace should be 0 for 0x19");
}

void t_isspace_0x1a()
{
    Assert(isspace(26)  == 0 ,"isspace should be 0 for 0x1a");
}

void t_isspace_0x1b()
{
    Assert(isspace(27)  == 0 ,"isspace should be 0 for 0x1b");
}

void t_isspace_0x1c()
{
    Assert(isspace(28)  == 0 ,"isspace should be 0 for 0x1c");
}

void t_isspace_0x1d()
{
    Assert(isspace(29)  == 0 ,"isspace should be 0 for 0x1d");
}

void t_isspace_0x1e()
{
    Assert(isspace(30)  == 0 ,"isspace should be 0 for 0x1e");
}

void t_isspace_0x1f()
{
    Assert(isspace(31)  == 0 ,"isspace should be 0 for 0x1f");
}

void t_isspace_0x20()
{
    Assert(isspace(32) ,"isspace should be 1 for  ");
}

void t_isspace_0x21()
{
    Assert(isspace(33)  == 0 ,"isspace should be 0 for !");
}

void t_isspace_0x22()
{
    Assert(isspace(34)  == 0 ,"isspace should be 0 for 0x22");
}

void t_isspace_0x23()
{
    Assert(isspace(35)  == 0 ,"isspace should be 0 for #");
}

void t_isspace_0x24()
{
    Assert(isspace(36)  == 0 ,"isspace should be 0 for $");
}

void t_isspace_0x25()
{
    Assert(isspace(37)  == 0 ,"isspace should be 0 for %");
}

void t_isspace_0x26()
{
    Assert(isspace(38)  == 0 ,"isspace should be 0 for &");
}

void t_isspace_0x27()
{
    Assert(isspace(39)  == 0 ,"isspace should be 0 for '");
}

void t_isspace_0x28()
{
    Assert(isspace(40)  == 0 ,"isspace should be 0 for (");
}

void t_isspace_0x29()
{
    Assert(isspace(41)  == 0 ,"isspace should be 0 for )");
}

void t_isspace_0x2a()
{
    Assert(isspace(42)  == 0 ,"isspace should be 0 for *");
}

void t_isspace_0x2b()
{
    Assert(isspace(43)  == 0 ,"isspace should be 0 for +");
}

void t_isspace_0x2c()
{
    Assert(isspace(44)  == 0 ,"isspace should be 0 for ,");
}

void t_isspace_0x2d()
{
    Assert(isspace(45)  == 0 ,"isspace should be 0 for -");
}

void t_isspace_0x2e()
{
    Assert(isspace(46)  == 0 ,"isspace should be 0 for .");
}

void t_isspace_0x2f()
{
    Assert(isspace(47)  == 0 ,"isspace should be 0 for /");
}

void t_isspace_0x30()
{
    Assert(isspace(48)  == 0 ,"isspace should be 0 for 0");
}

void t_isspace_0x31()
{
    Assert(isspace(49)  == 0 ,"isspace should be 0 for 1");
}

void t_isspace_0x32()
{
    Assert(isspace(50)  == 0 ,"isspace should be 0 for 2");
}

void t_isspace_0x33()
{
    Assert(isspace(51)  == 0 ,"isspace should be 0 for 3");
}

void t_isspace_0x34()
{
    Assert(isspace(52)  == 0 ,"isspace should be 0 for 4");
}

void t_isspace_0x35()
{
    Assert(isspace(53)  == 0 ,"isspace should be 0 for 5");
}

void t_isspace_0x36()
{
    Assert(isspace(54)  == 0 ,"isspace should be 0 for 6");
}

void t_isspace_0x37()
{
    Assert(isspace(55)  == 0 ,"isspace should be 0 for 7");
}

void t_isspace_0x38()
{
    Assert(isspace(56)  == 0 ,"isspace should be 0 for 8");
}

void t_isspace_0x39()
{
    Assert(isspace(57)  == 0 ,"isspace should be 0 for 9");
}

void t_isspace_0x3a()
{
    Assert(isspace(58)  == 0 ,"isspace should be 0 for :");
}

void t_isspace_0x3b()
{
    Assert(isspace(59)  == 0 ,"isspace should be 0 for ;");
}

void t_isspace_0x3c()
{
    Assert(isspace(60)  == 0 ,"isspace should be 0 for <");
}

void t_isspace_0x3d()
{
    Assert(isspace(61)  == 0 ,"isspace should be 0 for =");
}

void t_isspace_0x3e()
{
    Assert(isspace(62)  == 0 ,"isspace should be 0 for >");
}

void t_isspace_0x3f()
{
    Assert(isspace(63)  == 0 ,"isspace should be 0 for ?");
}

void t_isspace_0x40()
{
    Assert(isspace(64)  == 0 ,"isspace should be 0 for @");
}

void t_isspace_0x41()
{
    Assert(isspace(65)  == 0 ,"isspace should be 0 for A");
}

void t_isspace_0x42()
{
    Assert(isspace(66)  == 0 ,"isspace should be 0 for B");
}

void t_isspace_0x43()
{
    Assert(isspace(67)  == 0 ,"isspace should be 0 for C");
}

void t_isspace_0x44()
{
    Assert(isspace(68)  == 0 ,"isspace should be 0 for D");
}

void t_isspace_0x45()
{
    Assert(isspace(69)  == 0 ,"isspace should be 0 for E");
}

void t_isspace_0x46()
{
    Assert(isspace(70)  == 0 ,"isspace should be 0 for F");
}

void t_isspace_0x47()
{
    Assert(isspace(71)  == 0 ,"isspace should be 0 for G");
}

void t_isspace_0x48()
{
    Assert(isspace(72)  == 0 ,"isspace should be 0 for H");
}

void t_isspace_0x49()
{
    Assert(isspace(73)  == 0 ,"isspace should be 0 for I");
}

void t_isspace_0x4a()
{
    Assert(isspace(74)  == 0 ,"isspace should be 0 for J");
}

void t_isspace_0x4b()
{
    Assert(isspace(75)  == 0 ,"isspace should be 0 for K");
}

void t_isspace_0x4c()
{
    Assert(isspace(76)  == 0 ,"isspace should be 0 for L");
}

void t_isspace_0x4d()
{
    Assert(isspace(77)  == 0 ,"isspace should be 0 for M");
}

void t_isspace_0x4e()
{
    Assert(isspace(78)  == 0 ,"isspace should be 0 for N");
}

void t_isspace_0x4f()
{
    Assert(isspace(79)  == 0 ,"isspace should be 0 for O");
}

void t_isspace_0x50()
{
    Assert(isspace(80)  == 0 ,"isspace should be 0 for P");
}

void t_isspace_0x51()
{
    Assert(isspace(81)  == 0 ,"isspace should be 0 for Q");
}

void t_isspace_0x52()
{
    Assert(isspace(82)  == 0 ,"isspace should be 0 for R");
}

void t_isspace_0x53()
{
    Assert(isspace(83)  == 0 ,"isspace should be 0 for S");
}

void t_isspace_0x54()
{
    Assert(isspace(84)  == 0 ,"isspace should be 0 for T");
}

void t_isspace_0x55()
{
    Assert(isspace(85)  == 0 ,"isspace should be 0 for U");
}

void t_isspace_0x56()
{
    Assert(isspace(86)  == 0 ,"isspace should be 0 for V");
}

void t_isspace_0x57()
{
    Assert(isspace(87)  == 0 ,"isspace should be 0 for W");
}

void t_isspace_0x58()
{
    Assert(isspace(88)  == 0 ,"isspace should be 0 for X");
}

void t_isspace_0x59()
{
    Assert(isspace(89)  == 0 ,"isspace should be 0 for Y");
}

void t_isspace_0x5a()
{
    Assert(isspace(90)  == 0 ,"isspace should be 0 for Z");
}

void t_isspace_0x5b()
{
    Assert(isspace(91)  == 0 ,"isspace should be 0 for [");
}

void t_isspace_0x5c()
{
    Assert(isspace(92)  == 0 ,"isspace should be 0 for 0x5c");
}

void t_isspace_0x5d()
{
    Assert(isspace(93)  == 0 ,"isspace should be 0 for ]");
}

void t_isspace_0x5e()
{
    Assert(isspace(94)  == 0 ,"isspace should be 0 for ^");
}

void t_isspace_0x5f()
{
    Assert(isspace(95)  == 0 ,"isspace should be 0 for _");
}

void t_isspace_0x60()
{
    Assert(isspace(96)  == 0 ,"isspace should be 0 for `");
}

void t_isspace_0x61()
{
    Assert(isspace(97)  == 0 ,"isspace should be 0 for a");
}

void t_isspace_0x62()
{
    Assert(isspace(98)  == 0 ,"isspace should be 0 for b");
}

void t_isspace_0x63()
{
    Assert(isspace(99)  == 0 ,"isspace should be 0 for c");
}

void t_isspace_0x64()
{
    Assert(isspace(100)  == 0 ,"isspace should be 0 for d");
}

void t_isspace_0x65()
{
    Assert(isspace(101)  == 0 ,"isspace should be 0 for e");
}

void t_isspace_0x66()
{
    Assert(isspace(102)  == 0 ,"isspace should be 0 for f");
}

void t_isspace_0x67()
{
    Assert(isspace(103)  == 0 ,"isspace should be 0 for g");
}

void t_isspace_0x68()
{
    Assert(isspace(104)  == 0 ,"isspace should be 0 for h");
}

void t_isspace_0x69()
{
    Assert(isspace(105)  == 0 ,"isspace should be 0 for i");
}

void t_isspace_0x6a()
{
    Assert(isspace(106)  == 0 ,"isspace should be 0 for j");
}

void t_isspace_0x6b()
{
    Assert(isspace(107)  == 0 ,"isspace should be 0 for k");
}

void t_isspace_0x6c()
{
    Assert(isspace(108)  == 0 ,"isspace should be 0 for l");
}

void t_isspace_0x6d()
{
    Assert(isspace(109)  == 0 ,"isspace should be 0 for m");
}

void t_isspace_0x6e()
{
    Assert(isspace(110)  == 0 ,"isspace should be 0 for n");
}

void t_isspace_0x6f()
{
    Assert(isspace(111)  == 0 ,"isspace should be 0 for o");
}

void t_isspace_0x70()
{
    Assert(isspace(112)  == 0 ,"isspace should be 0 for p");
}

void t_isspace_0x71()
{
    Assert(isspace(113)  == 0 ,"isspace should be 0 for q");
}

void t_isspace_0x72()
{
    Assert(isspace(114)  == 0 ,"isspace should be 0 for r");
}

void t_isspace_0x73()
{
    Assert(isspace(115)  == 0 ,"isspace should be 0 for s");
}

void t_isspace_0x74()
{
    Assert(isspace(116)  == 0 ,"isspace should be 0 for t");
}

void t_isspace_0x75()
{
    Assert(isspace(117)  == 0 ,"isspace should be 0 for u");
}

void t_isspace_0x76()
{
    Assert(isspace(118)  == 0 ,"isspace should be 0 for v");
}

void t_isspace_0x77()
{
    Assert(isspace(119)  == 0 ,"isspace should be 0 for w");
}

void t_isspace_0x78()
{
    Assert(isspace(120)  == 0 ,"isspace should be 0 for x");
}

void t_isspace_0x79()
{
    Assert(isspace(121)  == 0 ,"isspace should be 0 for y");
}

void t_isspace_0x7a()
{
    Assert(isspace(122)  == 0 ,"isspace should be 0 for z");
}

void t_isspace_0x7b()
{
    Assert(isspace(123)  == 0 ,"isspace should be 0 for {");
}

void t_isspace_0x7c()
{
    Assert(isspace(124)  == 0 ,"isspace should be 0 for |");
}

void t_isspace_0x7d()
{
    Assert(isspace(125)  == 0 ,"isspace should be 0 for }");
}

void t_isspace_0x7e()
{
    Assert(isspace(126)  == 0 ,"isspace should be 0 for ~");
}

void t_isspace_0x7f()
{
    Assert(isspace(127)  == 0 ,"isspace should be 0 for 0x7f");
}

void t_isspace_0x80()
{
    Assert(isspace(128)  == 0 ,"isspace should be 0 for 0x80");
}

void t_isspace_0x81()
{
    Assert(isspace(129)  == 0 ,"isspace should be 0 for 0x81");
}

void t_isspace_0x82()
{
    Assert(isspace(130)  == 0 ,"isspace should be 0 for 0x82");
}

void t_isspace_0x83()
{
    Assert(isspace(131)  == 0 ,"isspace should be 0 for 0x83");
}

void t_isspace_0x84()
{
    Assert(isspace(132)  == 0 ,"isspace should be 0 for 0x84");
}

void t_isspace_0x85()
{
    Assert(isspace(133)  == 0 ,"isspace should be 0 for 0x85");
}

void t_isspace_0x86()
{
    Assert(isspace(134)  == 0 ,"isspace should be 0 for 0x86");
}

void t_isspace_0x87()
{
    Assert(isspace(135)  == 0 ,"isspace should be 0 for 0x87");
}

void t_isspace_0x88()
{
    Assert(isspace(136)  == 0 ,"isspace should be 0 for 0x88");
}

void t_isspace_0x89()
{
    Assert(isspace(137)  == 0 ,"isspace should be 0 for 0x89");
}

void t_isspace_0x8a()
{
    Assert(isspace(138)  == 0 ,"isspace should be 0 for 0x8a");
}

void t_isspace_0x8b()
{
    Assert(isspace(139)  == 0 ,"isspace should be 0 for 0x8b");
}

void t_isspace_0x8c()
{
    Assert(isspace(140)  == 0 ,"isspace should be 0 for 0x8c");
}

void t_isspace_0x8d()
{
    Assert(isspace(141)  == 0 ,"isspace should be 0 for 0x8d");
}

void t_isspace_0x8e()
{
    Assert(isspace(142)  == 0 ,"isspace should be 0 for 0x8e");
}

void t_isspace_0x8f()
{
    Assert(isspace(143)  == 0 ,"isspace should be 0 for 0x8f");
}

void t_isspace_0x90()
{
    Assert(isspace(144)  == 0 ,"isspace should be 0 for 0x90");
}

void t_isspace_0x91()
{
    Assert(isspace(145)  == 0 ,"isspace should be 0 for 0x91");
}

void t_isspace_0x92()
{
    Assert(isspace(146)  == 0 ,"isspace should be 0 for 0x92");
}

void t_isspace_0x93()
{
    Assert(isspace(147)  == 0 ,"isspace should be 0 for 0x93");
}

void t_isspace_0x94()
{
    Assert(isspace(148)  == 0 ,"isspace should be 0 for 0x94");
}

void t_isspace_0x95()
{
    Assert(isspace(149)  == 0 ,"isspace should be 0 for 0x95");
}

void t_isspace_0x96()
{
    Assert(isspace(150)  == 0 ,"isspace should be 0 for 0x96");
}

void t_isspace_0x97()
{
    Assert(isspace(151)  == 0 ,"isspace should be 0 for 0x97");
}

void t_isspace_0x98()
{
    Assert(isspace(152)  == 0 ,"isspace should be 0 for 0x98");
}

void t_isspace_0x99()
{
    Assert(isspace(153)  == 0 ,"isspace should be 0 for 0x99");
}

void t_isspace_0x9a()
{
    Assert(isspace(154)  == 0 ,"isspace should be 0 for 0x9a");
}

void t_isspace_0x9b()
{
    Assert(isspace(155)  == 0 ,"isspace should be 0 for 0x9b");
}

void t_isspace_0x9c()
{
    Assert(isspace(156)  == 0 ,"isspace should be 0 for 0x9c");
}

void t_isspace_0x9d()
{
    Assert(isspace(157)  == 0 ,"isspace should be 0 for 0x9d");
}

void t_isspace_0x9e()
{
    Assert(isspace(158)  == 0 ,"isspace should be 0 for 0x9e");
}

void t_isspace_0x9f()
{
    Assert(isspace(159)  == 0 ,"isspace should be 0 for 0x9f");
}

void t_isspace_0xa0()
{
    Assert(isspace(160)  == 0 ,"isspace should be 0 for 0xa0");
}

void t_isspace_0xa1()
{
    Assert(isspace(161)  == 0 ,"isspace should be 0 for 0xa1");
}

void t_isspace_0xa2()
{
    Assert(isspace(162)  == 0 ,"isspace should be 0 for 0xa2");
}

void t_isspace_0xa3()
{
    Assert(isspace(163)  == 0 ,"isspace should be 0 for 0xa3");
}

void t_isspace_0xa4()
{
    Assert(isspace(164)  == 0 ,"isspace should be 0 for 0xa4");
}

void t_isspace_0xa5()
{
    Assert(isspace(165)  == 0 ,"isspace should be 0 for 0xa5");
}

void t_isspace_0xa6()
{
    Assert(isspace(166)  == 0 ,"isspace should be 0 for 0xa6");
}

void t_isspace_0xa7()
{
    Assert(isspace(167)  == 0 ,"isspace should be 0 for 0xa7");
}

void t_isspace_0xa8()
{
    Assert(isspace(168)  == 0 ,"isspace should be 0 for 0xa8");
}

void t_isspace_0xa9()
{
    Assert(isspace(169)  == 0 ,"isspace should be 0 for 0xa9");
}

void t_isspace_0xaa()
{
    Assert(isspace(170)  == 0 ,"isspace should be 0 for 0xaa");
}

void t_isspace_0xab()
{
    Assert(isspace(171)  == 0 ,"isspace should be 0 for 0xab");
}

void t_isspace_0xac()
{
    Assert(isspace(172)  == 0 ,"isspace should be 0 for 0xac");
}

void t_isspace_0xad()
{
    Assert(isspace(173)  == 0 ,"isspace should be 0 for 0xad");
}

void t_isspace_0xae()
{
    Assert(isspace(174)  == 0 ,"isspace should be 0 for 0xae");
}

void t_isspace_0xaf()
{
    Assert(isspace(175)  == 0 ,"isspace should be 0 for 0xaf");
}

void t_isspace_0xb0()
{
    Assert(isspace(176)  == 0 ,"isspace should be 0 for 0xb0");
}

void t_isspace_0xb1()
{
    Assert(isspace(177)  == 0 ,"isspace should be 0 for 0xb1");
}

void t_isspace_0xb2()
{
    Assert(isspace(178)  == 0 ,"isspace should be 0 for 0xb2");
}

void t_isspace_0xb3()
{
    Assert(isspace(179)  == 0 ,"isspace should be 0 for 0xb3");
}

void t_isspace_0xb4()
{
    Assert(isspace(180)  == 0 ,"isspace should be 0 for 0xb4");
}

void t_isspace_0xb5()
{
    Assert(isspace(181)  == 0 ,"isspace should be 0 for 0xb5");
}

void t_isspace_0xb6()
{
    Assert(isspace(182)  == 0 ,"isspace should be 0 for 0xb6");
}

void t_isspace_0xb7()
{
    Assert(isspace(183)  == 0 ,"isspace should be 0 for 0xb7");
}

void t_isspace_0xb8()
{
    Assert(isspace(184)  == 0 ,"isspace should be 0 for 0xb8");
}

void t_isspace_0xb9()
{
    Assert(isspace(185)  == 0 ,"isspace should be 0 for 0xb9");
}

void t_isspace_0xba()
{
    Assert(isspace(186)  == 0 ,"isspace should be 0 for 0xba");
}

void t_isspace_0xbb()
{
    Assert(isspace(187)  == 0 ,"isspace should be 0 for 0xbb");
}

void t_isspace_0xbc()
{
    Assert(isspace(188)  == 0 ,"isspace should be 0 for 0xbc");
}

void t_isspace_0xbd()
{
    Assert(isspace(189)  == 0 ,"isspace should be 0 for 0xbd");
}

void t_isspace_0xbe()
{
    Assert(isspace(190)  == 0 ,"isspace should be 0 for 0xbe");
}

void t_isspace_0xbf()
{
    Assert(isspace(191)  == 0 ,"isspace should be 0 for 0xbf");
}

void t_isspace_0xc0()
{
    Assert(isspace(192)  == 0 ,"isspace should be 0 for 0xc0");
}

void t_isspace_0xc1()
{
    Assert(isspace(193)  == 0 ,"isspace should be 0 for 0xc1");
}

void t_isspace_0xc2()
{
    Assert(isspace(194)  == 0 ,"isspace should be 0 for 0xc2");
}

void t_isspace_0xc3()
{
    Assert(isspace(195)  == 0 ,"isspace should be 0 for 0xc3");
}

void t_isspace_0xc4()
{
    Assert(isspace(196)  == 0 ,"isspace should be 0 for 0xc4");
}

void t_isspace_0xc5()
{
    Assert(isspace(197)  == 0 ,"isspace should be 0 for 0xc5");
}

void t_isspace_0xc6()
{
    Assert(isspace(198)  == 0 ,"isspace should be 0 for 0xc6");
}

void t_isspace_0xc7()
{
    Assert(isspace(199)  == 0 ,"isspace should be 0 for 0xc7");
}

void t_isspace_0xc8()
{
    Assert(isspace(200)  == 0 ,"isspace should be 0 for 0xc8");
}

void t_isspace_0xc9()
{
    Assert(isspace(201)  == 0 ,"isspace should be 0 for 0xc9");
}

void t_isspace_0xca()
{
    Assert(isspace(202)  == 0 ,"isspace should be 0 for 0xca");
}

void t_isspace_0xcb()
{
    Assert(isspace(203)  == 0 ,"isspace should be 0 for 0xcb");
}

void t_isspace_0xcc()
{
    Assert(isspace(204)  == 0 ,"isspace should be 0 for 0xcc");
}

void t_isspace_0xcd()
{
    Assert(isspace(205)  == 0 ,"isspace should be 0 for 0xcd");
}

void t_isspace_0xce()
{
    Assert(isspace(206)  == 0 ,"isspace should be 0 for 0xce");
}

void t_isspace_0xcf()
{
    Assert(isspace(207)  == 0 ,"isspace should be 0 for 0xcf");
}

void t_isspace_0xd0()
{
    Assert(isspace(208)  == 0 ,"isspace should be 0 for 0xd0");
}

void t_isspace_0xd1()
{
    Assert(isspace(209)  == 0 ,"isspace should be 0 for 0xd1");
}

void t_isspace_0xd2()
{
    Assert(isspace(210)  == 0 ,"isspace should be 0 for 0xd2");
}

void t_isspace_0xd3()
{
    Assert(isspace(211)  == 0 ,"isspace should be 0 for 0xd3");
}

void t_isspace_0xd4()
{
    Assert(isspace(212)  == 0 ,"isspace should be 0 for 0xd4");
}

void t_isspace_0xd5()
{
    Assert(isspace(213)  == 0 ,"isspace should be 0 for 0xd5");
}

void t_isspace_0xd6()
{
    Assert(isspace(214)  == 0 ,"isspace should be 0 for 0xd6");
}

void t_isspace_0xd7()
{
    Assert(isspace(215)  == 0 ,"isspace should be 0 for 0xd7");
}

void t_isspace_0xd8()
{
    Assert(isspace(216)  == 0 ,"isspace should be 0 for 0xd8");
}

void t_isspace_0xd9()
{
    Assert(isspace(217)  == 0 ,"isspace should be 0 for 0xd9");
}

void t_isspace_0xda()
{
    Assert(isspace(218)  == 0 ,"isspace should be 0 for 0xda");
}

void t_isspace_0xdb()
{
    Assert(isspace(219)  == 0 ,"isspace should be 0 for 0xdb");
}

void t_isspace_0xdc()
{
    Assert(isspace(220)  == 0 ,"isspace should be 0 for 0xdc");
}

void t_isspace_0xdd()
{
    Assert(isspace(221)  == 0 ,"isspace should be 0 for 0xdd");
}

void t_isspace_0xde()
{
    Assert(isspace(222)  == 0 ,"isspace should be 0 for 0xde");
}

void t_isspace_0xdf()
{
    Assert(isspace(223)  == 0 ,"isspace should be 0 for 0xdf");
}

void t_isspace_0xe0()
{
    Assert(isspace(224)  == 0 ,"isspace should be 0 for 0xe0");
}

void t_isspace_0xe1()
{
    Assert(isspace(225)  == 0 ,"isspace should be 0 for 0xe1");
}

void t_isspace_0xe2()
{
    Assert(isspace(226)  == 0 ,"isspace should be 0 for 0xe2");
}

void t_isspace_0xe3()
{
    Assert(isspace(227)  == 0 ,"isspace should be 0 for 0xe3");
}

void t_isspace_0xe4()
{
    Assert(isspace(228)  == 0 ,"isspace should be 0 for 0xe4");
}

void t_isspace_0xe5()
{
    Assert(isspace(229)  == 0 ,"isspace should be 0 for 0xe5");
}

void t_isspace_0xe6()
{
    Assert(isspace(230)  == 0 ,"isspace should be 0 for 0xe6");
}

void t_isspace_0xe7()
{
    Assert(isspace(231)  == 0 ,"isspace should be 0 for 0xe7");
}

void t_isspace_0xe8()
{
    Assert(isspace(232)  == 0 ,"isspace should be 0 for 0xe8");
}

void t_isspace_0xe9()
{
    Assert(isspace(233)  == 0 ,"isspace should be 0 for 0xe9");
}

void t_isspace_0xea()
{
    Assert(isspace(234)  == 0 ,"isspace should be 0 for 0xea");
}

void t_isspace_0xeb()
{
    Assert(isspace(235)  == 0 ,"isspace should be 0 for 0xeb");
}

void t_isspace_0xec()
{
    Assert(isspace(236)  == 0 ,"isspace should be 0 for 0xec");
}

void t_isspace_0xed()
{
    Assert(isspace(237)  == 0 ,"isspace should be 0 for 0xed");
}

void t_isspace_0xee()
{
    Assert(isspace(238)  == 0 ,"isspace should be 0 for 0xee");
}

void t_isspace_0xef()
{
    Assert(isspace(239)  == 0 ,"isspace should be 0 for 0xef");
}

void t_isspace_0xf0()
{
    Assert(isspace(240)  == 0 ,"isspace should be 0 for 0xf0");
}

void t_isspace_0xf1()
{
    Assert(isspace(241)  == 0 ,"isspace should be 0 for 0xf1");
}

void t_isspace_0xf2()
{
    Assert(isspace(242)  == 0 ,"isspace should be 0 for 0xf2");
}

void t_isspace_0xf3()
{
    Assert(isspace(243)  == 0 ,"isspace should be 0 for 0xf3");
}

void t_isspace_0xf4()
{
    Assert(isspace(244)  == 0 ,"isspace should be 0 for 0xf4");
}

void t_isspace_0xf5()
{
    Assert(isspace(245)  == 0 ,"isspace should be 0 for 0xf5");
}

void t_isspace_0xf6()
{
    Assert(isspace(246)  == 0 ,"isspace should be 0 for 0xf6");
}

void t_isspace_0xf7()
{
    Assert(isspace(247)  == 0 ,"isspace should be 0 for 0xf7");
}

void t_isspace_0xf8()
{
    Assert(isspace(248)  == 0 ,"isspace should be 0 for 0xf8");
}

void t_isspace_0xf9()
{
    Assert(isspace(249)  == 0 ,"isspace should be 0 for 0xf9");
}

void t_isspace_0xfa()
{
    Assert(isspace(250)  == 0 ,"isspace should be 0 for 0xfa");
}

void t_isspace_0xfb()
{
    Assert(isspace(251)  == 0 ,"isspace should be 0 for 0xfb");
}

void t_isspace_0xfc()
{
    Assert(isspace(252)  == 0 ,"isspace should be 0 for 0xfc");
}

void t_isspace_0xfd()
{
    Assert(isspace(253)  == 0 ,"isspace should be 0 for 0xfd");
}

void t_isspace_0xfe()
{
    Assert(isspace(254)  == 0 ,"isspace should be 0 for 0xfe");
}

void t_isspace_0xff()
{
    Assert(isspace(255)  == 0 ,"isspace should be 0 for 0xff");
}



int test_isspace()
{
    suite_setup("isspace");
    suite_add_test(t_isspace_0x00);
    suite_add_test(t_isspace_0x01);
    suite_add_test(t_isspace_0x02);
    suite_add_test(t_isspace_0x03);
    suite_add_test(t_isspace_0x04);
    suite_add_test(t_isspace_0x05);
    suite_add_test(t_isspace_0x06);
    suite_add_test(t_isspace_0x07);
    suite_add_test(t_isspace_0x08);
    suite_add_test(t_isspace_0x09);
    suite_add_test(t_isspace_0x0a);
    suite_add_test(t_isspace_0x0b);
    suite_add_test(t_isspace_0x0c);
    suite_add_test(t_isspace_0x0d);
    suite_add_test(t_isspace_0x0e);
    suite_add_test(t_isspace_0x0f);
    suite_add_test(t_isspace_0x10);
    suite_add_test(t_isspace_0x11);
    suite_add_test(t_isspace_0x12);
    suite_add_test(t_isspace_0x13);
    suite_add_test(t_isspace_0x14);
    suite_add_test(t_isspace_0x15);
    suite_add_test(t_isspace_0x16);
    suite_add_test(t_isspace_0x17);
    suite_add_test(t_isspace_0x18);
    suite_add_test(t_isspace_0x19);
    suite_add_test(t_isspace_0x1a);
    suite_add_test(t_isspace_0x1b);
    suite_add_test(t_isspace_0x1c);
    suite_add_test(t_isspace_0x1d);
    suite_add_test(t_isspace_0x1e);
    suite_add_test(t_isspace_0x1f);
    suite_add_test(t_isspace_0x20);
    suite_add_test(t_isspace_0x21);
    suite_add_test(t_isspace_0x22);
    suite_add_test(t_isspace_0x23);
    suite_add_test(t_isspace_0x24);
    suite_add_test(t_isspace_0x25);
    suite_add_test(t_isspace_0x26);
    suite_add_test(t_isspace_0x27);
    suite_add_test(t_isspace_0x28);
    suite_add_test(t_isspace_0x29);
    suite_add_test(t_isspace_0x2a);
    suite_add_test(t_isspace_0x2b);
    suite_add_test(t_isspace_0x2c);
    suite_add_test(t_isspace_0x2d);
    suite_add_test(t_isspace_0x2e);
    suite_add_test(t_isspace_0x2f);
    suite_add_test(t_isspace_0x30);
    suite_add_test(t_isspace_0x31);
    suite_add_test(t_isspace_0x32);
    suite_add_test(t_isspace_0x33);
    suite_add_test(t_isspace_0x34);
    suite_add_test(t_isspace_0x35);
    suite_add_test(t_isspace_0x36);
    suite_add_test(t_isspace_0x37);
    suite_add_test(t_isspace_0x38);
    suite_add_test(t_isspace_0x39);
    suite_add_test(t_isspace_0x3a);
    suite_add_test(t_isspace_0x3b);
    suite_add_test(t_isspace_0x3c);
    suite_add_test(t_isspace_0x3d);
    suite_add_test(t_isspace_0x3e);
    suite_add_test(t_isspace_0x3f);
    suite_add_test(t_isspace_0x40);
    suite_add_test(t_isspace_0x41);
    suite_add_test(t_isspace_0x42);
    suite_add_test(t_isspace_0x43);
    suite_add_test(t_isspace_0x44);
    suite_add_test(t_isspace_0x45);
    suite_add_test(t_isspace_0x46);
    suite_add_test(t_isspace_0x47);
    suite_add_test(t_isspace_0x48);
    suite_add_test(t_isspace_0x49);
    suite_add_test(t_isspace_0x4a);
    suite_add_test(t_isspace_0x4b);
    suite_add_test(t_isspace_0x4c);
    suite_add_test(t_isspace_0x4d);
    suite_add_test(t_isspace_0x4e);
    suite_add_test(t_isspace_0x4f);
    suite_add_test(t_isspace_0x50);
    suite_add_test(t_isspace_0x51);
    suite_add_test(t_isspace_0x52);
    suite_add_test(t_isspace_0x53);
    suite_add_test(t_isspace_0x54);
    suite_add_test(t_isspace_0x55);
    suite_add_test(t_isspace_0x56);
    suite_add_test(t_isspace_0x57);
    suite_add_test(t_isspace_0x58);
    suite_add_test(t_isspace_0x59);
    suite_add_test(t_isspace_0x5a);
    suite_add_test(t_isspace_0x5b);
    suite_add_test(t_isspace_0x5c);
    suite_add_test(t_isspace_0x5d);
    suite_add_test(t_isspace_0x5e);
    suite_add_test(t_isspace_0x5f);
    suite_add_test(t_isspace_0x60);
    suite_add_test(t_isspace_0x61);
    suite_add_test(t_isspace_0x62);
    suite_add_test(t_isspace_0x63);
    suite_add_test(t_isspace_0x64);
    suite_add_test(t_isspace_0x65);
    suite_add_test(t_isspace_0x66);
    suite_add_test(t_isspace_0x67);
    suite_add_test(t_isspace_0x68);
    suite_add_test(t_isspace_0x69);
    suite_add_test(t_isspace_0x6a);
    suite_add_test(t_isspace_0x6b);
    suite_add_test(t_isspace_0x6c);
    suite_add_test(t_isspace_0x6d);
    suite_add_test(t_isspace_0x6e);
    suite_add_test(t_isspace_0x6f);
    suite_add_test(t_isspace_0x70);
    suite_add_test(t_isspace_0x71);
    suite_add_test(t_isspace_0x72);
    suite_add_test(t_isspace_0x73);
    suite_add_test(t_isspace_0x74);
    suite_add_test(t_isspace_0x75);
    suite_add_test(t_isspace_0x76);
    suite_add_test(t_isspace_0x77);
    suite_add_test(t_isspace_0x78);
    suite_add_test(t_isspace_0x79);
    suite_add_test(t_isspace_0x7a);
    suite_add_test(t_isspace_0x7b);
    suite_add_test(t_isspace_0x7c);
    suite_add_test(t_isspace_0x7d);
    suite_add_test(t_isspace_0x7e);
    suite_add_test(t_isspace_0x7f);
    suite_add_test(t_isspace_0x80);
    suite_add_test(t_isspace_0x81);
    suite_add_test(t_isspace_0x82);
    suite_add_test(t_isspace_0x83);
    suite_add_test(t_isspace_0x84);
    suite_add_test(t_isspace_0x85);
    suite_add_test(t_isspace_0x86);
    suite_add_test(t_isspace_0x87);
    suite_add_test(t_isspace_0x88);
    suite_add_test(t_isspace_0x89);
    suite_add_test(t_isspace_0x8a);
    suite_add_test(t_isspace_0x8b);
    suite_add_test(t_isspace_0x8c);
    suite_add_test(t_isspace_0x8d);
    suite_add_test(t_isspace_0x8e);
    suite_add_test(t_isspace_0x8f);
    suite_add_test(t_isspace_0x90);
    suite_add_test(t_isspace_0x91);
    suite_add_test(t_isspace_0x92);
    suite_add_test(t_isspace_0x93);
    suite_add_test(t_isspace_0x94);
    suite_add_test(t_isspace_0x95);
    suite_add_test(t_isspace_0x96);
    suite_add_test(t_isspace_0x97);
    suite_add_test(t_isspace_0x98);
    suite_add_test(t_isspace_0x99);
    suite_add_test(t_isspace_0x9a);
    suite_add_test(t_isspace_0x9b);
    suite_add_test(t_isspace_0x9c);
    suite_add_test(t_isspace_0x9d);
    suite_add_test(t_isspace_0x9e);
    suite_add_test(t_isspace_0x9f);
    suite_add_test(t_isspace_0xa0);
    suite_add_test(t_isspace_0xa1);
    suite_add_test(t_isspace_0xa2);
    suite_add_test(t_isspace_0xa3);
    suite_add_test(t_isspace_0xa4);
    suite_add_test(t_isspace_0xa5);
    suite_add_test(t_isspace_0xa6);
    suite_add_test(t_isspace_0xa7);
    suite_add_test(t_isspace_0xa8);
    suite_add_test(t_isspace_0xa9);
    suite_add_test(t_isspace_0xaa);
    suite_add_test(t_isspace_0xab);
    suite_add_test(t_isspace_0xac);
    suite_add_test(t_isspace_0xad);
    suite_add_test(t_isspace_0xae);
    suite_add_test(t_isspace_0xaf);
    suite_add_test(t_isspace_0xb0);
    suite_add_test(t_isspace_0xb1);
    suite_add_test(t_isspace_0xb2);
    suite_add_test(t_isspace_0xb3);
    suite_add_test(t_isspace_0xb4);
    suite_add_test(t_isspace_0xb5);
    suite_add_test(t_isspace_0xb6);
    suite_add_test(t_isspace_0xb7);
    suite_add_test(t_isspace_0xb8);
    suite_add_test(t_isspace_0xb9);
    suite_add_test(t_isspace_0xba);
    suite_add_test(t_isspace_0xbb);
    suite_add_test(t_isspace_0xbc);
    suite_add_test(t_isspace_0xbd);
    suite_add_test(t_isspace_0xbe);
    suite_add_test(t_isspace_0xbf);
    suite_add_test(t_isspace_0xc0);
    suite_add_test(t_isspace_0xc1);
    suite_add_test(t_isspace_0xc2);
    suite_add_test(t_isspace_0xc3);
    suite_add_test(t_isspace_0xc4);
    suite_add_test(t_isspace_0xc5);
    suite_add_test(t_isspace_0xc6);
    suite_add_test(t_isspace_0xc7);
    suite_add_test(t_isspace_0xc8);
    suite_add_test(t_isspace_0xc9);
    suite_add_test(t_isspace_0xca);
    suite_add_test(t_isspace_0xcb);
    suite_add_test(t_isspace_0xcc);
    suite_add_test(t_isspace_0xcd);
    suite_add_test(t_isspace_0xce);
    suite_add_test(t_isspace_0xcf);
    suite_add_test(t_isspace_0xd0);
    suite_add_test(t_isspace_0xd1);
    suite_add_test(t_isspace_0xd2);
    suite_add_test(t_isspace_0xd3);
    suite_add_test(t_isspace_0xd4);
    suite_add_test(t_isspace_0xd5);
    suite_add_test(t_isspace_0xd6);
    suite_add_test(t_isspace_0xd7);
    suite_add_test(t_isspace_0xd8);
    suite_add_test(t_isspace_0xd9);
    suite_add_test(t_isspace_0xda);
    suite_add_test(t_isspace_0xdb);
    suite_add_test(t_isspace_0xdc);
    suite_add_test(t_isspace_0xdd);
    suite_add_test(t_isspace_0xde);
    suite_add_test(t_isspace_0xdf);
    suite_add_test(t_isspace_0xe0);
    suite_add_test(t_isspace_0xe1);
    suite_add_test(t_isspace_0xe2);
    suite_add_test(t_isspace_0xe3);
    suite_add_test(t_isspace_0xe4);
    suite_add_test(t_isspace_0xe5);
    suite_add_test(t_isspace_0xe6);
    suite_add_test(t_isspace_0xe7);
    suite_add_test(t_isspace_0xe8);
    suite_add_test(t_isspace_0xe9);
    suite_add_test(t_isspace_0xea);
    suite_add_test(t_isspace_0xeb);
    suite_add_test(t_isspace_0xec);
    suite_add_test(t_isspace_0xed);
    suite_add_test(t_isspace_0xee);
    suite_add_test(t_isspace_0xef);
    suite_add_test(t_isspace_0xf0);
    suite_add_test(t_isspace_0xf1);
    suite_add_test(t_isspace_0xf2);
    suite_add_test(t_isspace_0xf3);
    suite_add_test(t_isspace_0xf4);
    suite_add_test(t_isspace_0xf5);
    suite_add_test(t_isspace_0xf6);
    suite_add_test(t_isspace_0xf7);
    suite_add_test(t_isspace_0xf8);
    suite_add_test(t_isspace_0xf9);
    suite_add_test(t_isspace_0xfa);
    suite_add_test(t_isspace_0xfb);
    suite_add_test(t_isspace_0xfc);
    suite_add_test(t_isspace_0xfd);
    suite_add_test(t_isspace_0xfe);
    suite_add_test(t_isspace_0xff);
     return suite_run();
}
