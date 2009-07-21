
#include "ctype_test.h"
void t_isdigit_0x00()
{
    Assert(isdigit(0)  == 0 ,"isdigit should be 0 for 0x00");
}

void t_isdigit_0x01()
{
    Assert(isdigit(1)  == 0 ,"isdigit should be 0 for 0x01");
}

void t_isdigit_0x02()
{
    Assert(isdigit(2)  == 0 ,"isdigit should be 0 for 0x02");
}

void t_isdigit_0x03()
{
    Assert(isdigit(3)  == 0 ,"isdigit should be 0 for 0x03");
}

void t_isdigit_0x04()
{
    Assert(isdigit(4)  == 0 ,"isdigit should be 0 for 0x04");
}

void t_isdigit_0x05()
{
    Assert(isdigit(5)  == 0 ,"isdigit should be 0 for 0x05");
}

void t_isdigit_0x06()
{
    Assert(isdigit(6)  == 0 ,"isdigit should be 0 for 0x06");
}

void t_isdigit_0x07()
{
    Assert(isdigit(7)  == 0 ,"isdigit should be 0 for 0x07");
}

void t_isdigit_0x08()
{
    Assert(isdigit(8)  == 0 ,"isdigit should be 0 for 0x08");
}

void t_isdigit_0x09()
{
    Assert(isdigit(9)  == 0 ,"isdigit should be 0 for 0x09");
}

void t_isdigit_0x0a()
{
    Assert(isdigit(10)  == 0 ,"isdigit should be 0 for 0x0a");
}

void t_isdigit_0x0b()
{
    Assert(isdigit(11)  == 0 ,"isdigit should be 0 for 0x0b");
}

void t_isdigit_0x0c()
{
    Assert(isdigit(12)  == 0 ,"isdigit should be 0 for 0x0c");
}

void t_isdigit_0x0d()
{
    Assert(isdigit(13)  == 0 ,"isdigit should be 0 for 0x0d");
}

void t_isdigit_0x0e()
{
    Assert(isdigit(14)  == 0 ,"isdigit should be 0 for 0x0e");
}

void t_isdigit_0x0f()
{
    Assert(isdigit(15)  == 0 ,"isdigit should be 0 for 0x0f");
}

void t_isdigit_0x10()
{
    Assert(isdigit(16)  == 0 ,"isdigit should be 0 for 0x10");
}

void t_isdigit_0x11()
{
    Assert(isdigit(17)  == 0 ,"isdigit should be 0 for 0x11");
}

void t_isdigit_0x12()
{
    Assert(isdigit(18)  == 0 ,"isdigit should be 0 for 0x12");
}

void t_isdigit_0x13()
{
    Assert(isdigit(19)  == 0 ,"isdigit should be 0 for 0x13");
}

void t_isdigit_0x14()
{
    Assert(isdigit(20)  == 0 ,"isdigit should be 0 for 0x14");
}

void t_isdigit_0x15()
{
    Assert(isdigit(21)  == 0 ,"isdigit should be 0 for 0x15");
}

void t_isdigit_0x16()
{
    Assert(isdigit(22)  == 0 ,"isdigit should be 0 for 0x16");
}

void t_isdigit_0x17()
{
    Assert(isdigit(23)  == 0 ,"isdigit should be 0 for 0x17");
}

void t_isdigit_0x18()
{
    Assert(isdigit(24)  == 0 ,"isdigit should be 0 for 0x18");
}

void t_isdigit_0x19()
{
    Assert(isdigit(25)  == 0 ,"isdigit should be 0 for 0x19");
}

void t_isdigit_0x1a()
{
    Assert(isdigit(26)  == 0 ,"isdigit should be 0 for 0x1a");
}

void t_isdigit_0x1b()
{
    Assert(isdigit(27)  == 0 ,"isdigit should be 0 for 0x1b");
}

void t_isdigit_0x1c()
{
    Assert(isdigit(28)  == 0 ,"isdigit should be 0 for 0x1c");
}

void t_isdigit_0x1d()
{
    Assert(isdigit(29)  == 0 ,"isdigit should be 0 for 0x1d");
}

void t_isdigit_0x1e()
{
    Assert(isdigit(30)  == 0 ,"isdigit should be 0 for 0x1e");
}

void t_isdigit_0x1f()
{
    Assert(isdigit(31)  == 0 ,"isdigit should be 0 for 0x1f");
}

void t_isdigit_0x20()
{
    Assert(isdigit(32)  == 0 ,"isdigit should be 0 for  ");
}

void t_isdigit_0x21()
{
    Assert(isdigit(33)  == 0 ,"isdigit should be 0 for !");
}

void t_isdigit_0x22()
{
    Assert(isdigit(34)  == 0 ,"isdigit should be 0 for 0x22");
}

void t_isdigit_0x23()
{
    Assert(isdigit(35)  == 0 ,"isdigit should be 0 for #");
}

void t_isdigit_0x24()
{
    Assert(isdigit(36)  == 0 ,"isdigit should be 0 for $");
}

void t_isdigit_0x25()
{
    Assert(isdigit(37)  == 0 ,"isdigit should be 0 for %");
}

void t_isdigit_0x26()
{
    Assert(isdigit(38)  == 0 ,"isdigit should be 0 for &");
}

void t_isdigit_0x27()
{
    Assert(isdigit(39)  == 0 ,"isdigit should be 0 for '");
}

void t_isdigit_0x28()
{
    Assert(isdigit(40)  == 0 ,"isdigit should be 0 for (");
}

void t_isdigit_0x29()
{
    Assert(isdigit(41)  == 0 ,"isdigit should be 0 for )");
}

void t_isdigit_0x2a()
{
    Assert(isdigit(42)  == 0 ,"isdigit should be 0 for *");
}

void t_isdigit_0x2b()
{
    Assert(isdigit(43)  == 0 ,"isdigit should be 0 for +");
}

