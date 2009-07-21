
#include "ctype_test.h"
void t_isbdigit_0x00()
{
    Assert(isbdigit(0)  == 0 ,"isbdigit should be 0 for 0x00");
}

void t_isbdigit_0x01()
{
    Assert(isbdigit(1)  == 0 ,"isbdigit should be 0 for 0x01");
}

void t_isbdigit_0x02()
{
    Assert(isbdigit(2)  == 0 ,"isbdigit should be 0 for 0x02");
}

void t_isbdigit_0x03()
{
    Assert(isbdigit(3)  == 0 ,"isbdigit should be 0 for 0x03");
}

void t_isbdigit_0x04()
{
    Assert(isbdigit(4)  == 0 ,"isbdigit should be 0 for 0x04");
}

void t_isbdigit_0x05()
{
    Assert(isbdigit(5)  == 0 ,"isbdigit should be 0 for 0x05");
}

void t_isbdigit_0x06()
{
    Assert(isbdigit(6)  == 0 ,"isbdigit should be 0 for 0x06");
}

void t_isbdigit_0x07()
{
    Assert(isbdigit(7)  == 0 ,"isbdigit should be 0 for 0x07");
}

void t_isbdigit_0x08()
{
    Assert(isbdigit(8)  == 0 ,"isbdigit should be 0 for 0x08");
}

void t_isbdigit_0x09()
{
    Assert(isbdigit(9)  == 0 ,"isbdigit should be 0 for 0x09");
}

void t_isbdigit_0x0a()
{
    Assert(isbdigit(10)  == 0 ,"isbdigit should be 0 for 0x0a");
}

void t_isbdigit_0x0b()
{
    Assert(isbdigit(11)  == 0 ,"isbdigit should be 0 for 0x0b");
}

void t_isbdigit_0x0c()
{
    Assert(isbdigit(12)  == 0 ,"isbdigit should be 0 for 0x0c");
}

void t_isbdigit_0x0d()
{
    Assert(isbdigit(13)  == 0 ,"isbdigit should be 0 for 0x0d");
}

void t_isbdigit_0x0e()
{
    Assert(isbdigit(14)  == 0 ,"isbdigit should be 0 for 0x0e");
}

void t_isbdigit_0x0f()
{
    Assert(isbdigit(15)  == 0 ,"isbdigit should be 0 for 0x0f");
}

void t_isbdigit_0x10()
{
    Assert(isbdigit(16)  == 0 ,"isbdigit should be 0 for 0x10");
}

void t_isbdigit_0x11()
{
    Assert(isbdigit(17)  == 0 ,"isbdigit should be 0 for 0x11");
}

void t_isbdigit_0x12()
{
    Assert(isbdigit(18)  == 0 ,"isbdigit should be 0 for 0x12");
}

void t_isbdigit_0x13()
{
    Assert(isbdigit(19)  == 0 ,"isbdigit should be 0 for 0x13");
}

void t_isbdigit_0x14()
{
    Assert(isbdigit(20)  == 0 ,"isbdigit should be 0 for 0x14");
}

void t_isbdigit_0x15()
{
    Assert(isbdigit(21)  == 0 ,"isbdigit should be 0 for 0x15");
}

void t_isbdigit_0x16()
{
    Assert(isbdigit(22)  == 0 ,"isbdigit should be 0 for 0x16");
}

void t_isbdigit_0x17()
{
    Assert(isbdigit(23)  == 0 ,"isbdigit should be 0 for 0x17");
}

void t_isbdigit_0x18()
{
    Assert(isbdigit(24)  == 0 ,"isbdigit should be 0 for 0x18");
}

void t_isbdigit_0x19()
{
    Assert(isbdigit(25)  == 0 ,"isbdigit should be 0 for 0x19");
}

void t_isbdigit_0x1a()
{
    Assert(isbdigit(26)  == 0 ,"isbdigit should be 0 for 0x1a");
}

void t_isbdigit_0x1b()
{
    Assert(isbdigit(27)  == 0 ,"isbdigit should be 0 for 0x1b");
}

void t_isbdigit_0x1c()
{
    Assert(isbdigit(28)  == 0 ,"isbdigit should be 0 for 0x1c");
}

void t_isbdigit_0x1d()
{
    Assert(isbdigit(29)  == 0 ,"isbdigit should be 0 for 0x1d");
}

void t_isbdigit_0x1e()
{
    Assert(isbdigit(30)  == 0 ,"isbdigit should be 0 for 0x1e");
}

void t_isbdigit_0x1f()
{
    Assert(isbdigit(31)  == 0 ,"isbdigit should be 0 for 0x1f");
}

void t_isbdigit_0x20()
{
    Assert(isbdigit(32)  == 0 ,"isbdigit should be 0 for  ");
}

void t_isbdigit_0x21()
{
    Assert(isbdigit(33)  == 0 ,"isbdigit should be 0 for !");
}

void t_isbdigit_0x22()
{
    Assert(isbdigit(34)  == 0 ,"isbdigit should be 0 for 0x22");
}

void t_isbdigit_0x23()
{
    Assert(isbdigit(35)  == 0 ,"isbdigit should be 0 for #");
}

void t_isbdigit_0x24()
{
    Assert(isbdigit(36)  == 0 ,"isbdigit should be 0 for $");
}

void t_isbdigit_0x25()
{
    Assert(isbdigit(37)  == 0 ,"isbdigit should be 0 for %");
}

void t_isbdigit_0x26()
{
    Assert(isbdigit(38)  == 0 ,"isbdigit should be 0 for &");
}

void t_isbdigit_0x27()
{
    Assert(isbdigit(39)  == 0 ,"isbdigit should be 0 for '");
}

void t_isbdigit_0x28()
{
    Assert(isbdigit(40)  == 0 ,"isbdigit should be 0 for (");
}

void t_isbdigit_0x29()
{
    Assert(isbdigit(41)  == 0 ,"isbdigit should be 0 for )");
}

void t_isbdigit_0x2a()
{
    Assert(isbdigit(42)  == 0 ,"isbdigit should be 0 for *");
}

void t_isbdigit_0x2b()
{
    Assert(isbdigit(43)  == 0 ,"isbdigit should be 0 for +");
}

