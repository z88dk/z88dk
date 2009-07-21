
#include "ctype_test.h"
void t_isodigit_0x00()
{
    Assert(isodigit(0)  == 0 ,"isodigit should be 0 for 0x00");
}

void t_isodigit_0x01()
{
    Assert(isodigit(1)  == 0 ,"isodigit should be 0 for 0x01");
}

void t_isodigit_0x02()
{
    Assert(isodigit(2)  == 0 ,"isodigit should be 0 for 0x02");
}

void t_isodigit_0x03()
{
    Assert(isodigit(3)  == 0 ,"isodigit should be 0 for 0x03");
}

void t_isodigit_0x04()
{
    Assert(isodigit(4)  == 0 ,"isodigit should be 0 for 0x04");
}

void t_isodigit_0x05()
{
    Assert(isodigit(5)  == 0 ,"isodigit should be 0 for 0x05");
}

void t_isodigit_0x06()
{
    Assert(isodigit(6)  == 0 ,"isodigit should be 0 for 0x06");
}

void t_isodigit_0x07()
{
    Assert(isodigit(7)  == 0 ,"isodigit should be 0 for 0x07");
}

void t_isodigit_0x08()
{
    Assert(isodigit(8)  == 0 ,"isodigit should be 0 for 0x08");
}

void t_isodigit_0x09()
{
    Assert(isodigit(9)  == 0 ,"isodigit should be 0 for 0x09");
}

void t_isodigit_0x0a()
{
    Assert(isodigit(10)  == 0 ,"isodigit should be 0 for 0x0a");
}

void t_isodigit_0x0b()
{
    Assert(isodigit(11)  == 0 ,"isodigit should be 0 for 0x0b");
}

void t_isodigit_0x0c()
{
    Assert(isodigit(12)  == 0 ,"isodigit should be 0 for 0x0c");
}

void t_isodigit_0x0d()
{
    Assert(isodigit(13)  == 0 ,"isodigit should be 0 for 0x0d");
}

void t_isodigit_0x0e()
{
    Assert(isodigit(14)  == 0 ,"isodigit should be 0 for 0x0e");
}

void t_isodigit_0x0f()
{
    Assert(isodigit(15)  == 0 ,"isodigit should be 0 for 0x0f");
}

void t_isodigit_0x10()
{
    Assert(isodigit(16)  == 0 ,"isodigit should be 0 for 0x10");
}

void t_isodigit_0x11()
{
    Assert(isodigit(17)  == 0 ,"isodigit should be 0 for 0x11");
}

void t_isodigit_0x12()
{
    Assert(isodigit(18)  == 0 ,"isodigit should be 0 for 0x12");
}

void t_isodigit_0x13()
{
    Assert(isodigit(19)  == 0 ,"isodigit should be 0 for 0x13");
}

void t_isodigit_0x14()
{
    Assert(isodigit(20)  == 0 ,"isodigit should be 0 for 0x14");
}

void t_isodigit_0x15()
{
    Assert(isodigit(21)  == 0 ,"isodigit should be 0 for 0x15");
}

void t_isodigit_0x16()
{
    Assert(isodigit(22)  == 0 ,"isodigit should be 0 for 0x16");
}

void t_isodigit_0x17()
{
    Assert(isodigit(23)  == 0 ,"isodigit should be 0 for 0x17");
}

void t_isodigit_0x18()
{
    Assert(isodigit(24)  == 0 ,"isodigit should be 0 for 0x18");
}

void t_isodigit_0x19()
{
    Assert(isodigit(25)  == 0 ,"isodigit should be 0 for 0x19");
}

void t_isodigit_0x1a()
{
    Assert(isodigit(26)  == 0 ,"isodigit should be 0 for 0x1a");
}

void t_isodigit_0x1b()
{
    Assert(isodigit(27)  == 0 ,"isodigit should be 0 for 0x1b");
}

void t_isodigit_0x1c()
{
    Assert(isodigit(28)  == 0 ,"isodigit should be 0 for 0x1c");
}

void t_isodigit_0x1d()
{
    Assert(isodigit(29)  == 0 ,"isodigit should be 0 for 0x1d");
}

void t_isodigit_0x1e()
{
    Assert(isodigit(30)  == 0 ,"isodigit should be 0 for 0x1e");
}

void t_isodigit_0x1f()
{
    Assert(isodigit(31)  == 0 ,"isodigit should be 0 for 0x1f");
}

void t_isodigit_0x20()
{
    Assert(isodigit(32)  == 0 ,"isodigit should be 0 for  ");
}

void t_isodigit_0x21()
{
    Assert(isodigit(33)  == 0 ,"isodigit should be 0 for !");
}

void t_isodigit_0x22()
{
    Assert(isodigit(34)  == 0 ,"isodigit should be 0 for 0x22");
}

void t_isodigit_0x23()
{
    Assert(isodigit(35)  == 0 ,"isodigit should be 0 for #");
}

void t_isodigit_0x24()
{
    Assert(isodigit(36)  == 0 ,"isodigit should be 0 for $");
}

void t_isodigit_0x25()
{
    Assert(isodigit(37)  == 0 ,"isodigit should be 0 for %");
}

void t_isodigit_0x26()
{
    Assert(isodigit(38)  == 0 ,"isodigit should be 0 for &");
}

void t_isodigit_0x27()
{
    Assert(isodigit(39)  == 0 ,"isodigit should be 0 for '");
}

void t_isodigit_0x28()
{
    Assert(isodigit(40)  == 0 ,"isodigit should be 0 for (");
}

void t_isodigit_0x29()
{
    Assert(isodigit(41)  == 0 ,"isodigit should be 0 for )");
}

void t_isodigit_0x2a()
{
    Assert(isodigit(42)  == 0 ,"isodigit should be 0 for *");
}

void t_isodigit_0x2b()
{
    Assert(isodigit(43)  == 0 ,"isodigit should be 0 for +");
}