void t_isdigit_0x2c()
{
    Assert(isdigit(44)  == 0 ,"isdigit should be 0 for ,");
}

void t_isdigit_0x2d()
{
    Assert(isdigit(45)  == 0 ,"isdigit should be 0 for -");
}

void t_isdigit_0x2e()
{
    Assert(isdigit(46)  == 0 ,"isdigit should be 0 for .");
}

void t_isdigit_0x2f()
{
    Assert(isdigit(47)  == 0 ,"isdigit should be 0 for /");
}

void t_isdigit_0x30()
{
    Assert(isdigit(48) ,"isdigit should be 1 for 0");
}

void t_isdigit_0x31()
{
    Assert(isdigit(49) ,"isdigit should be 1 for 1");
}

void t_isdigit_0x32()
{
    Assert(isdigit(50) ,"isdigit should be 1 for 2");
}

void t_isdigit_0x33()
{
    Assert(isdigit(51) ,"isdigit should be 1 for 3");
}

void t_isdigit_0x34()
{
    Assert(isdigit(52) ,"isdigit should be 1 for 4");
}

void t_isdigit_0x35()
{
    Assert(isdigit(53) ,"isdigit should be 1 for 5");
}

void t_isdigit_0x36()
{
    Assert(isdigit(54) ,"isdigit should be 1 for 6");
}

void t_isdigit_0x37()
{
    Assert(isdigit(55) ,"isdigit should be 1 for 7");
}

void t_isdigit_0x38()
{
    Assert(isdigit(56) ,"isdigit should be 1 for 8");
}

void t_isdigit_0x39()
{
    Assert(isdigit(57) ,"isdigit should be 1 for 9");
}

void t_isdigit_0x3a()
{
    Assert(isdigit(58)  == 0 ,"isdigit should be 0 for :");
}

void t_isdigit_0x3b()
{
    Assert(isdigit(59)  == 0 ,"isdigit should be 0 for ;");
}

void t_isdigit_0x3c()
{
    Assert(isdigit(60)  == 0 ,"isdigit should be 0 for <");
}

void t_isdigit_0x3d()
{
    Assert(isdigit(61)  == 0 ,"isdigit should be 0 for =");
}

void t_isdigit_0x3e()
{
    Assert(isdigit(62)  == 0 ,"isdigit should be 0 for >");
}

void t_isdigit_0x3f()
{
    Assert(isdigit(63)  == 0 ,"isdigit should be 0 for ?");
}

void t_isdigit_0x40()
{
    Assert(isdigit(64)  == 0 ,"isdigit should be 0 for @");
}

void t_isdigit_0x41()
{
    Assert(isdigit(65)  == 0 ,"isdigit should be 0 for A");
}

void t_isdigit_0x42()
{
    Assert(isdigit(66)  == 0 ,"isdigit should be 0 for B");
}

void t_isdigit_0x43()
{
    Assert(isdigit(67)  == 0 ,"isdigit should be 0 for C");
}

void t_isdigit_0x44()
{
    Assert(isdigit(68)  == 0 ,"isdigit should be 0 for D");
}

void t_isdigit_0x45()
{
    Assert(isdigit(69)  == 0 ,"isdigit should be 0 for E");
}

void t_isdigit_0x46()
{
    Assert(isdigit(70)  == 0 ,"isdigit should be 0 for F");
}

void t_isdigit_0x47()
{
    Assert(isdigit(71)  == 0 ,"isdigit should be 0 for G");
}

void t_isdigit_0x48()
{
    Assert(isdigit(72)  == 0 ,"isdigit should be 0 for H");
}

void t_isdigit_0x49()
{
    Assert(isdigit(73)  == 0 ,"isdigit should be 0 for I");
}

void t_isdigit_0x4a()
{
    Assert(isdigit(74)  == 0 ,"isdigit should be 0 for J");
}

void t_isdigit_0x4b()
{
    Assert(isdigit(75)  == 0 ,"isdigit should be 0 for K");
}

void t_isdigit_0x4c()
{
    Assert(isdigit(76)  == 0 ,"isdigit should be 0 for L");
}

void t_isdigit_0x4d()
{
    Assert(isdigit(77)  == 0 ,"isdigit should be 0 for M");
}

void t_isdigit_0x4e()
{
    Assert(isdigit(78)  == 0 ,"isdigit should be 0 for N");
}

void t_isdigit_0x4f()
{
    Assert(isdigit(79)  == 0 ,"isdigit should be 0 for O");
}

void t_isdigit_0x50()
{
    Assert(isdigit(80)  == 0 ,"isdigit should be 0 for P");
}

void t_isdigit_0x51()
{
    Assert(isdigit(81)  == 0 ,"isdigit should be 0 for Q");
}

void t_isdigit_0x52()
{
    Assert(isdigit(82)  == 0 ,"isdigit should be 0 for R");
}

void t_isdigit_0x53()
{
    Assert(isdigit(83)  == 0 ,"isdigit should be 0 for S");
}

void t_isdigit_0x54()
{
    Assert(isdigit(84)  == 0 ,"isdigit should be 0 for T");
}

void t_isdigit_0x55()
{
    Assert(isdigit(85)  == 0 ,"isdigit should be 0 for U");
}

void t_isdigit_0x56()
{
    Assert(isdigit(86)  == 0 ,"isdigit should be 0 for V");
}

void t_isdigit_0x57()
{
    Assert(isdigit(87)  == 0 ,"isdigit should be 0 for W");
}

void t_isdigit_0x58()
{
    Assert(isdigit(88)  == 0 ,"isdigit should be 0 for X");
}

void t_isdigit_0x59()
{
    Assert(isdigit(89)  == 0 ,"isdigit should be 0 for Y");
}

void t_isdigit_0x5a()
{
    Assert(isdigit(90)  == 0 ,"isdigit should be 0 for Z");
}