void t_isbdigit_0x2c()
{
    Assert(isbdigit(44)  == 0 ,"isbdigit should be 0 for ,");
}

void t_isbdigit_0x2d()
{
    Assert(isbdigit(45)  == 0 ,"isbdigit should be 0 for -");
}

void t_isbdigit_0x2e()
{
    Assert(isbdigit(46)  == 0 ,"isbdigit should be 0 for .");
}

void t_isbdigit_0x2f()
{
    Assert(isbdigit(47)  == 0 ,"isbdigit should be 0 for /");
}

void t_isbdigit_0x30()
{
    Assert(isbdigit(48) ,"isbdigit should be 1 for 0");
}

void t_isbdigit_0x31()
{
    Assert(isbdigit(49) ,"isbdigit should be 1 for 1");
}

void t_isbdigit_0x32()
{
    Assert(isbdigit(50) == 0 ,"isbdigit should be 0 for 2");
}

void t_isbdigit_0x33()
{
    Assert(isbdigit(51)  == 0,"isbdigit should be 0 for 3");
}

void t_isbdigit_0x34()
{
    Assert(isbdigit(52)  == 0,"isbdigit should be 0 for 4");
}

void t_isbdigit_0x35()
{
    Assert(isbdigit(53)  == 0,"isbdigit should be 0 for 5");
}

void t_isbdigit_0x36()
{
    Assert(isbdigit(54)  == 0,"isbdigit should be 0 for 6");
}

void t_isbdigit_0x37()
{
    Assert(isbdigit(55)  == 0,"isbdigit should be 0 for 7");
}

void t_isbdigit_0x38()
{
    Assert(isbdigit(56)  == 0,"isbdigit should be 0 for 8");
}

void t_isbdigit_0x39()
{
    Assert(isbdigit(57)  == 0,"isbdigit should be 0 for 9");
}

void t_isbdigit_0x3a()
{
    Assert(isbdigit(58)  == 0 ,"isbdigit should be 0 for :");
}

void t_isbdigit_0x3b()
{
    Assert(isbdigit(59)  == 0 ,"isbdigit should be 0 for ;");
}

void t_isbdigit_0x3c()
{
    Assert(isbdigit(60)  == 0 ,"isbdigit should be 0 for <");
}

void t_isbdigit_0x3d()
{
    Assert(isbdigit(61)  == 0 ,"isbdigit should be 0 for =");
}

void t_isbdigit_0x3e()
{
    Assert(isbdigit(62)  == 0 ,"isbdigit should be 0 for >");
}

void t_isbdigit_0x3f()
{
    Assert(isbdigit(63)  == 0 ,"isbdigit should be 0 for ?");
}

void t_isbdigit_0x40()
{
    Assert(isbdigit(64)  == 0 ,"isbdigit should be 0 for @");
}

void t_isbdigit_0x41()
{
    Assert(isbdigit(65)  == 0 ,"isbdigit should be 0 for A");
}

void t_isbdigit_0x42()
{
    Assert(isbdigit(66)  == 0 ,"isbdigit should be 0 for B");
}

void t_isbdigit_0x43()
{
    Assert(isbdigit(67)  == 0 ,"isbdigit should be 0 for C");
}

void t_isbdigit_0x44()
{
    Assert(isbdigit(68)  == 0 ,"isbdigit should be 0 for D");
}

void t_isbdigit_0x45()
{
    Assert(isbdigit(69)  == 0 ,"isbdigit should be 0 for E");
}

void t_isbdigit_0x46()
{
    Assert(isbdigit(70)  == 0 ,"isbdigit should be 0 for F");
}

void t_isbdigit_0x47()
{
    Assert(isbdigit(71)  == 0 ,"isbdigit should be 0 for G");
}

void t_isbdigit_0x48()
{
    Assert(isbdigit(72)  == 0 ,"isbdigit should be 0 for H");
}

void t_isbdigit_0x49()
{
    Assert(isbdigit(73)  == 0 ,"isbdigit should be 0 for I");
}

void t_isbdigit_0x4a()
{
    Assert(isbdigit(74)  == 0 ,"isbdigit should be 0 for J");
}

void t_isbdigit_0x4b()
{
    Assert(isbdigit(75)  == 0 ,"isbdigit should be 0 for K");
}

void t_isbdigit_0x4c()
{
    Assert(isbdigit(76)  == 0 ,"isbdigit should be 0 for L");
}

void t_isbdigit_0x4d()
{
    Assert(isbdigit(77)  == 0 ,"isbdigit should be 0 for M");
}

void t_isbdigit_0x4e()
{
    Assert(isbdigit(78)  == 0 ,"isbdigit should be 0 for N");
}

void t_isbdigit_0x4f()
{
    Assert(isbdigit(79)  == 0 ,"isbdigit should be 0 for O");
}

void t_isbdigit_0x50()
{
    Assert(isbdigit(80)  == 0 ,"isbdigit should be 0 for P");
}

void t_isbdigit_0x51()
{
    Assert(isbdigit(81)  == 0 ,"isbdigit should be 0 for Q");
}

void t_isbdigit_0x52()
{
    Assert(isbdigit(82)  == 0 ,"isbdigit should be 0 for R");
}

void t_isbdigit_0x53()
{
    Assert(isbdigit(83)  == 0 ,"isbdigit should be 0 for S");
}

void t_isbdigit_0x54()
{
    Assert(isbdigit(84)  == 0 ,"isbdigit should be 0 for T");
}

void t_isbdigit_0x55()
{
    Assert(isbdigit(85)  == 0 ,"isbdigit should be 0 for U");
}

void t_isbdigit_0x56()
{
    Assert(isbdigit(86)  == 0 ,"isbdigit should be 0 for V");
}

void t_isbdigit_0x57()
{
    Assert(isbdigit(87)  == 0 ,"isbdigit should be 0 for W");
}

void t_isbdigit_0x58()
{
    Assert(isbdigit(88)  == 0 ,"isbdigit should be 0 for X");
}

void t_isbdigit_0x59()
{
    Assert(isbdigit(89)  == 0 ,"isbdigit should be 0 for Y");
}

void t_isbdigit_0x5a()
{
    Assert(isbdigit(90)  == 0 ,"isbdigit should be 0 for Z");
}