void t_isodigit_0x2c()
{
    Assert(isodigit(44)  == 0 ,"isodigit should be 0 for ,");
}

void t_isodigit_0x2d()
{
    Assert(isodigit(45)  == 0 ,"isodigit should be 0 for -");
}

void t_isodigit_0x2e()
{
    Assert(isodigit(46)  == 0 ,"isodigit should be 0 for .");
}

void t_isodigit_0x2f()
{
    Assert(isodigit(47)  == 0 ,"isodigit should be 0 for /");
}

void t_isodigit_0x30()
{
    Assert(isodigit(48) ,"isodigit should be 1 for 0");
}

void t_isodigit_0x31()
{
    Assert(isodigit(49) ,"isodigit should be 1 for 1");
}

void t_isodigit_0x32()
{
    Assert(isodigit(50) ,"isodigit should be 1 for 2");
}

void t_isodigit_0x33()
{
    Assert(isodigit(51) ,"isodigit should be 1 for 3");
}

void t_isodigit_0x34()
{
    Assert(isodigit(52) ,"isodigit should be 1 for 4");
}

void t_isodigit_0x35()
{
    Assert(isodigit(53) ,"isodigit should be 1 for 5");
}

void t_isodigit_0x36()
{
    Assert(isodigit(54) ,"isodigit should be 1 for 6");
}

void t_isodigit_0x37()
{
    Assert(isodigit(55) ,"isodigit should be 1 for 7");
}

void t_isodigit_0x38()
{
    Assert(isodigit(56) == 0,"isodigit should be 0 for 8");
}

void t_isodigit_0x39()
{
    Assert(isodigit(57) == 0,"isodigit should be 0 for 9");
}

void t_isodigit_0x3a()
{
    Assert(isodigit(58)  == 0 ,"isodigit should be 0 for :");
}

void t_isodigit_0x3b()
{
    Assert(isodigit(59)  == 0 ,"isodigit should be 0 for ;");
}

void t_isodigit_0x3c()
{
    Assert(isodigit(60)  == 0 ,"isodigit should be 0 for <");
}

void t_isodigit_0x3d()
{
    Assert(isodigit(61)  == 0 ,"isodigit should be 0 for =");
}

void t_isodigit_0x3e()
{
    Assert(isodigit(62)  == 0 ,"isodigit should be 0 for >");
}

void t_isodigit_0x3f()
{
    Assert(isodigit(63)  == 0 ,"isodigit should be 0 for ?");
}

void t_isodigit_0x40()
{
    Assert(isodigit(64)  == 0 ,"isodigit should be 0 for @");
}

void t_isodigit_0x41()
{
    Assert(isodigit(65)  == 0 ,"isodigit should be 0 for A");
}

void t_isodigit_0x42()
{
    Assert(isodigit(66)  == 0 ,"isodigit should be 0 for B");
}

void t_isodigit_0x43()
{
    Assert(isodigit(67)  == 0 ,"isodigit should be 0 for C");
}

void t_isodigit_0x44()
{
    Assert(isodigit(68)  == 0 ,"isodigit should be 0 for D");
}

void t_isodigit_0x45()
{
    Assert(isodigit(69)  == 0 ,"isodigit should be 0 for E");
}

void t_isodigit_0x46()
{
    Assert(isodigit(70)  == 0 ,"isodigit should be 0 for F");
}

void t_isodigit_0x47()
{
    Assert(isodigit(71)  == 0 ,"isodigit should be 0 for G");
}

void t_isodigit_0x48()
{
    Assert(isodigit(72)  == 0 ,"isodigit should be 0 for H");
}

void t_isodigit_0x49()
{
    Assert(isodigit(73)  == 0 ,"isodigit should be 0 for I");
}

void t_isodigit_0x4a()
{
    Assert(isodigit(74)  == 0 ,"isodigit should be 0 for J");
}

void t_isodigit_0x4b()
{
    Assert(isodigit(75)  == 0 ,"isodigit should be 0 for K");
}

void t_isodigit_0x4c()
{
    Assert(isodigit(76)  == 0 ,"isodigit should be 0 for L");
}

void t_isodigit_0x4d()
{
    Assert(isodigit(77)  == 0 ,"isodigit should be 0 for M");
}

void t_isodigit_0x4e()
{
    Assert(isodigit(78)  == 0 ,"isodigit should be 0 for N");
}

void t_isodigit_0x4f()
{
    Assert(isodigit(79)  == 0 ,"isodigit should be 0 for O");
}

void t_isodigit_0x50()
{
    Assert(isodigit(80)  == 0 ,"isodigit should be 0 for P");
}

void t_isodigit_0x51()
{
    Assert(isodigit(81)  == 0 ,"isodigit should be 0 for Q");
}

void t_isodigit_0x52()
{
    Assert(isodigit(82)  == 0 ,"isodigit should be 0 for R");
}

void t_isodigit_0x53()
{
    Assert(isodigit(83)  == 0 ,"isodigit should be 0 for S");
}

void t_isodigit_0x54()
{
    Assert(isodigit(84)  == 0 ,"isodigit should be 0 for T");
}

void t_isodigit_0x55()
{
    Assert(isodigit(85)  == 0 ,"isodigit should be 0 for U");
}

void t_isodigit_0x56()
{
    Assert(isodigit(86)  == 0 ,"isodigit should be 0 for V");
}

void t_isodigit_0x57()
{
    Assert(isodigit(87)  == 0 ,"isodigit should be 0 for W");
}

void t_isodigit_0x58()
{
    Assert(isodigit(88)  == 0 ,"isodigit should be 0 for X");
}

void t_isodigit_0x59()
{
    Assert(isodigit(89)  == 0 ,"isodigit should be 0 for Y");
}

void t_isodigit_0x5a()
{
    Assert(isodigit(90)  == 0 ,"isodigit should be 0 for Z");
}