void t_isdigit_0x5b()
{
    Assert(isdigit(91)  == 0 ,"isdigit should be 0 for [");
}

void t_isdigit_0x5c()
{
    Assert(isdigit(92)  == 0 ,"isdigit should be 0 for 0x5c");
}

void t_isdigit_0x5d()
{
    Assert(isdigit(93)  == 0 ,"isdigit should be 0 for ]");
}

void t_isdigit_0x5e()
{
    Assert(isdigit(94)  == 0 ,"isdigit should be 0 for ^");
}

void t_isdigit_0x5f()
{
    Assert(isdigit(95)  == 0 ,"isdigit should be 0 for _");
}

void t_isdigit_0x60()
{
    Assert(isdigit(96)  == 0 ,"isdigit should be 0 for `");
}

void t_isdigit_0x61()
{
    Assert(isdigit(97)  == 0 ,"isdigit should be 0 for a");
}

void t_isdigit_0x62()
{
    Assert(isdigit(98)  == 0 ,"isdigit should be 0 for b");
}

void t_isdigit_0x63()
{
    Assert(isdigit(99)  == 0 ,"isdigit should be 0 for c");
}

void t_isdigit_0x64()
{
    Assert(isdigit(100)  == 0 ,"isdigit should be 0 for d");
}

void t_isdigit_0x65()
{
    Assert(isdigit(101)  == 0 ,"isdigit should be 0 for e");
}

void t_isdigit_0x66()
{
    Assert(isdigit(102)  == 0 ,"isdigit should be 0 for f");
}

void t_isdigit_0x67()
{
    Assert(isdigit(103)  == 0 ,"isdigit should be 0 for g");
}

void t_isdigit_0x68()
{
    Assert(isdigit(104)  == 0 ,"isdigit should be 0 for h");
}

void t_isdigit_0x69()
{
    Assert(isdigit(105)  == 0 ,"isdigit should be 0 for i");
}

void t_isdigit_0x6a()
{
    Assert(isdigit(106)  == 0 ,"isdigit should be 0 for j");
}

void t_isdigit_0x6b()
{
    Assert(isdigit(107)  == 0 ,"isdigit should be 0 for k");
}

void t_isdigit_0x6c()
{
    Assert(isdigit(108)  == 0 ,"isdigit should be 0 for l");
}

void t_isdigit_0x6d()
{
    Assert(isdigit(109)  == 0 ,"isdigit should be 0 for m");
}

void t_isdigit_0x6e()
{
    Assert(isdigit(110)  == 0 ,"isdigit should be 0 for n");
}

void t_isdigit_0x6f()
{
    Assert(isdigit(111)  == 0 ,"isdigit should be 0 for o");
}

void t_isdigit_0x70()
{
    Assert(isdigit(112)  == 0 ,"isdigit should be 0 for p");
}

void t_isdigit_0x71()
{
    Assert(isdigit(113)  == 0 ,"isdigit should be 0 for q");
}

void t_isdigit_0x72()
{
    Assert(isdigit(114)  == 0 ,"isdigit should be 0 for r");
}

void t_isdigit_0x73()
{
    Assert(isdigit(115)  == 0 ,"isdigit should be 0 for s");
}

void t_isdigit_0x74()
{
    Assert(isdigit(116)  == 0 ,"isdigit should be 0 for t");
}

void t_isdigit_0x75()
{
    Assert(isdigit(117)  == 0 ,"isdigit should be 0 for u");
}

void t_isdigit_0x76()
{
    Assert(isdigit(118)  == 0 ,"isdigit should be 0 for v");
}

void t_isdigit_0x77()
{
    Assert(isdigit(119)  == 0 ,"isdigit should be 0 for w");
}

void t_isdigit_0x78()
{
    Assert(isdigit(120)  == 0 ,"isdigit should be 0 for x");
}

void t_isdigit_0x79()
{
    Assert(isdigit(121)  == 0 ,"isdigit should be 0 for y");
}

void t_isdigit_0x7a()
{
    Assert(isdigit(122)  == 0 ,"isdigit should be 0 for z");
}

void t_isdigit_0x7b()
{
    Assert(isdigit(123)  == 0 ,"isdigit should be 0 for {");
}

void t_isdigit_0x7c()
{
    Assert(isdigit(124)  == 0 ,"isdigit should be 0 for |");
}

void t_isdigit_0x7d()
{
    Assert(isdigit(125)  == 0 ,"isdigit should be 0 for }");
}

void t_isdigit_0x7e()
{
    Assert(isdigit(126)  == 0 ,"isdigit should be 0 for ~");
}

void t_isdigit_0x7f()
{
    Assert(isdigit(127)  == 0 ,"isdigit should be 0 for 0x7f");
}

void t_isdigit_0x80()
{
    Assert(isdigit(128)  == 0 ,"isdigit should be 0 for 0x80");
}

void t_isdigit_0x81()
{
    Assert(isdigit(129)  == 0 ,"isdigit should be 0 for 0x81");
}

void t_isdigit_0x82()
{
    Assert(isdigit(130)  == 0 ,"isdigit should be 0 for 0x82");
}

void t_isdigit_0x83()
{
    Assert(isdigit(131)  == 0 ,"isdigit should be 0 for 0x83");
}

void t_isdigit_0x84()
{
    Assert(isdigit(132)  == 0 ,"isdigit should be 0 for 0x84");
}

void t_isdigit_0x85()
{
    Assert(isdigit(133)  == 0 ,"isdigit should be 0 for 0x85");
}

void t_isdigit_0x86()
{
    Assert(isdigit(134)  == 0 ,"isdigit should be 0 for 0x86");
}

void t_isdigit_0x87()
{
    Assert(isdigit(135)  == 0 ,"isdigit should be 0 for 0x87");
}

void t_isdigit_0x88()
{
    Assert(isdigit(136)  == 0 ,"isdigit should be 0 for 0x88");
}