void t_isbdigit_0x5b()
{
    Assert(isbdigit(91)  == 0 ,"isbdigit should be 0 for [");
}

void t_isbdigit_0x5c()
{
    Assert(isbdigit(92)  == 0 ,"isbdigit should be 0 for 0x5c");
}

void t_isbdigit_0x5d()
{
    Assert(isbdigit(93)  == 0 ,"isbdigit should be 0 for ]");
}

void t_isbdigit_0x5e()
{
    Assert(isbdigit(94)  == 0 ,"isbdigit should be 0 for ^");
}

void t_isbdigit_0x5f()
{
    Assert(isbdigit(95)  == 0 ,"isbdigit should be 0 for _");
}

void t_isbdigit_0x60()
{
    Assert(isbdigit(96)  == 0 ,"isbdigit should be 0 for `");
}

void t_isbdigit_0x61()
{
    Assert(isbdigit(97)  == 0 ,"isbdigit should be 0 for a");
}

void t_isbdigit_0x62()
{
    Assert(isbdigit(98)  == 0 ,"isbdigit should be 0 for b");
}

void t_isbdigit_0x63()
{
    Assert(isbdigit(99)  == 0 ,"isbdigit should be 0 for c");
}

void t_isbdigit_0x64()
{
    Assert(isbdigit(100)  == 0 ,"isbdigit should be 0 for d");
}

void t_isbdigit_0x65()
{
    Assert(isbdigit(101)  == 0 ,"isbdigit should be 0 for e");
}

void t_isbdigit_0x66()
{
    Assert(isbdigit(102)  == 0 ,"isbdigit should be 0 for f");
}

void t_isbdigit_0x67()
{
    Assert(isbdigit(103)  == 0 ,"isbdigit should be 0 for g");
}

void t_isbdigit_0x68()
{
    Assert(isbdigit(104)  == 0 ,"isbdigit should be 0 for h");
}

void t_isbdigit_0x69()
{
    Assert(isbdigit(105)  == 0 ,"isbdigit should be 0 for i");
}

void t_isbdigit_0x6a()
{
    Assert(isbdigit(106)  == 0 ,"isbdigit should be 0 for j");
}

void t_isbdigit_0x6b()
{
    Assert(isbdigit(107)  == 0 ,"isbdigit should be 0 for k");
}

void t_isbdigit_0x6c()
{
    Assert(isbdigit(108)  == 0 ,"isbdigit should be 0 for l");
}

void t_isbdigit_0x6d()
{
    Assert(isbdigit(109)  == 0 ,"isbdigit should be 0 for m");
}

void t_isbdigit_0x6e()
{
    Assert(isbdigit(110)  == 0 ,"isbdigit should be 0 for n");
}

void t_isbdigit_0x6f()
{
    Assert(isbdigit(111)  == 0 ,"isbdigit should be 0 for o");
}

void t_isbdigit_0x70()
{
    Assert(isbdigit(112)  == 0 ,"isbdigit should be 0 for p");
}

void t_isbdigit_0x71()
{
    Assert(isbdigit(113)  == 0 ,"isbdigit should be 0 for q");
}

void t_isbdigit_0x72()
{
    Assert(isbdigit(114)  == 0 ,"isbdigit should be 0 for r");
}

void t_isbdigit_0x73()
{
    Assert(isbdigit(115)  == 0 ,"isbdigit should be 0 for s");
}

void t_isbdigit_0x74()
{
    Assert(isbdigit(116)  == 0 ,"isbdigit should be 0 for t");
}

void t_isbdigit_0x75()
{
    Assert(isbdigit(117)  == 0 ,"isbdigit should be 0 for u");
}

void t_isbdigit_0x76()
{
    Assert(isbdigit(118)  == 0 ,"isbdigit should be 0 for v");
}

void t_isbdigit_0x77()
{
    Assert(isbdigit(119)  == 0 ,"isbdigit should be 0 for w");
}

void t_isbdigit_0x78()
{
    Assert(isbdigit(120)  == 0 ,"isbdigit should be 0 for x");
}

void t_isbdigit_0x79()
{
    Assert(isbdigit(121)  == 0 ,"isbdigit should be 0 for y");
}

void t_isbdigit_0x7a()
{
    Assert(isbdigit(122)  == 0 ,"isbdigit should be 0 for z");
}

void t_isbdigit_0x7b()
{
    Assert(isbdigit(123)  == 0 ,"isbdigit should be 0 for {");
}

void t_isbdigit_0x7c()
{
    Assert(isbdigit(124)  == 0 ,"isbdigit should be 0 for |");
}

void t_isbdigit_0x7d()
{
    Assert(isbdigit(125)  == 0 ,"isbdigit should be 0 for }");
}

void t_isbdigit_0x7e()
{
    Assert(isbdigit(126)  == 0 ,"isbdigit should be 0 for ~");
}

void t_isbdigit_0x7f()
{
    Assert(isbdigit(127)  == 0 ,"isbdigit should be 0 for 0x7f");
}

void t_isbdigit_0x80()
{
    Assert(isbdigit(128)  == 0 ,"isbdigit should be 0 for 0x80");
}

void t_isbdigit_0x81()
{
    Assert(isbdigit(129)  == 0 ,"isbdigit should be 0 for 0x81");
}

void t_isbdigit_0x82()
{
    Assert(isbdigit(130)  == 0 ,"isbdigit should be 0 for 0x82");
}

void t_isbdigit_0x83()
{
    Assert(isbdigit(131)  == 0 ,"isbdigit should be 0 for 0x83");
}

void t_isbdigit_0x84()
{
    Assert(isbdigit(132)  == 0 ,"isbdigit should be 0 for 0x84");
}

void t_isbdigit_0x85()
{
    Assert(isbdigit(133)  == 0 ,"isbdigit should be 0 for 0x85");
}

void t_isbdigit_0x86()
{
    Assert(isbdigit(134)  == 0 ,"isbdigit should be 0 for 0x86");
}

void t_isbdigit_0x87()
{
    Assert(isbdigit(135)  == 0 ,"isbdigit should be 0 for 0x87");
}

void t_isbdigit_0x88()
{
    Assert(isbdigit(136)  == 0 ,"isbdigit should be 0 for 0x88");
}