void t_isodigit_0x5b()
{
    Assert(isodigit(91)  == 0 ,"isodigit should be 0 for [");
}

void t_isodigit_0x5c()
{
    Assert(isodigit(92)  == 0 ,"isodigit should be 0 for 0x5c");
}

void t_isodigit_0x5d()
{
    Assert(isodigit(93)  == 0 ,"isodigit should be 0 for ]");
}

void t_isodigit_0x5e()
{
    Assert(isodigit(94)  == 0 ,"isodigit should be 0 for ^");
}

void t_isodigit_0x5f()
{
    Assert(isodigit(95)  == 0 ,"isodigit should be 0 for _");
}

void t_isodigit_0x60()
{
    Assert(isodigit(96)  == 0 ,"isodigit should be 0 for `");
}

void t_isodigit_0x61()
{
    Assert(isodigit(97)  == 0 ,"isodigit should be 0 for a");
}

void t_isodigit_0x62()
{
    Assert(isodigit(98)  == 0 ,"isodigit should be 0 for b");
}

void t_isodigit_0x63()
{
    Assert(isodigit(99)  == 0 ,"isodigit should be 0 for c");
}

void t_isodigit_0x64()
{
    Assert(isodigit(100)  == 0 ,"isodigit should be 0 for d");
}

void t_isodigit_0x65()
{
    Assert(isodigit(101)  == 0 ,"isodigit should be 0 for e");
}

void t_isodigit_0x66()
{
    Assert(isodigit(102)  == 0 ,"isodigit should be 0 for f");
}

void t_isodigit_0x67()
{
    Assert(isodigit(103)  == 0 ,"isodigit should be 0 for g");
}

void t_isodigit_0x68()
{
    Assert(isodigit(104)  == 0 ,"isodigit should be 0 for h");
}

void t_isodigit_0x69()
{
    Assert(isodigit(105)  == 0 ,"isodigit should be 0 for i");
}

void t_isodigit_0x6a()
{
    Assert(isodigit(106)  == 0 ,"isodigit should be 0 for j");
}

void t_isodigit_0x6b()
{
    Assert(isodigit(107)  == 0 ,"isodigit should be 0 for k");
}

void t_isodigit_0x6c()
{
    Assert(isodigit(108)  == 0 ,"isodigit should be 0 for l");
}

void t_isodigit_0x6d()
{
    Assert(isodigit(109)  == 0 ,"isodigit should be 0 for m");
}

void t_isodigit_0x6e()
{
    Assert(isodigit(110)  == 0 ,"isodigit should be 0 for n");
}

void t_isodigit_0x6f()
{
    Assert(isodigit(111)  == 0 ,"isodigit should be 0 for o");
}

void t_isodigit_0x70()
{
    Assert(isodigit(112)  == 0 ,"isodigit should be 0 for p");
}

void t_isodigit_0x71()
{
    Assert(isodigit(113)  == 0 ,"isodigit should be 0 for q");
}

void t_isodigit_0x72()
{
    Assert(isodigit(114)  == 0 ,"isodigit should be 0 for r");
}

void t_isodigit_0x73()
{
    Assert(isodigit(115)  == 0 ,"isodigit should be 0 for s");
}

void t_isodigit_0x74()
{
    Assert(isodigit(116)  == 0 ,"isodigit should be 0 for t");
}

void t_isodigit_0x75()
{
    Assert(isodigit(117)  == 0 ,"isodigit should be 0 for u");
}

void t_isodigit_0x76()
{
    Assert(isodigit(118)  == 0 ,"isodigit should be 0 for v");
}

void t_isodigit_0x77()
{
    Assert(isodigit(119)  == 0 ,"isodigit should be 0 for w");
}

void t_isodigit_0x78()
{
    Assert(isodigit(120)  == 0 ,"isodigit should be 0 for x");
}

void t_isodigit_0x79()
{
    Assert(isodigit(121)  == 0 ,"isodigit should be 0 for y");
}

void t_isodigit_0x7a()
{
    Assert(isodigit(122)  == 0 ,"isodigit should be 0 for z");
}

void t_isodigit_0x7b()
{
    Assert(isodigit(123)  == 0 ,"isodigit should be 0 for {");
}

void t_isodigit_0x7c()
{
    Assert(isodigit(124)  == 0 ,"isodigit should be 0 for |");
}

void t_isodigit_0x7d()
{
    Assert(isodigit(125)  == 0 ,"isodigit should be 0 for }");
}

void t_isodigit_0x7e()
{
    Assert(isodigit(126)  == 0 ,"isodigit should be 0 for ~");
}

void t_isodigit_0x7f()
{
    Assert(isodigit(127)  == 0 ,"isodigit should be 0 for 0x7f");
}

void t_isodigit_0x80()
{
    Assert(isodigit(128)  == 0 ,"isodigit should be 0 for 0x80");
}

void t_isodigit_0x81()
{
    Assert(isodigit(129)  == 0 ,"isodigit should be 0 for 0x81");
}

void t_isodigit_0x82()
{
    Assert(isodigit(130)  == 0 ,"isodigit should be 0 for 0x82");
}

void t_isodigit_0x83()
{
    Assert(isodigit(131)  == 0 ,"isodigit should be 0 for 0x83");
}

void t_isodigit_0x84()
{
    Assert(isodigit(132)  == 0 ,"isodigit should be 0 for 0x84");
}

void t_isodigit_0x85()
{
    Assert(isodigit(133)  == 0 ,"isodigit should be 0 for 0x85");
}

void t_isodigit_0x86()
{
    Assert(isodigit(134)  == 0 ,"isodigit should be 0 for 0x86");
}

void t_isodigit_0x87()
{
    Assert(isodigit(135)  == 0 ,"isodigit should be 0 for 0x87");
}

void t_isodigit_0x88()
{
    Assert(isodigit(136)  == 0 ,"isodigit should be 0 for 0x88");
}