void t_isdigit_0x89()
{
    Assert(isdigit(137)  == 0 ,"isdigit should be 0 for 0x89");
}

void t_isdigit_0x8a()
{
    Assert(isdigit(138)  == 0 ,"isdigit should be 0 for 0x8a");
}

void t_isdigit_0x8b()
{
    Assert(isdigit(139)  == 0 ,"isdigit should be 0 for 0x8b");
}

void t_isdigit_0x8c()
{
    Assert(isdigit(140)  == 0 ,"isdigit should be 0 for 0x8c");
}

void t_isdigit_0x8d()
{
    Assert(isdigit(141)  == 0 ,"isdigit should be 0 for 0x8d");
}

void t_isdigit_0x8e()
{
    Assert(isdigit(142)  == 0 ,"isdigit should be 0 for 0x8e");
}

void t_isdigit_0x8f()
{
    Assert(isdigit(143)  == 0 ,"isdigit should be 0 for 0x8f");
}

void t_isdigit_0x90()
{
    Assert(isdigit(144)  == 0 ,"isdigit should be 0 for 0x90");
}

void t_isdigit_0x91()
{
    Assert(isdigit(145)  == 0 ,"isdigit should be 0 for 0x91");
}

void t_isdigit_0x92()
{
    Assert(isdigit(146)  == 0 ,"isdigit should be 0 for 0x92");
}

void t_isdigit_0x93()
{
    Assert(isdigit(147)  == 0 ,"isdigit should be 0 for 0x93");
}

void t_isdigit_0x94()
{
    Assert(isdigit(148)  == 0 ,"isdigit should be 0 for 0x94");
}

void t_isdigit_0x95()
{
    Assert(isdigit(149)  == 0 ,"isdigit should be 0 for 0x95");
}

void t_isdigit_0x96()
{
    Assert(isdigit(150)  == 0 ,"isdigit should be 0 for 0x96");
}

void t_isdigit_0x97()
{
    Assert(isdigit(151)  == 0 ,"isdigit should be 0 for 0x97");
}

void t_isdigit_0x98()
{
    Assert(isdigit(152)  == 0 ,"isdigit should be 0 for 0x98");
}

void t_isdigit_0x99()
{
    Assert(isdigit(153)  == 0 ,"isdigit should be 0 for 0x99");
}

void t_isdigit_0x9a()
{
    Assert(isdigit(154)  == 0 ,"isdigit should be 0 for 0x9a");
}

void t_isdigit_0x9b()
{
    Assert(isdigit(155)  == 0 ,"isdigit should be 0 for 0x9b");
}

void t_isdigit_0x9c()
{
    Assert(isdigit(156)  == 0 ,"isdigit should be 0 for 0x9c");
}

void t_isdigit_0x9d()
{
    Assert(isdigit(157)  == 0 ,"isdigit should be 0 for 0x9d");
}

void t_isdigit_0x9e()
{
    Assert(isdigit(158)  == 0 ,"isdigit should be 0 for 0x9e");
}

void t_isdigit_0x9f()
{
    Assert(isdigit(159)  == 0 ,"isdigit should be 0 for 0x9f");
}

void t_isdigit_0xa0()
{
    Assert(isdigit(160)  == 0 ,"isdigit should be 0 for 0xa0");
}

void t_isdigit_0xa1()
{
    Assert(isdigit(161)  == 0 ,"isdigit should be 0 for 0xa1");
}

void t_isdigit_0xa2()
{
    Assert(isdigit(162)  == 0 ,"isdigit should be 0 for 0xa2");
}

void t_isdigit_0xa3()
{
    Assert(isdigit(163)  == 0 ,"isdigit should be 0 for 0xa3");
}

void t_isdigit_0xa4()
{
    Assert(isdigit(164)  == 0 ,"isdigit should be 0 for 0xa4");
}

void t_isdigit_0xa5()
{
    Assert(isdigit(165)  == 0 ,"isdigit should be 0 for 0xa5");
}

void t_isdigit_0xa6()
{
    Assert(isdigit(166)  == 0 ,"isdigit should be 0 for 0xa6");
}

void t_isdigit_0xa7()
{
    Assert(isdigit(167)  == 0 ,"isdigit should be 0 for 0xa7");
}

void t_isdigit_0xa8()
{
    Assert(isdigit(168)  == 0 ,"isdigit should be 0 for 0xa8");
}

void t_isdigit_0xa9()
{
    Assert(isdigit(169)  == 0 ,"isdigit should be 0 for 0xa9");
}

void t_isdigit_0xaa()
{
    Assert(isdigit(170)  == 0 ,"isdigit should be 0 for 0xaa");
}

void t_isdigit_0xab()
{
    Assert(isdigit(171)  == 0 ,"isdigit should be 0 for 0xab");
}

void t_isdigit_0xac()
{
    Assert(isdigit(172)  == 0 ,"isdigit should be 0 for 0xac");
}

void t_isdigit_0xad()
{
    Assert(isdigit(173)  == 0 ,"isdigit should be 0 for 0xad");
}

void t_isdigit_0xae()
{
    Assert(isdigit(174)  == 0 ,"isdigit should be 0 for 0xae");
}

void t_isdigit_0xaf()
{
    Assert(isdigit(175)  == 0 ,"isdigit should be 0 for 0xaf");
}

void t_isdigit_0xb0()
{
    Assert(isdigit(176)  == 0 ,"isdigit should be 0 for 0xb0");
}

void t_isdigit_0xb1()
{
    Assert(isdigit(177)  == 0 ,"isdigit should be 0 for 0xb1");
}

void t_isdigit_0xb2()
{
    Assert(isdigit(178)  == 0 ,"isdigit should be 0 for 0xb2");
}

void t_isdigit_0xb3()
{
    Assert(isdigit(179)  == 0 ,"isdigit should be 0 for 0xb3");
}

void t_isdigit_0xb4()
{
    Assert(isdigit(180)  == 0 ,"isdigit should be 0 for 0xb4");
}