void t_isbdigit_0x89()
{
    Assert(isbdigit(137)  == 0 ,"isbdigit should be 0 for 0x89");
}

void t_isbdigit_0x8a()
{
    Assert(isbdigit(138)  == 0 ,"isbdigit should be 0 for 0x8a");
}

void t_isbdigit_0x8b()
{
    Assert(isbdigit(139)  == 0 ,"isbdigit should be 0 for 0x8b");
}

void t_isbdigit_0x8c()
{
    Assert(isbdigit(140)  == 0 ,"isbdigit should be 0 for 0x8c");
}

void t_isbdigit_0x8d()
{
    Assert(isbdigit(141)  == 0 ,"isbdigit should be 0 for 0x8d");
}

void t_isbdigit_0x8e()
{
    Assert(isbdigit(142)  == 0 ,"isbdigit should be 0 for 0x8e");
}

void t_isbdigit_0x8f()
{
    Assert(isbdigit(143)  == 0 ,"isbdigit should be 0 for 0x8f");
}

void t_isbdigit_0x90()
{
    Assert(isbdigit(144)  == 0 ,"isbdigit should be 0 for 0x90");
}

void t_isbdigit_0x91()
{
    Assert(isbdigit(145)  == 0 ,"isbdigit should be 0 for 0x91");
}

void t_isbdigit_0x92()
{
    Assert(isbdigit(146)  == 0 ,"isbdigit should be 0 for 0x92");
}

void t_isbdigit_0x93()
{
    Assert(isbdigit(147)  == 0 ,"isbdigit should be 0 for 0x93");
}

void t_isbdigit_0x94()
{
    Assert(isbdigit(148)  == 0 ,"isbdigit should be 0 for 0x94");
}

void t_isbdigit_0x95()
{
    Assert(isbdigit(149)  == 0 ,"isbdigit should be 0 for 0x95");
}

void t_isbdigit_0x96()
{
    Assert(isbdigit(150)  == 0 ,"isbdigit should be 0 for 0x96");
}

void t_isbdigit_0x97()
{
    Assert(isbdigit(151)  == 0 ,"isbdigit should be 0 for 0x97");
}

void t_isbdigit_0x98()
{
    Assert(isbdigit(152)  == 0 ,"isbdigit should be 0 for 0x98");
}

void t_isbdigit_0x99()
{
    Assert(isbdigit(153)  == 0 ,"isbdigit should be 0 for 0x99");
}

void t_isbdigit_0x9a()
{
    Assert(isbdigit(154)  == 0 ,"isbdigit should be 0 for 0x9a");
}

void t_isbdigit_0x9b()
{
    Assert(isbdigit(155)  == 0 ,"isbdigit should be 0 for 0x9b");
}

void t_isbdigit_0x9c()
{
    Assert(isbdigit(156)  == 0 ,"isbdigit should be 0 for 0x9c");
}

void t_isbdigit_0x9d()
{
    Assert(isbdigit(157)  == 0 ,"isbdigit should be 0 for 0x9d");
}

void t_isbdigit_0x9e()
{
    Assert(isbdigit(158)  == 0 ,"isbdigit should be 0 for 0x9e");
}

void t_isbdigit_0x9f()
{
    Assert(isbdigit(159)  == 0 ,"isbdigit should be 0 for 0x9f");
}

void t_isbdigit_0xa0()
{
    Assert(isbdigit(160)  == 0 ,"isbdigit should be 0 for 0xa0");
}

void t_isbdigit_0xa1()
{
    Assert(isbdigit(161)  == 0 ,"isbdigit should be 0 for 0xa1");
}

void t_isbdigit_0xa2()
{
    Assert(isbdigit(162)  == 0 ,"isbdigit should be 0 for 0xa2");
}

void t_isbdigit_0xa3()
{
    Assert(isbdigit(163)  == 0 ,"isbdigit should be 0 for 0xa3");
}

void t_isbdigit_0xa4()
{
    Assert(isbdigit(164)  == 0 ,"isbdigit should be 0 for 0xa4");
}

void t_isbdigit_0xa5()
{
    Assert(isbdigit(165)  == 0 ,"isbdigit should be 0 for 0xa5");
}

void t_isbdigit_0xa6()
{
    Assert(isbdigit(166)  == 0 ,"isbdigit should be 0 for 0xa6");
}

void t_isbdigit_0xa7()
{
    Assert(isbdigit(167)  == 0 ,"isbdigit should be 0 for 0xa7");
}

void t_isbdigit_0xa8()
{
    Assert(isbdigit(168)  == 0 ,"isbdigit should be 0 for 0xa8");
}

void t_isbdigit_0xa9()
{
    Assert(isbdigit(169)  == 0 ,"isbdigit should be 0 for 0xa9");
}

void t_isbdigit_0xaa()
{
    Assert(isbdigit(170)  == 0 ,"isbdigit should be 0 for 0xaa");
}

void t_isbdigit_0xab()
{
    Assert(isbdigit(171)  == 0 ,"isbdigit should be 0 for 0xab");
}

void t_isbdigit_0xac()
{
    Assert(isbdigit(172)  == 0 ,"isbdigit should be 0 for 0xac");
}

void t_isbdigit_0xad()
{
    Assert(isbdigit(173)  == 0 ,"isbdigit should be 0 for 0xad");
}

void t_isbdigit_0xae()
{
    Assert(isbdigit(174)  == 0 ,"isbdigit should be 0 for 0xae");
}

void t_isbdigit_0xaf()
{
    Assert(isbdigit(175)  == 0 ,"isbdigit should be 0 for 0xaf");
}

void t_isbdigit_0xb0()
{
    Assert(isbdigit(176)  == 0 ,"isbdigit should be 0 for 0xb0");
}

void t_isbdigit_0xb1()
{
    Assert(isbdigit(177)  == 0 ,"isbdigit should be 0 for 0xb1");
}

void t_isbdigit_0xb2()
{
    Assert(isbdigit(178)  == 0 ,"isbdigit should be 0 for 0xb2");
}

void t_isbdigit_0xb3()
{
    Assert(isbdigit(179)  == 0 ,"isbdigit should be 0 for 0xb3");
}