void t_isodigit_0x89()
{
    Assert(isodigit(137)  == 0 ,"isodigit should be 0 for 0x89");
}

void t_isodigit_0x8a()
{
    Assert(isodigit(138)  == 0 ,"isodigit should be 0 for 0x8a");
}

void t_isodigit_0x8b()
{
    Assert(isodigit(139)  == 0 ,"isodigit should be 0 for 0x8b");
}

void t_isodigit_0x8c()
{
    Assert(isodigit(140)  == 0 ,"isodigit should be 0 for 0x8c");
}

void t_isodigit_0x8d()
{
    Assert(isodigit(141)  == 0 ,"isodigit should be 0 for 0x8d");
}

void t_isodigit_0x8e()
{
    Assert(isodigit(142)  == 0 ,"isodigit should be 0 for 0x8e");
}

void t_isodigit_0x8f()
{
    Assert(isodigit(143)  == 0 ,"isodigit should be 0 for 0x8f");
}

void t_isodigit_0x90()
{
    Assert(isodigit(144)  == 0 ,"isodigit should be 0 for 0x90");
}

void t_isodigit_0x91()
{
    Assert(isodigit(145)  == 0 ,"isodigit should be 0 for 0x91");
}

void t_isodigit_0x92()
{
    Assert(isodigit(146)  == 0 ,"isodigit should be 0 for 0x92");
}

void t_isodigit_0x93()
{
    Assert(isodigit(147)  == 0 ,"isodigit should be 0 for 0x93");
}

void t_isodigit_0x94()
{
    Assert(isodigit(148)  == 0 ,"isodigit should be 0 for 0x94");
}

void t_isodigit_0x95()
{
    Assert(isodigit(149)  == 0 ,"isodigit should be 0 for 0x95");
}

void t_isodigit_0x96()
{
    Assert(isodigit(150)  == 0 ,"isodigit should be 0 for 0x96");
}

void t_isodigit_0x97()
{
    Assert(isodigit(151)  == 0 ,"isodigit should be 0 for 0x97");
}

void t_isodigit_0x98()
{
    Assert(isodigit(152)  == 0 ,"isodigit should be 0 for 0x98");
}

void t_isodigit_0x99()
{
    Assert(isodigit(153)  == 0 ,"isodigit should be 0 for 0x99");
}

void t_isodigit_0x9a()
{
    Assert(isodigit(154)  == 0 ,"isodigit should be 0 for 0x9a");
}

void t_isodigit_0x9b()
{
    Assert(isodigit(155)  == 0 ,"isodigit should be 0 for 0x9b");
}

void t_isodigit_0x9c()
{
    Assert(isodigit(156)  == 0 ,"isodigit should be 0 for 0x9c");
}

void t_isodigit_0x9d()
{
    Assert(isodigit(157)  == 0 ,"isodigit should be 0 for 0x9d");
}

void t_isodigit_0x9e()
{
    Assert(isodigit(158)  == 0 ,"isodigit should be 0 for 0x9e");
}

void t_isodigit_0x9f()
{
    Assert(isodigit(159)  == 0 ,"isodigit should be 0 for 0x9f");
}

void t_isodigit_0xa0()
{
    Assert(isodigit(160)  == 0 ,"isodigit should be 0 for 0xa0");
}

void t_isodigit_0xa1()
{
    Assert(isodigit(161)  == 0 ,"isodigit should be 0 for 0xa1");
}

void t_isodigit_0xa2()
{
    Assert(isodigit(162)  == 0 ,"isodigit should be 0 for 0xa2");
}

void t_isodigit_0xa3()
{
    Assert(isodigit(163)  == 0 ,"isodigit should be 0 for 0xa3");
}

void t_isodigit_0xa4()
{
    Assert(isodigit(164)  == 0 ,"isodigit should be 0 for 0xa4");
}

void t_isodigit_0xa5()
{
    Assert(isodigit(165)  == 0 ,"isodigit should be 0 for 0xa5");
}

void t_isodigit_0xa6()
{
    Assert(isodigit(166)  == 0 ,"isodigit should be 0 for 0xa6");
}

void t_isodigit_0xa7()
{
    Assert(isodigit(167)  == 0 ,"isodigit should be 0 for 0xa7");
}

void t_isodigit_0xa8()
{
    Assert(isodigit(168)  == 0 ,"isodigit should be 0 for 0xa8");
}

void t_isodigit_0xa9()
{
    Assert(isodigit(169)  == 0 ,"isodigit should be 0 for 0xa9");
}

void t_isodigit_0xaa()
{
    Assert(isodigit(170)  == 0 ,"isodigit should be 0 for 0xaa");
}

void t_isodigit_0xab()
{
    Assert(isodigit(171)  == 0 ,"isodigit should be 0 for 0xab");
}

void t_isodigit_0xac()
{
    Assert(isodigit(172)  == 0 ,"isodigit should be 0 for 0xac");
}

void t_isodigit_0xad()
{
    Assert(isodigit(173)  == 0 ,"isodigit should be 0 for 0xad");
}

void t_isodigit_0xae()
{
    Assert(isodigit(174)  == 0 ,"isodigit should be 0 for 0xae");
}

void t_isodigit_0xaf()
{
    Assert(isodigit(175)  == 0 ,"isodigit should be 0 for 0xaf");
}

void t_isodigit_0xb0()
{
    Assert(isodigit(176)  == 0 ,"isodigit should be 0 for 0xb0");
}

void t_isodigit_0xb1()
{
    Assert(isodigit(177)  == 0 ,"isodigit should be 0 for 0xb1");
}

void t_isodigit_0xb2()
{
    Assert(isodigit(178)  == 0 ,"isodigit should be 0 for 0xb2");
}

void t_isodigit_0xb3()
{
    Assert(isodigit(179)  == 0 ,"isodigit should be 0 for 0xb3");
}

void t_isodigit_0xb4()
{
    Assert(isodigit(180)  == 0 ,"isodigit should be 0 for 0xb4");
}