void t_isdigit_0xb5()
{
    Assert(isdigit(181)  == 0 ,"isdigit should be 0 for 0xb5");
}

void t_isdigit_0xb6()
{
    Assert(isdigit(182)  == 0 ,"isdigit should be 0 for 0xb6");
}

void t_isdigit_0xb7()
{
    Assert(isdigit(183)  == 0 ,"isdigit should be 0 for 0xb7");
}

void t_isdigit_0xb8()
{
    Assert(isdigit(184)  == 0 ,"isdigit should be 0 for 0xb8");
}

void t_isdigit_0xb9()
{
    Assert(isdigit(185)  == 0 ,"isdigit should be 0 for 0xb9");
}

void t_isdigit_0xba()
{
    Assert(isdigit(186)  == 0 ,"isdigit should be 0 for 0xba");
}

void t_isdigit_0xbb()
{
    Assert(isdigit(187)  == 0 ,"isdigit should be 0 for 0xbb");
}

void t_isdigit_0xbc()
{
    Assert(isdigit(188)  == 0 ,"isdigit should be 0 for 0xbc");
}

void t_isdigit_0xbd()
{
    Assert(isdigit(189)  == 0 ,"isdigit should be 0 for 0xbd");
}

void t_isdigit_0xbe()
{
    Assert(isdigit(190)  == 0 ,"isdigit should be 0 for 0xbe");
}

void t_isdigit_0xbf()
{
    Assert(isdigit(191)  == 0 ,"isdigit should be 0 for 0xbf");
}

void t_isdigit_0xc0()
{
    Assert(isdigit(192)  == 0 ,"isdigit should be 0 for 0xc0");
}

void t_isdigit_0xc1()
{
    Assert(isdigit(193)  == 0 ,"isdigit should be 0 for 0xc1");
}

void t_isdigit_0xc2()
{
    Assert(isdigit(194)  == 0 ,"isdigit should be 0 for 0xc2");
}

void t_isdigit_0xc3()
{
    Assert(isdigit(195)  == 0 ,"isdigit should be 0 for 0xc3");
}

void t_isdigit_0xc4()
{
    Assert(isdigit(196)  == 0 ,"isdigit should be 0 for 0xc4");
}

void t_isdigit_0xc5()
{
    Assert(isdigit(197)  == 0 ,"isdigit should be 0 for 0xc5");
}

void t_isdigit_0xc6()
{
    Assert(isdigit(198)  == 0 ,"isdigit should be 0 for 0xc6");
}

void t_isdigit_0xc7()
{
    Assert(isdigit(199)  == 0 ,"isdigit should be 0 for 0xc7");
}

void t_isdigit_0xc8()
{
    Assert(isdigit(200)  == 0 ,"isdigit should be 0 for 0xc8");
}

void t_isdigit_0xc9()
{
    Assert(isdigit(201)  == 0 ,"isdigit should be 0 for 0xc9");
}

void t_isdigit_0xca()
{
    Assert(isdigit(202)  == 0 ,"isdigit should be 0 for 0xca");
}

void t_isdigit_0xcb()
{
    Assert(isdigit(203)  == 0 ,"isdigit should be 0 for 0xcb");
}

void t_isdigit_0xcc()
{
    Assert(isdigit(204)  == 0 ,"isdigit should be 0 for 0xcc");
}

void t_isdigit_0xcd()
{
    Assert(isdigit(205)  == 0 ,"isdigit should be 0 for 0xcd");
}

void t_isdigit_0xce()
{
    Assert(isdigit(206)  == 0 ,"isdigit should be 0 for 0xce");
}

void t_isdigit_0xcf()
{
    Assert(isdigit(207)  == 0 ,"isdigit should be 0 for 0xcf");
}

void t_isdigit_0xd0()
{
    Assert(isdigit(208)  == 0 ,"isdigit should be 0 for 0xd0");
}

void t_isdigit_0xd1()
{
    Assert(isdigit(209)  == 0 ,"isdigit should be 0 for 0xd1");
}

void t_isdigit_0xd2()
{
    Assert(isdigit(210)  == 0 ,"isdigit should be 0 for 0xd2");
}

void t_isdigit_0xd3()
{
    Assert(isdigit(211)  == 0 ,"isdigit should be 0 for 0xd3");
}

void t_isdigit_0xd4()
{
    Assert(isdigit(212)  == 0 ,"isdigit should be 0 for 0xd4");
}

void t_isdigit_0xd5()
{
    Assert(isdigit(213)  == 0 ,"isdigit should be 0 for 0xd5");
}

void t_isdigit_0xd6()
{
    Assert(isdigit(214)  == 0 ,"isdigit should be 0 for 0xd6");
}

void t_isdigit_0xd7()
{
    Assert(isdigit(215)  == 0 ,"isdigit should be 0 for 0xd7");
}

void t_isdigit_0xd8()
{
    Assert(isdigit(216)  == 0 ,"isdigit should be 0 for 0xd8");
}

void t_isdigit_0xd9()
{
    Assert(isdigit(217)  == 0 ,"isdigit should be 0 for 0xd9");
}

void t_isdigit_0xda()
{
    Assert(isdigit(218)  == 0 ,"isdigit should be 0 for 0xda");
}

void t_isdigit_0xdb()
{
    Assert(isdigit(219)  == 0 ,"isdigit should be 0 for 0xdb");
}

void t_isdigit_0xdc()
{
    Assert(isdigit(220)  == 0 ,"isdigit should be 0 for 0xdc");
}

void t_isdigit_0xdd()
{
    Assert(isdigit(221)  == 0 ,"isdigit should be 0 for 0xdd");
}

void t_isdigit_0xde()
{
    Assert(isdigit(222)  == 0 ,"isdigit should be 0 for 0xde");
}

void t_isdigit_0xdf()
{
    Assert(isdigit(223)  == 0 ,"isdigit should be 0 for 0xdf");
}