void t_isbdigit_0xb4()
{
    Assert(isbdigit(180)  == 0 ,"isbdigit should be 0 for 0xb4");
}

void t_isbdigit_0xb5()
{
    Assert(isbdigit(181)  == 0 ,"isbdigit should be 0 for 0xb5");
}

void t_isbdigit_0xb6()
{
    Assert(isbdigit(182)  == 0 ,"isbdigit should be 0 for 0xb6");
}

void t_isbdigit_0xb7()
{
    Assert(isbdigit(183)  == 0 ,"isbdigit should be 0 for 0xb7");
}

void t_isbdigit_0xb8()
{
    Assert(isbdigit(184)  == 0 ,"isbdigit should be 0 for 0xb8");
}

void t_isbdigit_0xb9()
{
    Assert(isbdigit(185)  == 0 ,"isbdigit should be 0 for 0xb9");
}

void t_isbdigit_0xba()
{
    Assert(isbdigit(186)  == 0 ,"isbdigit should be 0 for 0xba");
}

void t_isbdigit_0xbb()
{
    Assert(isbdigit(187)  == 0 ,"isbdigit should be 0 for 0xbb");
}

void t_isbdigit_0xbc()
{
    Assert(isbdigit(188)  == 0 ,"isbdigit should be 0 for 0xbc");
}

void t_isbdigit_0xbd()
{
    Assert(isbdigit(189)  == 0 ,"isbdigit should be 0 for 0xbd");
}

void t_isbdigit_0xbe()
{
    Assert(isbdigit(190)  == 0 ,"isbdigit should be 0 for 0xbe");
}

void t_isbdigit_0xbf()
{
    Assert(isbdigit(191)  == 0 ,"isbdigit should be 0 for 0xbf");
}

void t_isbdigit_0xc0()
{
    Assert(isbdigit(192)  == 0 ,"isbdigit should be 0 for 0xc0");
}

void t_isbdigit_0xc1()
{
    Assert(isbdigit(193)  == 0 ,"isbdigit should be 0 for 0xc1");
}

void t_isbdigit_0xc2()
{
    Assert(isbdigit(194)  == 0 ,"isbdigit should be 0 for 0xc2");
}

void t_isbdigit_0xc3()
{
    Assert(isbdigit(195)  == 0 ,"isbdigit should be 0 for 0xc3");
}

void t_isbdigit_0xc4()
{
    Assert(isbdigit(196)  == 0 ,"isbdigit should be 0 for 0xc4");
}

void t_isbdigit_0xc5()
{
    Assert(isbdigit(197)  == 0 ,"isbdigit should be 0 for 0xc5");
}

void t_isbdigit_0xc6()
{
    Assert(isbdigit(198)  == 0 ,"isbdigit should be 0 for 0xc6");
}

void t_isbdigit_0xc7()
{
    Assert(isbdigit(199)  == 0 ,"isbdigit should be 0 for 0xc7");
}

void t_isbdigit_0xc8()
{
    Assert(isbdigit(200)  == 0 ,"isbdigit should be 0 for 0xc8");
}

void t_isbdigit_0xc9()
{
    Assert(isbdigit(201)  == 0 ,"isbdigit should be 0 for 0xc9");
}

void t_isbdigit_0xca()
{
    Assert(isbdigit(202)  == 0 ,"isbdigit should be 0 for 0xca");
}

void t_isbdigit_0xcb()
{
    Assert(isbdigit(203)  == 0 ,"isbdigit should be 0 for 0xcb");
}

void t_isbdigit_0xcc()
{
    Assert(isbdigit(204)  == 0 ,"isbdigit should be 0 for 0xcc");
}

void t_isbdigit_0xcd()
{
    Assert(isbdigit(205)  == 0 ,"isbdigit should be 0 for 0xcd");
}

void t_isbdigit_0xce()
{
    Assert(isbdigit(206)  == 0 ,"isbdigit should be 0 for 0xce");
}

void t_isbdigit_0xcf()
{
    Assert(isbdigit(207)  == 0 ,"isbdigit should be 0 for 0xcf");
}

void t_isbdigit_0xd0()
{
    Assert(isbdigit(208)  == 0 ,"isbdigit should be 0 for 0xd0");
}

void t_isbdigit_0xd1()
{
    Assert(isbdigit(209)  == 0 ,"isbdigit should be 0 for 0xd1");
}

void t_isbdigit_0xd2()
{
    Assert(isbdigit(210)  == 0 ,"isbdigit should be 0 for 0xd2");
}

void t_isbdigit_0xd3()
{
    Assert(isbdigit(211)  == 0 ,"isbdigit should be 0 for 0xd3");
}

void t_isbdigit_0xd4()
{
    Assert(isbdigit(212)  == 0 ,"isbdigit should be 0 for 0xd4");
}

void t_isbdigit_0xd5()
{
    Assert(isbdigit(213)  == 0 ,"isbdigit should be 0 for 0xd5");
}

void t_isbdigit_0xd6()
{
    Assert(isbdigit(214)  == 0 ,"isbdigit should be 0 for 0xd6");
}

void t_isbdigit_0xd7()
{
    Assert(isbdigit(215)  == 0 ,"isbdigit should be 0 for 0xd7");
}

void t_isbdigit_0xd8()
{
    Assert(isbdigit(216)  == 0 ,"isbdigit should be 0 for 0xd8");
}

void t_isbdigit_0xd9()
{
    Assert(isbdigit(217)  == 0 ,"isbdigit should be 0 for 0xd9");
}

void t_isbdigit_0xda()
{
    Assert(isbdigit(218)  == 0 ,"isbdigit should be 0 for 0xda");
}

void t_isbdigit_0xdb()
{
    Assert(isbdigit(219)  == 0 ,"isbdigit should be 0 for 0xdb");
}

void t_isbdigit_0xdc()
{
    Assert(isbdigit(220)  == 0 ,"isbdigit should be 0 for 0xdc");
}

void t_isbdigit_0xdd()
{
    Assert(isbdigit(221)  == 0 ,"isbdigit should be 0 for 0xdd");
}

void t_isbdigit_0xde()
{
    Assert(isbdigit(222)  == 0 ,"isbdigit should be 0 for 0xde");
}