void t_isodigit_0xb5()
{
    Assert(isodigit(181)  == 0 ,"isodigit should be 0 for 0xb5");
}

void t_isodigit_0xb6()
{
    Assert(isodigit(182)  == 0 ,"isodigit should be 0 for 0xb6");
}

void t_isodigit_0xb7()
{
    Assert(isodigit(183)  == 0 ,"isodigit should be 0 for 0xb7");
}

void t_isodigit_0xb8()
{
    Assert(isodigit(184)  == 0 ,"isodigit should be 0 for 0xb8");
}

void t_isodigit_0xb9()
{
    Assert(isodigit(185)  == 0 ,"isodigit should be 0 for 0xb9");
}

void t_isodigit_0xba()
{
    Assert(isodigit(186)  == 0 ,"isodigit should be 0 for 0xba");
}

void t_isodigit_0xbb()
{
    Assert(isodigit(187)  == 0 ,"isodigit should be 0 for 0xbb");
}

void t_isodigit_0xbc()
{
    Assert(isodigit(188)  == 0 ,"isodigit should be 0 for 0xbc");
}

void t_isodigit_0xbd()
{
    Assert(isodigit(189)  == 0 ,"isodigit should be 0 for 0xbd");
}

void t_isodigit_0xbe()
{
    Assert(isodigit(190)  == 0 ,"isodigit should be 0 for 0xbe");
}

void t_isodigit_0xbf()
{
    Assert(isodigit(191)  == 0 ,"isodigit should be 0 for 0xbf");
}

void t_isodigit_0xc0()
{
    Assert(isodigit(192)  == 0 ,"isodigit should be 0 for 0xc0");
}

void t_isodigit_0xc1()
{
    Assert(isodigit(193)  == 0 ,"isodigit should be 0 for 0xc1");
}

void t_isodigit_0xc2()
{
    Assert(isodigit(194)  == 0 ,"isodigit should be 0 for 0xc2");
}

void t_isodigit_0xc3()
{
    Assert(isodigit(195)  == 0 ,"isodigit should be 0 for 0xc3");
}

void t_isodigit_0xc4()
{
    Assert(isodigit(196)  == 0 ,"isodigit should be 0 for 0xc4");
}

void t_isodigit_0xc5()
{
    Assert(isodigit(197)  == 0 ,"isodigit should be 0 for 0xc5");
}

void t_isodigit_0xc6()
{
    Assert(isodigit(198)  == 0 ,"isodigit should be 0 for 0xc6");
}

void t_isodigit_0xc7()
{
    Assert(isodigit(199)  == 0 ,"isodigit should be 0 for 0xc7");
}

void t_isodigit_0xc8()
{
    Assert(isodigit(200)  == 0 ,"isodigit should be 0 for 0xc8");
}

void t_isodigit_0xc9()
{
    Assert(isodigit(201)  == 0 ,"isodigit should be 0 for 0xc9");
}

void t_isodigit_0xca()
{
    Assert(isodigit(202)  == 0 ,"isodigit should be 0 for 0xca");
}

void t_isodigit_0xcb()
{
    Assert(isodigit(203)  == 0 ,"isodigit should be 0 for 0xcb");
}

void t_isodigit_0xcc()
{
    Assert(isodigit(204)  == 0 ,"isodigit should be 0 for 0xcc");
}

void t_isodigit_0xcd()
{
    Assert(isodigit(205)  == 0 ,"isodigit should be 0 for 0xcd");
}

void t_isodigit_0xce()
{
    Assert(isodigit(206)  == 0 ,"isodigit should be 0 for 0xce");
}

void t_isodigit_0xcf()
{
    Assert(isodigit(207)  == 0 ,"isodigit should be 0 for 0xcf");
}

void t_isodigit_0xd0()
{
    Assert(isodigit(208)  == 0 ,"isodigit should be 0 for 0xd0");
}

void t_isodigit_0xd1()
{
    Assert(isodigit(209)  == 0 ,"isodigit should be 0 for 0xd1");
}

void t_isodigit_0xd2()
{
    Assert(isodigit(210)  == 0 ,"isodigit should be 0 for 0xd2");
}

void t_isodigit_0xd3()
{
    Assert(isodigit(211)  == 0 ,"isodigit should be 0 for 0xd3");
}

void t_isodigit_0xd4()
{
    Assert(isodigit(212)  == 0 ,"isodigit should be 0 for 0xd4");
}

void t_isodigit_0xd5()
{
    Assert(isodigit(213)  == 0 ,"isodigit should be 0 for 0xd5");
}

void t_isodigit_0xd6()
{
    Assert(isodigit(214)  == 0 ,"isodigit should be 0 for 0xd6");
}

void t_isodigit_0xd7()
{
    Assert(isodigit(215)  == 0 ,"isodigit should be 0 for 0xd7");
}

void t_isodigit_0xd8()
{
    Assert(isodigit(216)  == 0 ,"isodigit should be 0 for 0xd8");
}

void t_isodigit_0xd9()
{
    Assert(isodigit(217)  == 0 ,"isodigit should be 0 for 0xd9");
}

void t_isodigit_0xda()
{
    Assert(isodigit(218)  == 0 ,"isodigit should be 0 for 0xda");
}

void t_isodigit_0xdb()
{
    Assert(isodigit(219)  == 0 ,"isodigit should be 0 for 0xdb");
}

void t_isodigit_0xdc()
{
    Assert(isodigit(220)  == 0 ,"isodigit should be 0 for 0xdc");
}

void t_isodigit_0xdd()
{
    Assert(isodigit(221)  == 0 ,"isodigit should be 0 for 0xdd");
}

void t_isodigit_0xde()
{
    Assert(isodigit(222)  == 0 ,"isodigit should be 0 for 0xde");
}

void t_isodigit_0xdf()
{
    Assert(isodigit(223)  == 0 ,"isodigit should be 0 for 0xdf");
}