void t_isdigit_0xe0()
{
    Assert(isdigit(224)  == 0 ,"isdigit should be 0 for 0xe0");
}

void t_isdigit_0xe1()
{
    Assert(isdigit(225)  == 0 ,"isdigit should be 0 for 0xe1");
}

void t_isdigit_0xe2()
{
    Assert(isdigit(226)  == 0 ,"isdigit should be 0 for 0xe2");
}

void t_isdigit_0xe3()
{
    Assert(isdigit(227)  == 0 ,"isdigit should be 0 for 0xe3");
}

void t_isdigit_0xe4()
{
    Assert(isdigit(228)  == 0 ,"isdigit should be 0 for 0xe4");
}

void t_isdigit_0xe5()
{
    Assert(isdigit(229)  == 0 ,"isdigit should be 0 for 0xe5");
}

void t_isdigit_0xe6()
{
    Assert(isdigit(230)  == 0 ,"isdigit should be 0 for 0xe6");
}

void t_isdigit_0xe7()
{
    Assert(isdigit(231)  == 0 ,"isdigit should be 0 for 0xe7");
}

void t_isdigit_0xe8()
{
    Assert(isdigit(232)  == 0 ,"isdigit should be 0 for 0xe8");
}

void t_isdigit_0xe9()
{
    Assert(isdigit(233)  == 0 ,"isdigit should be 0 for 0xe9");
}

void t_isdigit_0xea()
{
    Assert(isdigit(234)  == 0 ,"isdigit should be 0 for 0xea");
}

void t_isdigit_0xeb()
{
    Assert(isdigit(235)  == 0 ,"isdigit should be 0 for 0xeb");
}

void t_isdigit_0xec()
{
    Assert(isdigit(236)  == 0 ,"isdigit should be 0 for 0xec");
}

void t_isdigit_0xed()
{
    Assert(isdigit(237)  == 0 ,"isdigit should be 0 for 0xed");
}

void t_isdigit_0xee()
{
    Assert(isdigit(238)  == 0 ,"isdigit should be 0 for 0xee");
}

void t_isdigit_0xef()
{
    Assert(isdigit(239)  == 0 ,"isdigit should be 0 for 0xef");
}

void t_isdigit_0xf0()
{
    Assert(isdigit(240)  == 0 ,"isdigit should be 0 for 0xf0");
}

void t_isdigit_0xf1()
{
    Assert(isdigit(241)  == 0 ,"isdigit should be 0 for 0xf1");
}

void t_isdigit_0xf2()
{
    Assert(isdigit(242)  == 0 ,"isdigit should be 0 for 0xf2");
}

void t_isdigit_0xf3()
{
    Assert(isdigit(243)  == 0 ,"isdigit should be 0 for 0xf3");
}

void t_isdigit_0xf4()
{
    Assert(isdigit(244)  == 0 ,"isdigit should be 0 for 0xf4");
}

void t_isdigit_0xf5()
{
    Assert(isdigit(245)  == 0 ,"isdigit should be 0 for 0xf5");
}

void t_isdigit_0xf6()
{
    Assert(isdigit(246)  == 0 ,"isdigit should be 0 for 0xf6");
}

void t_isdigit_0xf7()
{
    Assert(isdigit(247)  == 0 ,"isdigit should be 0 for 0xf7");
}

void t_isdigit_0xf8()
{
    Assert(isdigit(248)  == 0 ,"isdigit should be 0 for 0xf8");
}

void t_isdigit_0xf9()
{
    Assert(isdigit(249)  == 0 ,"isdigit should be 0 for 0xf9");
}

void t_isdigit_0xfa()
{
    Assert(isdigit(250)  == 0 ,"isdigit should be 0 for 0xfa");
}

void t_isdigit_0xfb()
{
    Assert(isdigit(251)  == 0 ,"isdigit should be 0 for 0xfb");
}

void t_isdigit_0xfc()
{
    Assert(isdigit(252)  == 0 ,"isdigit should be 0 for 0xfc");
}

void t_isdigit_0xfd()
{
    Assert(isdigit(253)  == 0 ,"isdigit should be 0 for 0xfd");
}

void t_isdigit_0xfe()
{
    Assert(isdigit(254)  == 0 ,"isdigit should be 0 for 0xfe");
}

void t_isdigit_0xff()
{
    Assert(isdigit(255)  == 0 ,"isdigit should be 0 for 0xff");
}