void t_isbdigit_0xdf()
{
    Assert(isbdigit(223)  == 0 ,"isbdigit should be 0 for 0xdf");
}

void t_isbdigit_0xe0()
{
    Assert(isbdigit(224)  == 0 ,"isbdigit should be 0 for 0xe0");
}

void t_isbdigit_0xe1()
{
    Assert(isbdigit(225)  == 0 ,"isbdigit should be 0 for 0xe1");
}

void t_isbdigit_0xe2()
{
    Assert(isbdigit(226)  == 0 ,"isbdigit should be 0 for 0xe2");
}

void t_isbdigit_0xe3()
{
    Assert(isbdigit(227)  == 0 ,"isbdigit should be 0 for 0xe3");
}

void t_isbdigit_0xe4()
{
    Assert(isbdigit(228)  == 0 ,"isbdigit should be 0 for 0xe4");
}

void t_isbdigit_0xe5()
{
    Assert(isbdigit(229)  == 0 ,"isbdigit should be 0 for 0xe5");
}

void t_isbdigit_0xe6()
{
    Assert(isbdigit(230)  == 0 ,"isbdigit should be 0 for 0xe6");
}

void t_isbdigit_0xe7()
{
    Assert(isbdigit(231)  == 0 ,"isbdigit should be 0 for 0xe7");
}

void t_isbdigit_0xe8()
{
    Assert(isbdigit(232)  == 0 ,"isbdigit should be 0 for 0xe8");
}

void t_isbdigit_0xe9()
{
    Assert(isbdigit(233)  == 0 ,"isbdigit should be 0 for 0xe9");
}

void t_isbdigit_0xea()
{
    Assert(isbdigit(234)  == 0 ,"isbdigit should be 0 for 0xea");
}

void t_isbdigit_0xeb()
{
    Assert(isbdigit(235)  == 0 ,"isbdigit should be 0 for 0xeb");
}

void t_isbdigit_0xec()
{
    Assert(isbdigit(236)  == 0 ,"isbdigit should be 0 for 0xec");
}

void t_isbdigit_0xed()
{
    Assert(isbdigit(237)  == 0 ,"isbdigit should be 0 for 0xed");
}

void t_isbdigit_0xee()
{
    Assert(isbdigit(238)  == 0 ,"isbdigit should be 0 for 0xee");
}

void t_isbdigit_0xef()
{
    Assert(isbdigit(239)  == 0 ,"isbdigit should be 0 for 0xef");
}

void t_isbdigit_0xf0()
{
    Assert(isbdigit(240)  == 0 ,"isbdigit should be 0 for 0xf0");
}

void t_isbdigit_0xf1()
{
    Assert(isbdigit(241)  == 0 ,"isbdigit should be 0 for 0xf1");
}

void t_isbdigit_0xf2()
{
    Assert(isbdigit(242)  == 0 ,"isbdigit should be 0 for 0xf2");
}

void t_isbdigit_0xf3()
{
    Assert(isbdigit(243)  == 0 ,"isbdigit should be 0 for 0xf3");
}

void t_isbdigit_0xf4()
{
    Assert(isbdigit(244)  == 0 ,"isbdigit should be 0 for 0xf4");
}

void t_isbdigit_0xf5()
{
    Assert(isbdigit(245)  == 0 ,"isbdigit should be 0 for 0xf5");
}

void t_isbdigit_0xf6()
{
    Assert(isbdigit(246)  == 0 ,"isbdigit should be 0 for 0xf6");
}

void t_isbdigit_0xf7()
{
    Assert(isbdigit(247)  == 0 ,"isbdigit should be 0 for 0xf7");
}

void t_isbdigit_0xf8()
{
    Assert(isbdigit(248)  == 0 ,"isbdigit should be 0 for 0xf8");
}

void t_isbdigit_0xf9()
{
    Assert(isbdigit(249)  == 0 ,"isbdigit should be 0 for 0xf9");
}

void t_isbdigit_0xfa()
{
    Assert(isbdigit(250)  == 0 ,"isbdigit should be 0 for 0xfa");
}

void t_isbdigit_0xfb()
{
    Assert(isbdigit(251)  == 0 ,"isbdigit should be 0 for 0xfb");
}

void t_isbdigit_0xfc()
{
    Assert(isbdigit(252)  == 0 ,"isbdigit should be 0 for 0xfc");
}

void t_isbdigit_0xfd()
{
    Assert(isbdigit(253)  == 0 ,"isbdigit should be 0 for 0xfd");
}

void t_isbdigit_0xfe()
{
    Assert(isbdigit(254)  == 0 ,"isbdigit should be 0 for 0xfe");
}

void t_isbdigit_0xff()
{
    Assert(isbdigit(255)  == 0 ,"isbdigit should be 0 for 0xff");
}