void t_isodigit_0xe0()
{
    Assert(isodigit(224)  == 0 ,"isodigit should be 0 for 0xe0");
}

void t_isodigit_0xe1()
{
    Assert(isodigit(225)  == 0 ,"isodigit should be 0 for 0xe1");
}

void t_isodigit_0xe2()
{
    Assert(isodigit(226)  == 0 ,"isodigit should be 0 for 0xe2");
}

void t_isodigit_0xe3()
{
    Assert(isodigit(227)  == 0 ,"isodigit should be 0 for 0xe3");
}

void t_isodigit_0xe4()
{
    Assert(isodigit(228)  == 0 ,"isodigit should be 0 for 0xe4");
}

void t_isodigit_0xe5()
{
    Assert(isodigit(229)  == 0 ,"isodigit should be 0 for 0xe5");
}

void t_isodigit_0xe6()
{
    Assert(isodigit(230)  == 0 ,"isodigit should be 0 for 0xe6");
}

void t_isodigit_0xe7()
{
    Assert(isodigit(231)  == 0 ,"isodigit should be 0 for 0xe7");
}

void t_isodigit_0xe8()
{
    Assert(isodigit(232)  == 0 ,"isodigit should be 0 for 0xe8");
}

void t_isodigit_0xe9()
{
    Assert(isodigit(233)  == 0 ,"isodigit should be 0 for 0xe9");
}

void t_isodigit_0xea()
{
    Assert(isodigit(234)  == 0 ,"isodigit should be 0 for 0xea");
}

void t_isodigit_0xeb()
{
    Assert(isodigit(235)  == 0 ,"isodigit should be 0 for 0xeb");
}

void t_isodigit_0xec()
{
    Assert(isodigit(236)  == 0 ,"isodigit should be 0 for 0xec");
}

void t_isodigit_0xed()
{
    Assert(isodigit(237)  == 0 ,"isodigit should be 0 for 0xed");
}

void t_isodigit_0xee()
{
    Assert(isodigit(238)  == 0 ,"isodigit should be 0 for 0xee");
}

void t_isodigit_0xef()
{
    Assert(isodigit(239)  == 0 ,"isodigit should be 0 for 0xef");
}

void t_isodigit_0xf0()
{
    Assert(isodigit(240)  == 0 ,"isodigit should be 0 for 0xf0");
}

void t_isodigit_0xf1()
{
    Assert(isodigit(241)  == 0 ,"isodigit should be 0 for 0xf1");
}

void t_isodigit_0xf2()
{
    Assert(isodigit(242)  == 0 ,"isodigit should be 0 for 0xf2");
}

void t_isodigit_0xf3()
{
    Assert(isodigit(243)  == 0 ,"isodigit should be 0 for 0xf3");
}

void t_isodigit_0xf4()
{
    Assert(isodigit(244)  == 0 ,"isodigit should be 0 for 0xf4");
}

void t_isodigit_0xf5()
{
    Assert(isodigit(245)  == 0 ,"isodigit should be 0 for 0xf5");
}

void t_isodigit_0xf6()
{
    Assert(isodigit(246)  == 0 ,"isodigit should be 0 for 0xf6");
}

void t_isodigit_0xf7()
{
    Assert(isodigit(247)  == 0 ,"isodigit should be 0 for 0xf7");
}

void t_isodigit_0xf8()
{
    Assert(isodigit(248)  == 0 ,"isodigit should be 0 for 0xf8");
}

void t_isodigit_0xf9()
{
    Assert(isodigit(249)  == 0 ,"isodigit should be 0 for 0xf9");
}

void t_isodigit_0xfa()
{
    Assert(isodigit(250)  == 0 ,"isodigit should be 0 for 0xfa");
}

void t_isodigit_0xfb()
{
    Assert(isodigit(251)  == 0 ,"isodigit should be 0 for 0xfb");
}

void t_isodigit_0xfc()
{
    Assert(isodigit(252)  == 0 ,"isodigit should be 0 for 0xfc");
}

void t_isodigit_0xfd()
{
    Assert(isodigit(253)  == 0 ,"isodigit should be 0 for 0xfd");
}

void t_isodigit_0xfe()
{
    Assert(isodigit(254)  == 0 ,"isodigit should be 0 for 0xfe");
}

void t_isodigit_0xff()
{
    Assert(isodigit(255)  == 0 ,"isodigit should be 0 for 0xff");
}