int test_isdigit()
{
    suite_setup("isdigit");
    suite_add_test(t_isdigit_0x00);
    suite_add_test(t_isdigit_0x01);
    suite_add_test(t_isdigit_0x02);
    suite_add_test(t_isdigit_0x03);
    suite_add_test(t_isdigit_0x04);
    suite_add_test(t_isdigit_0x05);
    suite_add_test(t_isdigit_0x06);
    suite_add_test(t_isdigit_0x07);
    suite_add_test(t_isdigit_0x08);
    suite_add_test(t_isdigit_0x09);
    suite_add_test(t_isdigit_0x0a);
    suite_add_test(t_isdigit_0x0b);
    suite_add_test(t_isdigit_0x0c);
    suite_add_test(t_isdigit_0x0d);
    suite_add_test(t_isdigit_0x0e);
    suite_add_test(t_isdigit_0x0f);
    suite_add_test(t_isdigit_0x10);
    suite_add_test(t_isdigit_0x11);
    suite_add_test(t_isdigit_0x12);
    suite_add_test(t_isdigit_0x13);
    suite_add_test(t_isdigit_0x14);
    suite_add_test(t_isdigit_0x15);
    suite_add_test(t_isdigit_0x16);
    suite_add_test(t_isdigit_0x17);
    suite_add_test(t_isdigit_0x18);
    suite_add_test(t_isdigit_0x19);
    suite_add_test(t_isdigit_0x1a);
    suite_add_test(t_isdigit_0x1b);
    suite_add_test(t_isdigit_0x1c);
    suite_add_test(t_isdigit_0x1d);
    suite_add_test(t_isdigit_0x1e);
    suite_add_test(t_isdigit_0x1f);
    suite_add_test(t_isdigit_0x20);
    suite_add_test(t_isdigit_0x21);
    suite_add_test(t_isdigit_0x22);
    suite_add_test(t_isdigit_0x23);
    suite_add_test(t_isdigit_0x24);
    suite_add_test(t_isdigit_0x25);
    suite_add_test(t_isdigit_0x26);
    suite_add_test(t_isdigit_0x27);
    suite_add_test(t_isdigit_0x28);
    suite_add_test(t_isdigit_0x29);
    suite_add_test(t_isdigit_0x2a);
    suite_add_test(t_isdigit_0x2b);
    suite_add_test(t_isdigit_0x2c);
    suite_add_test(t_isdigit_0x2d);
    suite_add_test(t_isdigit_0x2e);
    suite_add_test(t_isdigit_0x2f);
    suite_add_test(t_isdigit_0x30);
    suite_add_test(t_isdigit_0x31);
    suite_add_test(t_isdigit_0x32);
    suite_add_test(t_isdigit_0x33);
    suite_add_test(t_isdigit_0x34);
    suite_add_test(t_isdigit_0x35);
    suite_add_test(t_isdigit_0x36);
    suite_add_test(t_isdigit_0x37);
    suite_add_test(t_isdigit_0x38);
    suite_add_test(t_isdigit_0x39);
    suite_add_test(t_isdigit_0x3a);
    suite_add_test(t_isdigit_0x3b);
    suite_add_test(t_isdigit_0x3c);
    suite_add_test(t_isdigit_0x3d);
    suite_add_test(t_isdigit_0x3e);
    suite_add_test(t_isdigit_0x3f);
    suite_add_test(t_isdigit_0x40);
    suite_add_test(t_isdigit_0x41);
    suite_add_test(t_isdigit_0x42);
    suite_add_test(t_isdigit_0x43);
    suite_add_test(t_isdigit_0x44);
    suite_add_test(t_isdigit_0x45);
    suite_add_test(t_isdigit_0x46);
    suite_add_test(t_isdigit_0x47);
    suite_add_test(t_isdigit_0x48);
    suite_add_test(t_isdigit_0x49);
    suite_add_test(t_isdigit_0x4a);
    suite_add_test(t_isdigit_0x4b);
    suite_add_test(t_isdigit_0x4c);
    suite_add_test(t_isdigit_0x4d);
    suite_add_test(t_isdigit_0x4e);
    suite_add_test(t_isdigit_0x4f);
    suite_add_test(t_isdigit_0x50);
    suite_add_test(t_isdigit_0x51);
    suite_add_test(t_isdigit_0x52);
    suite_add_test(t_isdigit_0x53);
    suite_add_test(t_isdigit_0x54);
    suite_add_test(t_isdigit_0x55);
    suite_add_test(t_isdigit_0x56);
    suite_add_test(t_isdigit_0x57);
    suite_add_test(t_isdigit_0x58);
    suite_add_test(t_isdigit_0x59);
    suite_add_test(t_isdigit_0x5a);
    suite_add_test(t_isdigit_0x5b);
    suite_add_test(t_isdigit_0x5c);
    suite_add_test(t_isdigit_0x5d);
    suite_add_test(t_isdigit_0x5e);
    suite_add_test(t_isdigit_0x5f);
    suite_add_test(t_isdigit_0x60);
    suite_add_test(t_isdigit_0x61);
    suite_add_test(t_isdigit_0x62);
    suite_add_test(t_isdigit_0x63);
    suite_add_test(t_isdigit_0x64);
    suite_add_test(t_isdigit_0x65);
    suite_add_test(t_isdigit_0x66);
    suite_add_test(t_isdigit_0x67);
    suite_add_test(t_isdigit_0x68);
    suite_add_test(t_isdigit_0x69);
    suite_add_test(t_isdigit_0x6a);
    suite_add_test(t_isdigit_0x6b);
    suite_add_test(t_isdigit_0x6c);
    suite_add_test(t_isdigit_0x6d);
    suite_add_test(t_isdigit_0x6e);
    suite_add_test(t_isdigit_0x6f);
    suite_add_test(t_isdigit_0x70);
    suite_add_test(t_isdigit_0x71);
    suite_add_test(t_isdigit_0x72);
    suite_add_test(t_isdigit_0x73);
    suite_add_test(t_isdigit_0x74);
    suite_add_test(t_isdigit_0x75);
    suite_add_test(t_isdigit_0x76);
    suite_add_test(t_isdigit_0x77);
    suite_add_test(t_isdigit_0x78);
    suite_add_test(t_isdigit_0x79);
    suite_add_test(t_isdigit_0x7a);
    suite_add_test(t_isdigit_0x7b);
    suite_add_test(t_isdigit_0x7c);
    suite_add_test(t_isdigit_0x7d);
    suite_add_test(t_isdigit_0x7e);
    suite_add_test(t_isdigit_0x7f);
    suite_add_test(t_isdigit_0x80);
    suite_add_test(t_isdigit_0x81);
    suite_add_test(t_isdigit_0x82);
    suite_add_test(t_isdigit_0x83);
    suite_add_test(t_isdigit_0x84);
    suite_add_test(t_isdigit_0x85);
    suite_add_test(t_isdigit_0x86);
    suite_add_test(t_isdigit_0x87);
    suite_add_test(t_isdigit_0x88);
    suite_add_test(t_isdigit_0x89);
    suite_add_test(t_isdigit_0x8a);
    suite_add_test(t_isdigit_0x8b);
    suite_add_test(t_isdigit_0x8c);
    suite_add_test(t_isdigit_0x8d);
    suite_add_test(t_isdigit_0x8e);
    suite_add_test(t_isdigit_0x8f);
    suite_add_test(t_isdigit_0x90);
    suite_add_test(t_isdigit_0x91);
    suite_add_test(t_isdigit_0x92);
    suite_add_test(t_isdigit_0x93);
    suite_add_test(t_isdigit_0x94);
    suite_add_test(t_isdigit_0x95);
    suite_add_test(t_isdigit_0x96);
    suite_add_test(t_isdigit_0x97);
    suite_add_test(t_isdigit_0x98);
    suite_add_test(t_isdigit_0x99);
    suite_add_test(t_isdigit_0x9a);
    suite_add_test(t_isdigit_0x9b);
    suite_add_test(t_isdigit_0x9c);
    suite_add_test(t_isdigit_0x9d);
    suite_add_test(t_isdigit_0x9e);
    suite_add_test(t_isdigit_0x9f);
    suite_add_test(t_isdigit_0xa0);
    suite_add_test(t_isdigit_0xa1);
    suite_add_test(t_isdigit_0xa2);
    suite_add_test(t_isdigit_0xa3);
    suite_add_test(t_isdigit_0xa4);
    suite_add_test(t_isdigit_0xa5);
    suite_add_test(t_isdigit_0xa6);
    suite_add_test(t_isdigit_0xa7);
    suite_add_test(t_isdigit_0xa8);
    suite_add_test(t_isdigit_0xa9);
    suite_add_test(t_isdigit_0xaa);
    suite_add_test(t_isdigit_0xab);
    suite_add_test(t_isdigit_0xac);
    suite_add_test(t_isdigit_0xad);
    suite_add_test(t_isdigit_0xae);
    suite_add_test(t_isdigit_0xaf);
    suite_add_test(t_isdigit_0xb0);
    suite_add_test(t_isdigit_0xb1);
    suite_add_test(t_isdigit_0xb2);
    suite_add_test(t_isdigit_0xb3);
    suite_add_test(t_isdigit_0xb4);
    suite_add_test(t_isdigit_0xb5);
    suite_add_test(t_isdigit_0xb6);
    suite_add_test(t_isdigit_0xb7);
    suite_add_test(t_isdigit_0xb8);
    suite_add_test(t_isdigit_0xb9);
    suite_add_test(t_isdigit_0xba);
    suite_add_test(t_isdigit_0xbb);
    suite_add_test(t_isdigit_0xbc);
    suite_add_test(t_isdigit_0xbd);
    suite_add_test(t_isdigit_0xbe);
    suite_add_test(t_isdigit_0xbf);
    suite_add_test(t_isdigit_0xc0);
    suite_add_test(t_isdigit_0xc1);
    suite_add_test(t_isdigit_0xc2);
    suite_add_test(t_isdigit_0xc3);
    suite_add_test(t_isdigit_0xc4);
    suite_add_test(t_isdigit_0xc5);
    suite_add_test(t_isdigit_0xc6);
    suite_add_test(t_isdigit_0xc7);
    suite_add_test(t_isdigit_0xc8);
    suite_add_test(t_isdigit_0xc9);
    suite_add_test(t_isdigit_0xca);
    suite_add_test(t_isdigit_0xcb);
    suite_add_test(t_isdigit_0xcc);
    suite_add_test(t_isdigit_0xcd);
    suite_add_test(t_isdigit_0xce);
    suite_add_test(t_isdigit_0xcf);
    suite_add_test(t_isdigit_0xd0);
    suite_add_test(t_isdigit_0xd1);
    suite_add_test(t_isdigit_0xd2);
    suite_add_test(t_isdigit_0xd3);
    suite_add_test(t_isdigit_0xd4);
    suite_add_test(t_isdigit_0xd5);
    suite_add_test(t_isdigit_0xd6);
    suite_add_test(t_isdigit_0xd7);
    suite_add_test(t_isdigit_0xd8);
    suite_add_test(t_isdigit_0xd9);
    suite_add_test(t_isdigit_0xda);
    suite_add_test(t_isdigit_0xdb);
    suite_add_test(t_isdigit_0xdc);
    suite_add_test(t_isdigit_0xdd);
    suite_add_test(t_isdigit_0xde);
    suite_add_test(t_isdigit_0xdf);
    suite_add_test(t_isdigit_0xe0);
    suite_add_test(t_isdigit_0xe1);
    suite_add_test(t_isdigit_0xe2);
    suite_add_test(t_isdigit_0xe3);
    suite_add_test(t_isdigit_0xe4);
    suite_add_test(t_isdigit_0xe5);
    suite_add_test(t_isdigit_0xe6);
    suite_add_test(t_isdigit_0xe7);
    suite_add_test(t_isdigit_0xe8);
    suite_add_test(t_isdigit_0xe9);
    suite_add_test(t_isdigit_0xea);
    suite_add_test(t_isdigit_0xeb);
    suite_add_test(t_isdigit_0xec);
    suite_add_test(t_isdigit_0xed);
    suite_add_test(t_isdigit_0xee);
    suite_add_test(t_isdigit_0xef);
    suite_add_test(t_isdigit_0xf0);
    suite_add_test(t_isdigit_0xf1);
    suite_add_test(t_isdigit_0xf2);
    suite_add_test(t_isdigit_0xf3);
    suite_add_test(t_isdigit_0xf4);
    suite_add_test(t_isdigit_0xf5);
    suite_add_test(t_isdigit_0xf6);
    suite_add_test(t_isdigit_0xf7);
    suite_add_test(t_isdigit_0xf8);
    suite_add_test(t_isdigit_0xf9);
    suite_add_test(t_isdigit_0xfa);
    suite_add_test(t_isdigit_0xfb);
    suite_add_test(t_isdigit_0xfc);
    suite_add_test(t_isdigit_0xfd);
    suite_add_test(t_isdigit_0xfe);
    suite_add_test(t_isdigit_0xff);
     return suite_run();
}