int test_isbdigit()
{
    suite_setup("isbdigit");
    suite_add_test(t_isbdigit_0x00);
    suite_add_test(t_isbdigit_0x01);
    suite_add_test(t_isbdigit_0x02);
    suite_add_test(t_isbdigit_0x03);
    suite_add_test(t_isbdigit_0x04);
    suite_add_test(t_isbdigit_0x05);
    suite_add_test(t_isbdigit_0x06);
    suite_add_test(t_isbdigit_0x07);
    suite_add_test(t_isbdigit_0x08);
    suite_add_test(t_isbdigit_0x09);
    suite_add_test(t_isbdigit_0x0a);
    suite_add_test(t_isbdigit_0x0b);
    suite_add_test(t_isbdigit_0x0c);
    suite_add_test(t_isbdigit_0x0d);
    suite_add_test(t_isbdigit_0x0e);
    suite_add_test(t_isbdigit_0x0f);
    suite_add_test(t_isbdigit_0x10);
    suite_add_test(t_isbdigit_0x11);
    suite_add_test(t_isbdigit_0x12);
    suite_add_test(t_isbdigit_0x13);
    suite_add_test(t_isbdigit_0x14);
    suite_add_test(t_isbdigit_0x15);
    suite_add_test(t_isbdigit_0x16);
    suite_add_test(t_isbdigit_0x17);
    suite_add_test(t_isbdigit_0x18);
    suite_add_test(t_isbdigit_0x19);
    suite_add_test(t_isbdigit_0x1a);
    suite_add_test(t_isbdigit_0x1b);
    suite_add_test(t_isbdigit_0x1c);
    suite_add_test(t_isbdigit_0x1d);
    suite_add_test(t_isbdigit_0x1e);
    suite_add_test(t_isbdigit_0x1f);
    suite_add_test(t_isbdigit_0x20);
    suite_add_test(t_isbdigit_0x21);
    suite_add_test(t_isbdigit_0x22);
    suite_add_test(t_isbdigit_0x23);
    suite_add_test(t_isbdigit_0x24);
    suite_add_test(t_isbdigit_0x25);
    suite_add_test(t_isbdigit_0x26);
    suite_add_test(t_isbdigit_0x27);
    suite_add_test(t_isbdigit_0x28);
    suite_add_test(t_isbdigit_0x29);
    suite_add_test(t_isbdigit_0x2a);
    suite_add_test(t_isbdigit_0x2b);
    suite_add_test(t_isbdigit_0x2c);
    suite_add_test(t_isbdigit_0x2d);
    suite_add_test(t_isbdigit_0x2e);
    suite_add_test(t_isbdigit_0x2f);
    suite_add_test(t_isbdigit_0x30);
    suite_add_test(t_isbdigit_0x31);
    suite_add_test(t_isbdigit_0x32);
    suite_add_test(t_isbdigit_0x33);
    suite_add_test(t_isbdigit_0x34);
    suite_add_test(t_isbdigit_0x35);
    suite_add_test(t_isbdigit_0x36);
    suite_add_test(t_isbdigit_0x37);
    suite_add_test(t_isbdigit_0x38);
    suite_add_test(t_isbdigit_0x39);
    suite_add_test(t_isbdigit_0x3a);
    suite_add_test(t_isbdigit_0x3b);
    suite_add_test(t_isbdigit_0x3c);
    suite_add_test(t_isbdigit_0x3d);
    suite_add_test(t_isbdigit_0x3e);
    suite_add_test(t_isbdigit_0x3f);
    suite_add_test(t_isbdigit_0x40);
    suite_add_test(t_isbdigit_0x41);
    suite_add_test(t_isbdigit_0x42);
    suite_add_test(t_isbdigit_0x43);
    suite_add_test(t_isbdigit_0x44);
    suite_add_test(t_isbdigit_0x45);
    suite_add_test(t_isbdigit_0x46);
    suite_add_test(t_isbdigit_0x47);
    suite_add_test(t_isbdigit_0x48);
    suite_add_test(t_isbdigit_0x49);
    suite_add_test(t_isbdigit_0x4a);
    suite_add_test(t_isbdigit_0x4b);
    suite_add_test(t_isbdigit_0x4c);
    suite_add_test(t_isbdigit_0x4d);
    suite_add_test(t_isbdigit_0x4e);
    suite_add_test(t_isbdigit_0x4f);
    suite_add_test(t_isbdigit_0x50);
    suite_add_test(t_isbdigit_0x51);
    suite_add_test(t_isbdigit_0x52);
    suite_add_test(t_isbdigit_0x53);
    suite_add_test(t_isbdigit_0x54);
    suite_add_test(t_isbdigit_0x55);
    suite_add_test(t_isbdigit_0x56);
    suite_add_test(t_isbdigit_0x57);
    suite_add_test(t_isbdigit_0x58);
    suite_add_test(t_isbdigit_0x59);
    suite_add_test(t_isbdigit_0x5a);
    suite_add_test(t_isbdigit_0x5b);
    suite_add_test(t_isbdigit_0x5c);
    suite_add_test(t_isbdigit_0x5d);
    suite_add_test(t_isbdigit_0x5e);
    suite_add_test(t_isbdigit_0x5f);
    suite_add_test(t_isbdigit_0x60);
    suite_add_test(t_isbdigit_0x61);
    suite_add_test(t_isbdigit_0x62);
    suite_add_test(t_isbdigit_0x63);
    suite_add_test(t_isbdigit_0x64);
    suite_add_test(t_isbdigit_0x65);
    suite_add_test(t_isbdigit_0x66);
    suite_add_test(t_isbdigit_0x67);
    suite_add_test(t_isbdigit_0x68);
    suite_add_test(t_isbdigit_0x69);
    suite_add_test(t_isbdigit_0x6a);
    suite_add_test(t_isbdigit_0x6b);
    suite_add_test(t_isbdigit_0x6c);
    suite_add_test(t_isbdigit_0x6d);
    suite_add_test(t_isbdigit_0x6e);
    suite_add_test(t_isbdigit_0x6f);
    suite_add_test(t_isbdigit_0x70);
    suite_add_test(t_isbdigit_0x71);
    suite_add_test(t_isbdigit_0x72);
    suite_add_test(t_isbdigit_0x73);
    suite_add_test(t_isbdigit_0x74);
    suite_add_test(t_isbdigit_0x75);
    suite_add_test(t_isbdigit_0x76);
    suite_add_test(t_isbdigit_0x77);
    suite_add_test(t_isbdigit_0x78);
    suite_add_test(t_isbdigit_0x79);
    suite_add_test(t_isbdigit_0x7a);
    suite_add_test(t_isbdigit_0x7b);
    suite_add_test(t_isbdigit_0x7c);
    suite_add_test(t_isbdigit_0x7d);
    suite_add_test(t_isbdigit_0x7e);
    suite_add_test(t_isbdigit_0x7f);
    suite_add_test(t_isbdigit_0x80);
    suite_add_test(t_isbdigit_0x81);
    suite_add_test(t_isbdigit_0x82);
    suite_add_test(t_isbdigit_0x83);
    suite_add_test(t_isbdigit_0x84);
    suite_add_test(t_isbdigit_0x85);
    suite_add_test(t_isbdigit_0x86);
    suite_add_test(t_isbdigit_0x87);
    suite_add_test(t_isbdigit_0x88);
    suite_add_test(t_isbdigit_0x89);
    suite_add_test(t_isbdigit_0x8a);
    suite_add_test(t_isbdigit_0x8b);
    suite_add_test(t_isbdigit_0x8c);
    suite_add_test(t_isbdigit_0x8d);
    suite_add_test(t_isbdigit_0x8e);
    suite_add_test(t_isbdigit_0x8f);
    suite_add_test(t_isbdigit_0x90);
    suite_add_test(t_isbdigit_0x91);
    suite_add_test(t_isbdigit_0x92);
    suite_add_test(t_isbdigit_0x93);
    suite_add_test(t_isbdigit_0x94);
    suite_add_test(t_isbdigit_0x95);
    suite_add_test(t_isbdigit_0x96);
    suite_add_test(t_isbdigit_0x97);
    suite_add_test(t_isbdigit_0x98);
    suite_add_test(t_isbdigit_0x99);
    suite_add_test(t_isbdigit_0x9a);
    suite_add_test(t_isbdigit_0x9b);
    suite_add_test(t_isbdigit_0x9c);
    suite_add_test(t_isbdigit_0x9d);
    suite_add_test(t_isbdigit_0x9e);
    suite_add_test(t_isbdigit_0x9f);
    suite_add_test(t_isbdigit_0xa0);
    suite_add_test(t_isbdigit_0xa1);
    suite_add_test(t_isbdigit_0xa2);
    suite_add_test(t_isbdigit_0xa3);
    suite_add_test(t_isbdigit_0xa4);
    suite_add_test(t_isbdigit_0xa5);
    suite_add_test(t_isbdigit_0xa6);
    suite_add_test(t_isbdigit_0xa7);
    suite_add_test(t_isbdigit_0xa8);
    suite_add_test(t_isbdigit_0xa9);
    suite_add_test(t_isbdigit_0xaa);
    suite_add_test(t_isbdigit_0xab);
    suite_add_test(t_isbdigit_0xac);
    suite_add_test(t_isbdigit_0xad);
    suite_add_test(t_isbdigit_0xae);
    suite_add_test(t_isbdigit_0xaf);
    suite_add_test(t_isbdigit_0xb0);
    suite_add_test(t_isbdigit_0xb1);
    suite_add_test(t_isbdigit_0xb2);
    suite_add_test(t_isbdigit_0xb3);
    suite_add_test(t_isbdigit_0xb4);
    suite_add_test(t_isbdigit_0xb5);
    suite_add_test(t_isbdigit_0xb6);
    suite_add_test(t_isbdigit_0xb7);
    suite_add_test(t_isbdigit_0xb8);
    suite_add_test(t_isbdigit_0xb9);
    suite_add_test(t_isbdigit_0xba);
    suite_add_test(t_isbdigit_0xbb);
    suite_add_test(t_isbdigit_0xbc);
    suite_add_test(t_isbdigit_0xbd);
    suite_add_test(t_isbdigit_0xbe);
    suite_add_test(t_isbdigit_0xbf);
    suite_add_test(t_isbdigit_0xc0);
    suite_add_test(t_isbdigit_0xc1);
    suite_add_test(t_isbdigit_0xc2);
    suite_add_test(t_isbdigit_0xc3);
    suite_add_test(t_isbdigit_0xc4);
    suite_add_test(t_isbdigit_0xc5);
    suite_add_test(t_isbdigit_0xc6);
    suite_add_test(t_isbdigit_0xc7);
    suite_add_test(t_isbdigit_0xc8);
    suite_add_test(t_isbdigit_0xc9);
    suite_add_test(t_isbdigit_0xca);
    suite_add_test(t_isbdigit_0xcb);
    suite_add_test(t_isbdigit_0xcc);
    suite_add_test(t_isbdigit_0xcd);
    suite_add_test(t_isbdigit_0xce);
    suite_add_test(t_isbdigit_0xcf);
    suite_add_test(t_isbdigit_0xd0);
    suite_add_test(t_isbdigit_0xd1);
    suite_add_test(t_isbdigit_0xd2);
    suite_add_test(t_isbdigit_0xd3);
    suite_add_test(t_isbdigit_0xd4);
    suite_add_test(t_isbdigit_0xd5);
    suite_add_test(t_isbdigit_0xd6);
    suite_add_test(t_isbdigit_0xd7);
    suite_add_test(t_isbdigit_0xd8);
    suite_add_test(t_isbdigit_0xd9);
    suite_add_test(t_isbdigit_0xda);
    suite_add_test(t_isbdigit_0xdb);
    suite_add_test(t_isbdigit_0xdc);
    suite_add_test(t_isbdigit_0xdd);
    suite_add_test(t_isbdigit_0xde);
    suite_add_test(t_isbdigit_0xdf);
    suite_add_test(t_isbdigit_0xe0);
    suite_add_test(t_isbdigit_0xe1);
    suite_add_test(t_isbdigit_0xe2);
    suite_add_test(t_isbdigit_0xe3);
    suite_add_test(t_isbdigit_0xe4);
    suite_add_test(t_isbdigit_0xe5);
    suite_add_test(t_isbdigit_0xe6);
    suite_add_test(t_isbdigit_0xe7);
    suite_add_test(t_isbdigit_0xe8);
    suite_add_test(t_isbdigit_0xe9);
    suite_add_test(t_isbdigit_0xea);
    suite_add_test(t_isbdigit_0xeb);
    suite_add_test(t_isbdigit_0xec);
    suite_add_test(t_isbdigit_0xed);
    suite_add_test(t_isbdigit_0xee);
    suite_add_test(t_isbdigit_0xef);
    suite_add_test(t_isbdigit_0xf0);
    suite_add_test(t_isbdigit_0xf1);
    suite_add_test(t_isbdigit_0xf2);
    suite_add_test(t_isbdigit_0xf3);
    suite_add_test(t_isbdigit_0xf4);
    suite_add_test(t_isbdigit_0xf5);
    suite_add_test(t_isbdigit_0xf6);
    suite_add_test(t_isbdigit_0xf7);
    suite_add_test(t_isbdigit_0xf8);
    suite_add_test(t_isbdigit_0xf9);
    suite_add_test(t_isbdigit_0xfa);
    suite_add_test(t_isbdigit_0xfb);
    suite_add_test(t_isbdigit_0xfc);
    suite_add_test(t_isbdigit_0xfd);
    suite_add_test(t_isbdigit_0xfe);
    suite_add_test(t_isbdigit_0xff);
     return suite_run();
}