int test_isodigit()
{
    suite_setup("isodigit");
    suite_add_test(t_isodigit_0x00);
    suite_add_test(t_isodigit_0x01);
    suite_add_test(t_isodigit_0x02);
    suite_add_test(t_isodigit_0x03);
    suite_add_test(t_isodigit_0x04);
    suite_add_test(t_isodigit_0x05);
    suite_add_test(t_isodigit_0x06);
    suite_add_test(t_isodigit_0x07);
    suite_add_test(t_isodigit_0x08);
    suite_add_test(t_isodigit_0x09);
    suite_add_test(t_isodigit_0x0a);
    suite_add_test(t_isodigit_0x0b);
    suite_add_test(t_isodigit_0x0c);
    suite_add_test(t_isodigit_0x0d);
    suite_add_test(t_isodigit_0x0e);
    suite_add_test(t_isodigit_0x0f);
    suite_add_test(t_isodigit_0x10);
    suite_add_test(t_isodigit_0x11);
    suite_add_test(t_isodigit_0x12);
    suite_add_test(t_isodigit_0x13);
    suite_add_test(t_isodigit_0x14);
    suite_add_test(t_isodigit_0x15);
    suite_add_test(t_isodigit_0x16);
    suite_add_test(t_isodigit_0x17);
    suite_add_test(t_isodigit_0x18);
    suite_add_test(t_isodigit_0x19);
    suite_add_test(t_isodigit_0x1a);
    suite_add_test(t_isodigit_0x1b);
    suite_add_test(t_isodigit_0x1c);
    suite_add_test(t_isodigit_0x1d);
    suite_add_test(t_isodigit_0x1e);
    suite_add_test(t_isodigit_0x1f);
    suite_add_test(t_isodigit_0x20);
    suite_add_test(t_isodigit_0x21);
    suite_add_test(t_isodigit_0x22);
    suite_add_test(t_isodigit_0x23);
    suite_add_test(t_isodigit_0x24);
    suite_add_test(t_isodigit_0x25);
    suite_add_test(t_isodigit_0x26);
    suite_add_test(t_isodigit_0x27);
    suite_add_test(t_isodigit_0x28);
    suite_add_test(t_isodigit_0x29);
    suite_add_test(t_isodigit_0x2a);
    suite_add_test(t_isodigit_0x2b);
    suite_add_test(t_isodigit_0x2c);
    suite_add_test(t_isodigit_0x2d);
    suite_add_test(t_isodigit_0x2e);
    suite_add_test(t_isodigit_0x2f);
    suite_add_test(t_isodigit_0x30);
    suite_add_test(t_isodigit_0x31);
    suite_add_test(t_isodigit_0x32);
    suite_add_test(t_isodigit_0x33);
    suite_add_test(t_isodigit_0x34);
    suite_add_test(t_isodigit_0x35);
    suite_add_test(t_isodigit_0x36);
    suite_add_test(t_isodigit_0x37);
    suite_add_test(t_isodigit_0x38);
    suite_add_test(t_isodigit_0x39);
    suite_add_test(t_isodigit_0x3a);
    suite_add_test(t_isodigit_0x3b);
    suite_add_test(t_isodigit_0x3c);
    suite_add_test(t_isodigit_0x3d);
    suite_add_test(t_isodigit_0x3e);
    suite_add_test(t_isodigit_0x3f);
    suite_add_test(t_isodigit_0x40);
    suite_add_test(t_isodigit_0x41);
    suite_add_test(t_isodigit_0x42);
    suite_add_test(t_isodigit_0x43);
    suite_add_test(t_isodigit_0x44);
    suite_add_test(t_isodigit_0x45);
    suite_add_test(t_isodigit_0x46);
    suite_add_test(t_isodigit_0x47);
    suite_add_test(t_isodigit_0x48);
    suite_add_test(t_isodigit_0x49);
    suite_add_test(t_isodigit_0x4a);
    suite_add_test(t_isodigit_0x4b);
    suite_add_test(t_isodigit_0x4c);
    suite_add_test(t_isodigit_0x4d);
    suite_add_test(t_isodigit_0x4e);
    suite_add_test(t_isodigit_0x4f);
    suite_add_test(t_isodigit_0x50);
    suite_add_test(t_isodigit_0x51);
    suite_add_test(t_isodigit_0x52);
    suite_add_test(t_isodigit_0x53);
    suite_add_test(t_isodigit_0x54);
    suite_add_test(t_isodigit_0x55);
    suite_add_test(t_isodigit_0x56);
    suite_add_test(t_isodigit_0x57);
    suite_add_test(t_isodigit_0x58);
    suite_add_test(t_isodigit_0x59);
    suite_add_test(t_isodigit_0x5a);
    suite_add_test(t_isodigit_0x5b);
    suite_add_test(t_isodigit_0x5c);
    suite_add_test(t_isodigit_0x5d);
    suite_add_test(t_isodigit_0x5e);
    suite_add_test(t_isodigit_0x5f);
    suite_add_test(t_isodigit_0x60);
    suite_add_test(t_isodigit_0x61);
    suite_add_test(t_isodigit_0x62);
    suite_add_test(t_isodigit_0x63);
    suite_add_test(t_isodigit_0x64);
    suite_add_test(t_isodigit_0x65);
    suite_add_test(t_isodigit_0x66);
    suite_add_test(t_isodigit_0x67);
    suite_add_test(t_isodigit_0x68);
    suite_add_test(t_isodigit_0x69);
    suite_add_test(t_isodigit_0x6a);
    suite_add_test(t_isodigit_0x6b);
    suite_add_test(t_isodigit_0x6c);
    suite_add_test(t_isodigit_0x6d);
    suite_add_test(t_isodigit_0x6e);
    suite_add_test(t_isodigit_0x6f);
    suite_add_test(t_isodigit_0x70);
    suite_add_test(t_isodigit_0x71);
    suite_add_test(t_isodigit_0x72);
    suite_add_test(t_isodigit_0x73);
    suite_add_test(t_isodigit_0x74);
    suite_add_test(t_isodigit_0x75);
    suite_add_test(t_isodigit_0x76);
    suite_add_test(t_isodigit_0x77);
    suite_add_test(t_isodigit_0x78);
    suite_add_test(t_isodigit_0x79);
    suite_add_test(t_isodigit_0x7a);
    suite_add_test(t_isodigit_0x7b);
    suite_add_test(t_isodigit_0x7c);
    suite_add_test(t_isodigit_0x7d);
    suite_add_test(t_isodigit_0x7e);
    suite_add_test(t_isodigit_0x7f);
    suite_add_test(t_isodigit_0x80);
    suite_add_test(t_isodigit_0x81);
    suite_add_test(t_isodigit_0x82);
    suite_add_test(t_isodigit_0x83);
    suite_add_test(t_isodigit_0x84);
    suite_add_test(t_isodigit_0x85);
    suite_add_test(t_isodigit_0x86);
    suite_add_test(t_isodigit_0x87);
    suite_add_test(t_isodigit_0x88);
    suite_add_test(t_isodigit_0x89);
    suite_add_test(t_isodigit_0x8a);
    suite_add_test(t_isodigit_0x8b);
    suite_add_test(t_isodigit_0x8c);
    suite_add_test(t_isodigit_0x8d);
    suite_add_test(t_isodigit_0x8e);
    suite_add_test(t_isodigit_0x8f);
    suite_add_test(t_isodigit_0x90);
    suite_add_test(t_isodigit_0x91);
    suite_add_test(t_isodigit_0x92);
    suite_add_test(t_isodigit_0x93);
    suite_add_test(t_isodigit_0x94);
    suite_add_test(t_isodigit_0x95);
    suite_add_test(t_isodigit_0x96);
    suite_add_test(t_isodigit_0x97);
    suite_add_test(t_isodigit_0x98);
    suite_add_test(t_isodigit_0x99);
    suite_add_test(t_isodigit_0x9a);
    suite_add_test(t_isodigit_0x9b);
    suite_add_test(t_isodigit_0x9c);
    suite_add_test(t_isodigit_0x9d);
    suite_add_test(t_isodigit_0x9e);
    suite_add_test(t_isodigit_0x9f);
    suite_add_test(t_isodigit_0xa0);
    suite_add_test(t_isodigit_0xa1);
    suite_add_test(t_isodigit_0xa2);
    suite_add_test(t_isodigit_0xa3);
    suite_add_test(t_isodigit_0xa4);
    suite_add_test(t_isodigit_0xa5);
    suite_add_test(t_isodigit_0xa6);
    suite_add_test(t_isodigit_0xa7);
    suite_add_test(t_isodigit_0xa8);
    suite_add_test(t_isodigit_0xa9);
    suite_add_test(t_isodigit_0xaa);
    suite_add_test(t_isodigit_0xab);
    suite_add_test(t_isodigit_0xac);
    suite_add_test(t_isodigit_0xad);
    suite_add_test(t_isodigit_0xae);
    suite_add_test(t_isodigit_0xaf);
    suite_add_test(t_isodigit_0xb0);
    suite_add_test(t_isodigit_0xb1);
    suite_add_test(t_isodigit_0xb2);
    suite_add_test(t_isodigit_0xb3);
    suite_add_test(t_isodigit_0xb4);
    suite_add_test(t_isodigit_0xb5);
    suite_add_test(t_isodigit_0xb6);
    suite_add_test(t_isodigit_0xb7);
    suite_add_test(t_isodigit_0xb8);
    suite_add_test(t_isodigit_0xb9);
    suite_add_test(t_isodigit_0xba);
    suite_add_test(t_isodigit_0xbb);
    suite_add_test(t_isodigit_0xbc);
    suite_add_test(t_isodigit_0xbd);
    suite_add_test(t_isodigit_0xbe);
    suite_add_test(t_isodigit_0xbf);
    suite_add_test(t_isodigit_0xc0);
    suite_add_test(t_isodigit_0xc1);
    suite_add_test(t_isodigit_0xc2);
    suite_add_test(t_isodigit_0xc3);
    suite_add_test(t_isodigit_0xc4);
    suite_add_test(t_isodigit_0xc5);
    suite_add_test(t_isodigit_0xc6);
    suite_add_test(t_isodigit_0xc7);
    suite_add_test(t_isodigit_0xc8);
    suite_add_test(t_isodigit_0xc9);
    suite_add_test(t_isodigit_0xca);
    suite_add_test(t_isodigit_0xcb);
    suite_add_test(t_isodigit_0xcc);
    suite_add_test(t_isodigit_0xcd);
    suite_add_test(t_isodigit_0xce);
    suite_add_test(t_isodigit_0xcf);
    suite_add_test(t_isodigit_0xd0);
    suite_add_test(t_isodigit_0xd1);
    suite_add_test(t_isodigit_0xd2);
    suite_add_test(t_isodigit_0xd3);
    suite_add_test(t_isodigit_0xd4);
    suite_add_test(t_isodigit_0xd5);
    suite_add_test(t_isodigit_0xd6);
    suite_add_test(t_isodigit_0xd7);
    suite_add_test(t_isodigit_0xd8);
    suite_add_test(t_isodigit_0xd9);
    suite_add_test(t_isodigit_0xda);
    suite_add_test(t_isodigit_0xdb);
    suite_add_test(t_isodigit_0xdc);
    suite_add_test(t_isodigit_0xdd);
    suite_add_test(t_isodigit_0xde);
    suite_add_test(t_isodigit_0xdf);
    suite_add_test(t_isodigit_0xe0);
    suite_add_test(t_isodigit_0xe1);
    suite_add_test(t_isodigit_0xe2);
    suite_add_test(t_isodigit_0xe3);
    suite_add_test(t_isodigit_0xe4);
    suite_add_test(t_isodigit_0xe5);
    suite_add_test(t_isodigit_0xe6);
    suite_add_test(t_isodigit_0xe7);
    suite_add_test(t_isodigit_0xe8);
    suite_add_test(t_isodigit_0xe9);
    suite_add_test(t_isodigit_0xea);
    suite_add_test(t_isodigit_0xeb);
    suite_add_test(t_isodigit_0xec);
    suite_add_test(t_isodigit_0xed);
    suite_add_test(t_isodigit_0xee);
    suite_add_test(t_isodigit_0xef);
    suite_add_test(t_isodigit_0xf0);
    suite_add_test(t_isodigit_0xf1);
    suite_add_test(t_isodigit_0xf2);
    suite_add_test(t_isodigit_0xf3);
    suite_add_test(t_isodigit_0xf4);
    suite_add_test(t_isodigit_0xf5);
    suite_add_test(t_isodigit_0xf6);
    suite_add_test(t_isodigit_0xf7);
    suite_add_test(t_isodigit_0xf8);
    suite_add_test(t_isodigit_0xf9);
    suite_add_test(t_isodigit_0xfa);
    suite_add_test(t_isodigit_0xfb);
    suite_add_test(t_isodigit_0xfc);
    suite_add_test(t_isodigit_0xfd);
    suite_add_test(t_isodigit_0xfe);
    suite_add_test(t_isodigit_0xff);
     return suite_run();
}
