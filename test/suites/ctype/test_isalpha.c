
#include "ctype_test.h"
void t_isalpha_0x00()
{
    Assert(isalpha(0)  == 0 ,"isalpha should be 0 for 0x00");
}

void t_isalpha_0x01()
{
    Assert(isalpha(1)  == 0 ,"isalpha should be 0 for 0x01");
}

void t_isalpha_0x02()
{
    Assert(isalpha(2)  == 0 ,"isalpha should be 0 for 0x02");
}

void t_isalpha_0x03()
{
    Assert(isalpha(3)  == 0 ,"isalpha should be 0 for 0x03");
}

void t_isalpha_0x04()
{
    Assert(isalpha(4)  == 0 ,"isalpha should be 0 for 0x04");
}

void t_isalpha_0x05()
{
    Assert(isalpha(5)  == 0 ,"isalpha should be 0 for 0x05");
}

void t_isalpha_0x06()
{
    Assert(isalpha(6)  == 0 ,"isalpha should be 0 for 0x06");
}

void t_isalpha_0x07()
{
    Assert(isalpha(7)  == 0 ,"isalpha should be 0 for 0x07");
}

void t_isalpha_0x08()
{
    Assert(isalpha(8)  == 0 ,"isalpha should be 0 for 0x08");
}

void t_isalpha_0x09()
{
    Assert(isalpha(9)  == 0 ,"isalpha should be 0 for 0x09");
}

void t_isalpha_0x0a()
{
    Assert(isalpha(10)  == 0 ,"isalpha should be 0 for 0x0a");
}

void t_isalpha_0x0b()
{
    Assert(isalpha(11)  == 0 ,"isalpha should be 0 for 0x0b");
}

void t_isalpha_0x0c()
{
    Assert(isalpha(12)  == 0 ,"isalpha should be 0 for 0x0c");
}

void t_isalpha_0x0d()
{
    Assert(isalpha(13)  == 0 ,"isalpha should be 0 for 0x0d");
}

void t_isalpha_0x0e()
{
    Assert(isalpha(14)  == 0 ,"isalpha should be 0 for 0x0e");
}

void t_isalpha_0x0f()
{
    Assert(isalpha(15)  == 0 ,"isalpha should be 0 for 0x0f");
}

void t_isalpha_0x10()
{
    Assert(isalpha(16)  == 0 ,"isalpha should be 0 for 0x10");
}

void t_isalpha_0x11()
{
    Assert(isalpha(17)  == 0 ,"isalpha should be 0 for 0x11");
}

void t_isalpha_0x12()
{
    Assert(isalpha(18)  == 0 ,"isalpha should be 0 for 0x12");
}

void t_isalpha_0x13()
{
    Assert(isalpha(19)  == 0 ,"isalpha should be 0 for 0x13");
}

void t_isalpha_0x14()
{
    Assert(isalpha(20)  == 0 ,"isalpha should be 0 for 0x14");
}

void t_isalpha_0x15()
{
    Assert(isalpha(21)  == 0 ,"isalpha should be 0 for 0x15");
}

void t_isalpha_0x16()
{
    Assert(isalpha(22)  == 0 ,"isalpha should be 0 for 0x16");
}

void t_isalpha_0x17()
{
    Assert(isalpha(23)  == 0 ,"isalpha should be 0 for 0x17");
}

void t_isalpha_0x18()
{
    Assert(isalpha(24)  == 0 ,"isalpha should be 0 for 0x18");
}

void t_isalpha_0x19()
{
    Assert(isalpha(25)  == 0 ,"isalpha should be 0 for 0x19");
}

void t_isalpha_0x1a()
{
    Assert(isalpha(26)  == 0 ,"isalpha should be 0 for 0x1a");
}

void t_isalpha_0x1b()
{
    Assert(isalpha(27)  == 0 ,"isalpha should be 0 for 0x1b");
}

void t_isalpha_0x1c()
{
    Assert(isalpha(28)  == 0 ,"isalpha should be 0 for 0x1c");
}

void t_isalpha_0x1d()
{
    Assert(isalpha(29)  == 0 ,"isalpha should be 0 for 0x1d");
}

void t_isalpha_0x1e()
{
    Assert(isalpha(30)  == 0 ,"isalpha should be 0 for 0x1e");
}

void t_isalpha_0x1f()
{
    Assert(isalpha(31)  == 0 ,"isalpha should be 0 for 0x1f");
}

void t_isalpha_0x20()
{
    Assert(isalpha(32)  == 0 ,"isalpha should be 0 for  ");
}

void t_isalpha_0x21()
{
    Assert(isalpha(33)  == 0 ,"isalpha should be 0 for !");
}

void t_isalpha_0x22()
{
    Assert(isalpha(34)  == 0 ,"isalpha should be 0 for 0x22");
}

void t_isalpha_0x23()
{
    Assert(isalpha(35)  == 0 ,"isalpha should be 0 for #");
}

void t_isalpha_0x24()
{
    Assert(isalpha(36)  == 0 ,"isalpha should be 0 for $");
}

void t_isalpha_0x25()
{
    Assert(isalpha(37)  == 0 ,"isalpha should be 0 for %");
}

void t_isalpha_0x26()
{
    Assert(isalpha(38)  == 0 ,"isalpha should be 0 for &");
}

void t_isalpha_0x27()
{
    Assert(isalpha(39)  == 0 ,"isalpha should be 0 for '");
}

void t_isalpha_0x28()
{
    Assert(isalpha(40)  == 0 ,"isalpha should be 0 for (");
}

void t_isalpha_0x29()
{
    Assert(isalpha(41)  == 0 ,"isalpha should be 0 for )");
}

void t_isalpha_0x2a()
{
    Assert(isalpha(42)  == 0 ,"isalpha should be 0 for *");
}

void t_isalpha_0x2b()
{
    Assert(isalpha(43)  == 0 ,"isalpha should be 0 for +");
}

void t_isalpha_0x2c()
{
    Assert(isalpha(44)  == 0 ,"isalpha should be 0 for ,");
}

void t_isalpha_0x2d()
{
    Assert(isalpha(45)  == 0 ,"isalpha should be 0 for -");
}

void t_isalpha_0x2e()
{
    Assert(isalpha(46)  == 0 ,"isalpha should be 0 for .");
}

void t_isalpha_0x2f()
{
    Assert(isalpha(47)  == 0 ,"isalpha should be 0 for /");
}

void t_isalpha_0x30()
{
    Assert(isalpha(48)  == 0 ,"isalpha should be 0 for 0");
}

void t_isalpha_0x31()
{
    Assert(isalpha(49)  == 0 ,"isalpha should be 0 for 1");
}

void t_isalpha_0x32()
{
    Assert(isalpha(50)  == 0 ,"isalpha should be 0 for 2");
}

void t_isalpha_0x33()
{
    Assert(isalpha(51)  == 0 ,"isalpha should be 0 for 3");
}

void t_isalpha_0x34()
{
    Assert(isalpha(52)  == 0 ,"isalpha should be 0 for 4");
}

void t_isalpha_0x35()
{
    Assert(isalpha(53)  == 0 ,"isalpha should be 0 for 5");
}

void t_isalpha_0x36()
{
    Assert(isalpha(54)  == 0 ,"isalpha should be 0 for 6");
}

void t_isalpha_0x37()
{
    Assert(isalpha(55)  == 0 ,"isalpha should be 0 for 7");
}

void t_isalpha_0x38()
{
    Assert(isalpha(56)  == 0 ,"isalpha should be 0 for 8");
}

void t_isalpha_0x39()
{
    Assert(isalpha(57)  == 0 ,"isalpha should be 0 for 9");
}

void t_isalpha_0x3a()
{
    Assert(isalpha(58)  == 0 ,"isalpha should be 0 for :");
}

void t_isalpha_0x3b()
{
    Assert(isalpha(59)  == 0 ,"isalpha should be 0 for ;");
}

void t_isalpha_0x3c()
{
    Assert(isalpha(60)  == 0 ,"isalpha should be 0 for <");
}

void t_isalpha_0x3d()
{
    Assert(isalpha(61)  == 0 ,"isalpha should be 0 for =");
}

void t_isalpha_0x3e()
{
    Assert(isalpha(62)  == 0 ,"isalpha should be 0 for >");
}

void t_isalpha_0x3f()
{
    Assert(isalpha(63)  == 0 ,"isalpha should be 0 for ?");
}

void t_isalpha_0x40()
{
    Assert(isalpha(64)  == 0 ,"isalpha should be 0 for @");
}

void t_isalpha_0x41()
{
    Assert(isalpha(65) ,"isalpha should be 1 for A");
}

void t_isalpha_0x42()
{
    Assert(isalpha(66) ,"isalpha should be 1 for B");
}

void t_isalpha_0x43()
{
    Assert(isalpha(67) ,"isalpha should be 1 for C");
}

void t_isalpha_0x44()
{
    Assert(isalpha(68) ,"isalpha should be 1 for D");
}

void t_isalpha_0x45()
{
    Assert(isalpha(69) ,"isalpha should be 1 for E");
}

void t_isalpha_0x46()
{
    Assert(isalpha(70) ,"isalpha should be 1 for F");
}

void t_isalpha_0x47()
{
    Assert(isalpha(71) ,"isalpha should be 1 for G");
}

void t_isalpha_0x48()
{
    Assert(isalpha(72) ,"isalpha should be 1 for H");
}

void t_isalpha_0x49()
{
    Assert(isalpha(73) ,"isalpha should be 1 for I");
}

void t_isalpha_0x4a()
{
    Assert(isalpha(74) ,"isalpha should be 1 for J");
}

void t_isalpha_0x4b()
{
    Assert(isalpha(75) ,"isalpha should be 1 for K");
}

void t_isalpha_0x4c()
{
    Assert(isalpha(76) ,"isalpha should be 1 for L");
}

void t_isalpha_0x4d()
{
    Assert(isalpha(77) ,"isalpha should be 1 for M");
}

void t_isalpha_0x4e()
{
    Assert(isalpha(78) ,"isalpha should be 1 for N");
}

void t_isalpha_0x4f()
{
    Assert(isalpha(79) ,"isalpha should be 1 for O");
}

void t_isalpha_0x50()
{
    Assert(isalpha(80) ,"isalpha should be 1 for P");
}

void t_isalpha_0x51()
{
    Assert(isalpha(81) ,"isalpha should be 1 for Q");
}

void t_isalpha_0x52()
{
    Assert(isalpha(82) ,"isalpha should be 1 for R");
}

void t_isalpha_0x53()
{
    Assert(isalpha(83) ,"isalpha should be 1 for S");
}

void t_isalpha_0x54()
{
    Assert(isalpha(84) ,"isalpha should be 1 for T");
}

void t_isalpha_0x55()
{
    Assert(isalpha(85) ,"isalpha should be 1 for U");
}

void t_isalpha_0x56()
{
    Assert(isalpha(86) ,"isalpha should be 1 for V");
}

void t_isalpha_0x57()
{
    Assert(isalpha(87) ,"isalpha should be 1 for W");
}

void t_isalpha_0x58()
{
    Assert(isalpha(88) ,"isalpha should be 1 for X");
}

void t_isalpha_0x59()
{
    Assert(isalpha(89) ,"isalpha should be 1 for Y");
}

void t_isalpha_0x5a()
{
    Assert(isalpha(90) ,"isalpha should be 1 for Z");
}

void t_isalpha_0x5b()
{
    Assert(isalpha(91)  == 0 ,"isalpha should be 0 for [");
}

void t_isalpha_0x5c()
{
    Assert(isalpha(92)  == 0 ,"isalpha should be 0 for 0x5c");
}

void t_isalpha_0x5d()
{
    Assert(isalpha(93)  == 0 ,"isalpha should be 0 for ]");
}

void t_isalpha_0x5e()
{
    Assert(isalpha(94)  == 0 ,"isalpha should be 0 for ^");
}

void t_isalpha_0x5f()
{
    Assert(isalpha(95)  == 0 ,"isalpha should be 0 for _");
}

void t_isalpha_0x60()
{
    Assert(isalpha(96)  == 0 ,"isalpha should be 0 for `");
}

void t_isalpha_0x61()
{
    Assert(isalpha(97) ,"isalpha should be 1 for a");
}

void t_isalpha_0x62()
{
    Assert(isalpha(98) ,"isalpha should be 1 for b");
}

void t_isalpha_0x63()
{
    Assert(isalpha(99) ,"isalpha should be 1 for c");
}

void t_isalpha_0x64()
{
    Assert(isalpha(100) ,"isalpha should be 1 for d");
}

void t_isalpha_0x65()
{
    Assert(isalpha(101) ,"isalpha should be 1 for e");
}

void t_isalpha_0x66()
{
    Assert(isalpha(102) ,"isalpha should be 1 for f");
}

void t_isalpha_0x67()
{
    Assert(isalpha(103) ,"isalpha should be 1 for g");
}

void t_isalpha_0x68()
{
    Assert(isalpha(104) ,"isalpha should be 1 for h");
}

void t_isalpha_0x69()
{
    Assert(isalpha(105) ,"isalpha should be 1 for i");
}

void t_isalpha_0x6a()
{
    Assert(isalpha(106) ,"isalpha should be 1 for j");
}

void t_isalpha_0x6b()
{
    Assert(isalpha(107) ,"isalpha should be 1 for k");
}

void t_isalpha_0x6c()
{
    Assert(isalpha(108) ,"isalpha should be 1 for l");
}

void t_isalpha_0x6d()
{
    Assert(isalpha(109) ,"isalpha should be 1 for m");
}

void t_isalpha_0x6e()
{
    Assert(isalpha(110) ,"isalpha should be 1 for n");
}

void t_isalpha_0x6f()
{
    Assert(isalpha(111) ,"isalpha should be 1 for o");
}

void t_isalpha_0x70()
{
    Assert(isalpha(112) ,"isalpha should be 1 for p");
}

void t_isalpha_0x71()
{
    Assert(isalpha(113) ,"isalpha should be 1 for q");
}

void t_isalpha_0x72()
{
    Assert(isalpha(114) ,"isalpha should be 1 for r");
}

void t_isalpha_0x73()
{
    Assert(isalpha(115) ,"isalpha should be 1 for s");
}

void t_isalpha_0x74()
{
    Assert(isalpha(116) ,"isalpha should be 1 for t");
}

void t_isalpha_0x75()
{
    Assert(isalpha(117) ,"isalpha should be 1 for u");
}

void t_isalpha_0x76()
{
    Assert(isalpha(118) ,"isalpha should be 1 for v");
}

void t_isalpha_0x77()
{
    Assert(isalpha(119) ,"isalpha should be 1 for w");
}

void t_isalpha_0x78()
{
    Assert(isalpha(120) ,"isalpha should be 1 for x");
}

void t_isalpha_0x79()
{
    Assert(isalpha(121) ,"isalpha should be 1 for y");
}

void t_isalpha_0x7a()
{
    Assert(isalpha(122) ,"isalpha should be 1 for z");
}

void t_isalpha_0x7b()
{
    Assert(isalpha(123)  == 0 ,"isalpha should be 0 for {");
}

void t_isalpha_0x7c()
{
    Assert(isalpha(124)  == 0 ,"isalpha should be 0 for |");
}

void t_isalpha_0x7d()
{
    Assert(isalpha(125)  == 0 ,"isalpha should be 0 for }");
}

void t_isalpha_0x7e()
{
    Assert(isalpha(126)  == 0 ,"isalpha should be 0 for ~");
}

void t_isalpha_0x7f()
{
    Assert(isalpha(127)  == 0 ,"isalpha should be 0 for 0x7f");
}

void t_isalpha_0x80()
{
    Assert(isalpha(128)  == 0 ,"isalpha should be 0 for 0x80");
}

void t_isalpha_0x81()
{
    Assert(isalpha(129)  == 0 ,"isalpha should be 0 for 0x81");
}

void t_isalpha_0x82()
{
    Assert(isalpha(130)  == 0 ,"isalpha should be 0 for 0x82");
}

void t_isalpha_0x83()
{
    Assert(isalpha(131)  == 0 ,"isalpha should be 0 for 0x83");
}

void t_isalpha_0x84()
{
    Assert(isalpha(132)  == 0 ,"isalpha should be 0 for 0x84");
}

void t_isalpha_0x85()
{
    Assert(isalpha(133)  == 0 ,"isalpha should be 0 for 0x85");
}

void t_isalpha_0x86()
{
    Assert(isalpha(134)  == 0 ,"isalpha should be 0 for 0x86");
}

void t_isalpha_0x87()
{
    Assert(isalpha(135)  == 0 ,"isalpha should be 0 for 0x87");
}

void t_isalpha_0x88()
{
    Assert(isalpha(136)  == 0 ,"isalpha should be 0 for 0x88");
}

void t_isalpha_0x89()
{
    Assert(isalpha(137)  == 0 ,"isalpha should be 0 for 0x89");
}

void t_isalpha_0x8a()
{
    Assert(isalpha(138)  == 0 ,"isalpha should be 0 for 0x8a");
}

void t_isalpha_0x8b()
{
    Assert(isalpha(139)  == 0 ,"isalpha should be 0 for 0x8b");
}

void t_isalpha_0x8c()
{
    Assert(isalpha(140)  == 0 ,"isalpha should be 0 for 0x8c");
}

void t_isalpha_0x8d()
{
    Assert(isalpha(141)  == 0 ,"isalpha should be 0 for 0x8d");
}

void t_isalpha_0x8e()
{
    Assert(isalpha(142)  == 0 ,"isalpha should be 0 for 0x8e");
}

void t_isalpha_0x8f()
{
    Assert(isalpha(143)  == 0 ,"isalpha should be 0 for 0x8f");
}

void t_isalpha_0x90()
{
    Assert(isalpha(144)  == 0 ,"isalpha should be 0 for 0x90");
}

void t_isalpha_0x91()
{
    Assert(isalpha(145)  == 0 ,"isalpha should be 0 for 0x91");
}

void t_isalpha_0x92()
{
    Assert(isalpha(146)  == 0 ,"isalpha should be 0 for 0x92");
}

void t_isalpha_0x93()
{
    Assert(isalpha(147)  == 0 ,"isalpha should be 0 for 0x93");
}

void t_isalpha_0x94()
{
    Assert(isalpha(148)  == 0 ,"isalpha should be 0 for 0x94");
}

void t_isalpha_0x95()
{
    Assert(isalpha(149)  == 0 ,"isalpha should be 0 for 0x95");
}

void t_isalpha_0x96()
{
    Assert(isalpha(150)  == 0 ,"isalpha should be 0 for 0x96");
}

void t_isalpha_0x97()
{
    Assert(isalpha(151)  == 0 ,"isalpha should be 0 for 0x97");
}

void t_isalpha_0x98()
{
    Assert(isalpha(152)  == 0 ,"isalpha should be 0 for 0x98");
}

void t_isalpha_0x99()
{
    Assert(isalpha(153)  == 0 ,"isalpha should be 0 for 0x99");
}

void t_isalpha_0x9a()
{
    Assert(isalpha(154)  == 0 ,"isalpha should be 0 for 0x9a");
}

void t_isalpha_0x9b()
{
    Assert(isalpha(155)  == 0 ,"isalpha should be 0 for 0x9b");
}

void t_isalpha_0x9c()
{
    Assert(isalpha(156)  == 0 ,"isalpha should be 0 for 0x9c");
}

void t_isalpha_0x9d()
{
    Assert(isalpha(157)  == 0 ,"isalpha should be 0 for 0x9d");
}

void t_isalpha_0x9e()
{
    Assert(isalpha(158)  == 0 ,"isalpha should be 0 for 0x9e");
}

void t_isalpha_0x9f()
{
    Assert(isalpha(159)  == 0 ,"isalpha should be 0 for 0x9f");
}

void t_isalpha_0xa0()
{
    Assert(isalpha(160)  == 0 ,"isalpha should be 0 for 0xa0");
}

void t_isalpha_0xa1()
{
    Assert(isalpha(161)  == 0 ,"isalpha should be 0 for 0xa1");
}

void t_isalpha_0xa2()
{
    Assert(isalpha(162)  == 0 ,"isalpha should be 0 for 0xa2");
}

void t_isalpha_0xa3()
{
    Assert(isalpha(163)  == 0 ,"isalpha should be 0 for 0xa3");
}

void t_isalpha_0xa4()
{
    Assert(isalpha(164)  == 0 ,"isalpha should be 0 for 0xa4");
}

void t_isalpha_0xa5()
{
    Assert(isalpha(165)  == 0 ,"isalpha should be 0 for 0xa5");
}

void t_isalpha_0xa6()
{
    Assert(isalpha(166)  == 0 ,"isalpha should be 0 for 0xa6");
}

void t_isalpha_0xa7()
{
    Assert(isalpha(167)  == 0 ,"isalpha should be 0 for 0xa7");
}

void t_isalpha_0xa8()
{
    Assert(isalpha(168)  == 0 ,"isalpha should be 0 for 0xa8");
}

void t_isalpha_0xa9()
{
    Assert(isalpha(169)  == 0 ,"isalpha should be 0 for 0xa9");
}

void t_isalpha_0xaa()
{
    Assert(isalpha(170)  == 0 ,"isalpha should be 0 for 0xaa");
}

void t_isalpha_0xab()
{
    Assert(isalpha(171)  == 0 ,"isalpha should be 0 for 0xab");
}

void t_isalpha_0xac()
{
    Assert(isalpha(172)  == 0 ,"isalpha should be 0 for 0xac");
}

void t_isalpha_0xad()
{
    Assert(isalpha(173)  == 0 ,"isalpha should be 0 for 0xad");
}

void t_isalpha_0xae()
{
    Assert(isalpha(174)  == 0 ,"isalpha should be 0 for 0xae");
}

void t_isalpha_0xaf()
{
    Assert(isalpha(175)  == 0 ,"isalpha should be 0 for 0xaf");
}

void t_isalpha_0xb0()
{
    Assert(isalpha(176)  == 0 ,"isalpha should be 0 for 0xb0");
}

void t_isalpha_0xb1()
{
    Assert(isalpha(177)  == 0 ,"isalpha should be 0 for 0xb1");
}

void t_isalpha_0xb2()
{
    Assert(isalpha(178)  == 0 ,"isalpha should be 0 for 0xb2");
}

void t_isalpha_0xb3()
{
    Assert(isalpha(179)  == 0 ,"isalpha should be 0 for 0xb3");
}

void t_isalpha_0xb4()
{
    Assert(isalpha(180)  == 0 ,"isalpha should be 0 for 0xb4");
}

void t_isalpha_0xb5()
{
    Assert(isalpha(181)  == 0 ,"isalpha should be 0 for 0xb5");
}

void t_isalpha_0xb6()
{
    Assert(isalpha(182)  == 0 ,"isalpha should be 0 for 0xb6");
}

void t_isalpha_0xb7()
{
    Assert(isalpha(183)  == 0 ,"isalpha should be 0 for 0xb7");
}

void t_isalpha_0xb8()
{
    Assert(isalpha(184)  == 0 ,"isalpha should be 0 for 0xb8");
}

void t_isalpha_0xb9()
{
    Assert(isalpha(185)  == 0 ,"isalpha should be 0 for 0xb9");
}

void t_isalpha_0xba()
{
    Assert(isalpha(186)  == 0 ,"isalpha should be 0 for 0xba");
}

void t_isalpha_0xbb()
{
    Assert(isalpha(187)  == 0 ,"isalpha should be 0 for 0xbb");
}

void t_isalpha_0xbc()
{
    Assert(isalpha(188)  == 0 ,"isalpha should be 0 for 0xbc");
}

void t_isalpha_0xbd()
{
    Assert(isalpha(189)  == 0 ,"isalpha should be 0 for 0xbd");
}

void t_isalpha_0xbe()
{
    Assert(isalpha(190)  == 0 ,"isalpha should be 0 for 0xbe");
}

void t_isalpha_0xbf()
{
    Assert(isalpha(191)  == 0 ,"isalpha should be 0 for 0xbf");
}

void t_isalpha_0xc0()
{
    Assert(isalpha(192)  == 0 ,"isalpha should be 0 for 0xc0");
}

void t_isalpha_0xc1()
{
    Assert(isalpha(193)  == 0 ,"isalpha should be 0 for 0xc1");
}

void t_isalpha_0xc2()
{
    Assert(isalpha(194)  == 0 ,"isalpha should be 0 for 0xc2");
}

void t_isalpha_0xc3()
{
    Assert(isalpha(195)  == 0 ,"isalpha should be 0 for 0xc3");
}

void t_isalpha_0xc4()
{
    Assert(isalpha(196)  == 0 ,"isalpha should be 0 for 0xc4");
}

void t_isalpha_0xc5()
{
    Assert(isalpha(197)  == 0 ,"isalpha should be 0 for 0xc5");
}

void t_isalpha_0xc6()
{
    Assert(isalpha(198)  == 0 ,"isalpha should be 0 for 0xc6");
}

void t_isalpha_0xc7()
{
    Assert(isalpha(199)  == 0 ,"isalpha should be 0 for 0xc7");
}

void t_isalpha_0xc8()
{
    Assert(isalpha(200)  == 0 ,"isalpha should be 0 for 0xc8");
}

void t_isalpha_0xc9()
{
    Assert(isalpha(201)  == 0 ,"isalpha should be 0 for 0xc9");
}

void t_isalpha_0xca()
{
    Assert(isalpha(202)  == 0 ,"isalpha should be 0 for 0xca");
}

void t_isalpha_0xcb()
{
    Assert(isalpha(203)  == 0 ,"isalpha should be 0 for 0xcb");
}

void t_isalpha_0xcc()
{
    Assert(isalpha(204)  == 0 ,"isalpha should be 0 for 0xcc");
}

void t_isalpha_0xcd()
{
    Assert(isalpha(205)  == 0 ,"isalpha should be 0 for 0xcd");
}

void t_isalpha_0xce()
{
    Assert(isalpha(206)  == 0 ,"isalpha should be 0 for 0xce");
}

void t_isalpha_0xcf()
{
    Assert(isalpha(207)  == 0 ,"isalpha should be 0 for 0xcf");
}

void t_isalpha_0xd0()
{
    Assert(isalpha(208)  == 0 ,"isalpha should be 0 for 0xd0");
}

void t_isalpha_0xd1()
{
    Assert(isalpha(209)  == 0 ,"isalpha should be 0 for 0xd1");
}

void t_isalpha_0xd2()
{
    Assert(isalpha(210)  == 0 ,"isalpha should be 0 for 0xd2");
}

void t_isalpha_0xd3()
{
    Assert(isalpha(211)  == 0 ,"isalpha should be 0 for 0xd3");
}

void t_isalpha_0xd4()
{
    Assert(isalpha(212)  == 0 ,"isalpha should be 0 for 0xd4");
}

void t_isalpha_0xd5()
{
    Assert(isalpha(213)  == 0 ,"isalpha should be 0 for 0xd5");
}

void t_isalpha_0xd6()
{
    Assert(isalpha(214)  == 0 ,"isalpha should be 0 for 0xd6");
}

void t_isalpha_0xd7()
{
    Assert(isalpha(215)  == 0 ,"isalpha should be 0 for 0xd7");
}

void t_isalpha_0xd8()
{
    Assert(isalpha(216)  == 0 ,"isalpha should be 0 for 0xd8");
}

void t_isalpha_0xd9()
{
    Assert(isalpha(217)  == 0 ,"isalpha should be 0 for 0xd9");
}

void t_isalpha_0xda()
{
    Assert(isalpha(218)  == 0 ,"isalpha should be 0 for 0xda");
}

void t_isalpha_0xdb()
{
    Assert(isalpha(219)  == 0 ,"isalpha should be 0 for 0xdb");
}

void t_isalpha_0xdc()
{
    Assert(isalpha(220)  == 0 ,"isalpha should be 0 for 0xdc");
}

void t_isalpha_0xdd()
{
    Assert(isalpha(221)  == 0 ,"isalpha should be 0 for 0xdd");
}

void t_isalpha_0xde()
{
    Assert(isalpha(222)  == 0 ,"isalpha should be 0 for 0xde");
}

void t_isalpha_0xdf()
{
    Assert(isalpha(223)  == 0 ,"isalpha should be 0 for 0xdf");
}

void t_isalpha_0xe0()
{
    Assert(isalpha(224)  == 0 ,"isalpha should be 0 for 0xe0");
}

void t_isalpha_0xe1()
{
    Assert(isalpha(225)  == 0 ,"isalpha should be 0 for 0xe1");
}

void t_isalpha_0xe2()
{
    Assert(isalpha(226)  == 0 ,"isalpha should be 0 for 0xe2");
}

void t_isalpha_0xe3()
{
    Assert(isalpha(227)  == 0 ,"isalpha should be 0 for 0xe3");
}

void t_isalpha_0xe4()
{
    Assert(isalpha(228)  == 0 ,"isalpha should be 0 for 0xe4");
}

void t_isalpha_0xe5()
{
    Assert(isalpha(229)  == 0 ,"isalpha should be 0 for 0xe5");
}

void t_isalpha_0xe6()
{
    Assert(isalpha(230)  == 0 ,"isalpha should be 0 for 0xe6");
}

void t_isalpha_0xe7()
{
    Assert(isalpha(231)  == 0 ,"isalpha should be 0 for 0xe7");
}

void t_isalpha_0xe8()
{
    Assert(isalpha(232)  == 0 ,"isalpha should be 0 for 0xe8");
}

void t_isalpha_0xe9()
{
    Assert(isalpha(233)  == 0 ,"isalpha should be 0 for 0xe9");
}

void t_isalpha_0xea()
{
    Assert(isalpha(234)  == 0 ,"isalpha should be 0 for 0xea");
}

void t_isalpha_0xeb()
{
    Assert(isalpha(235)  == 0 ,"isalpha should be 0 for 0xeb");
}

void t_isalpha_0xec()
{
    Assert(isalpha(236)  == 0 ,"isalpha should be 0 for 0xec");
}

void t_isalpha_0xed()
{
    Assert(isalpha(237)  == 0 ,"isalpha should be 0 for 0xed");
}

void t_isalpha_0xee()
{
    Assert(isalpha(238)  == 0 ,"isalpha should be 0 for 0xee");
}

void t_isalpha_0xef()
{
    Assert(isalpha(239)  == 0 ,"isalpha should be 0 for 0xef");
}

void t_isalpha_0xf0()
{
    Assert(isalpha(240)  == 0 ,"isalpha should be 0 for 0xf0");
}

void t_isalpha_0xf1()
{
    Assert(isalpha(241)  == 0 ,"isalpha should be 0 for 0xf1");
}

void t_isalpha_0xf2()
{
    Assert(isalpha(242)  == 0 ,"isalpha should be 0 for 0xf2");
}

void t_isalpha_0xf3()
{
    Assert(isalpha(243)  == 0 ,"isalpha should be 0 for 0xf3");
}

void t_isalpha_0xf4()
{
    Assert(isalpha(244)  == 0 ,"isalpha should be 0 for 0xf4");
}

void t_isalpha_0xf5()
{
    Assert(isalpha(245)  == 0 ,"isalpha should be 0 for 0xf5");
}

void t_isalpha_0xf6()
{
    Assert(isalpha(246)  == 0 ,"isalpha should be 0 for 0xf6");
}

void t_isalpha_0xf7()
{
    Assert(isalpha(247)  == 0 ,"isalpha should be 0 for 0xf7");
}

void t_isalpha_0xf8()
{
    Assert(isalpha(248)  == 0 ,"isalpha should be 0 for 0xf8");
}

void t_isalpha_0xf9()
{
    Assert(isalpha(249)  == 0 ,"isalpha should be 0 for 0xf9");
}

void t_isalpha_0xfa()
{
    Assert(isalpha(250)  == 0 ,"isalpha should be 0 for 0xfa");
}

void t_isalpha_0xfb()
{
    Assert(isalpha(251)  == 0 ,"isalpha should be 0 for 0xfb");
}

void t_isalpha_0xfc()
{
    Assert(isalpha(252)  == 0 ,"isalpha should be 0 for 0xfc");
}

void t_isalpha_0xfd()
{
    Assert(isalpha(253)  == 0 ,"isalpha should be 0 for 0xfd");
}

void t_isalpha_0xfe()
{
    Assert(isalpha(254)  == 0 ,"isalpha should be 0 for 0xfe");
}

void t_isalpha_0xff()
{
    Assert(isalpha(255)  == 0 ,"isalpha should be 0 for 0xff");
}



int test_isalpha()
{
    suite_setup("isalpha");
    suite_add_test(t_isalpha_0x00);
    suite_add_test(t_isalpha_0x01);
    suite_add_test(t_isalpha_0x02);
    suite_add_test(t_isalpha_0x03);
    suite_add_test(t_isalpha_0x04);
    suite_add_test(t_isalpha_0x05);
    suite_add_test(t_isalpha_0x06);
    suite_add_test(t_isalpha_0x07);
    suite_add_test(t_isalpha_0x08);
    suite_add_test(t_isalpha_0x09);
    suite_add_test(t_isalpha_0x0a);
    suite_add_test(t_isalpha_0x0b);
    suite_add_test(t_isalpha_0x0c);
    suite_add_test(t_isalpha_0x0d);
    suite_add_test(t_isalpha_0x0e);
    suite_add_test(t_isalpha_0x0f);
    suite_add_test(t_isalpha_0x10);
    suite_add_test(t_isalpha_0x11);
    suite_add_test(t_isalpha_0x12);
    suite_add_test(t_isalpha_0x13);
    suite_add_test(t_isalpha_0x14);
    suite_add_test(t_isalpha_0x15);
    suite_add_test(t_isalpha_0x16);
    suite_add_test(t_isalpha_0x17);
    suite_add_test(t_isalpha_0x18);
    suite_add_test(t_isalpha_0x19);
    suite_add_test(t_isalpha_0x1a);
    suite_add_test(t_isalpha_0x1b);
    suite_add_test(t_isalpha_0x1c);
    suite_add_test(t_isalpha_0x1d);
    suite_add_test(t_isalpha_0x1e);
    suite_add_test(t_isalpha_0x1f);
    suite_add_test(t_isalpha_0x20);
    suite_add_test(t_isalpha_0x21);
    suite_add_test(t_isalpha_0x22);
    suite_add_test(t_isalpha_0x23);
    suite_add_test(t_isalpha_0x24);
    suite_add_test(t_isalpha_0x25);
    suite_add_test(t_isalpha_0x26);
    suite_add_test(t_isalpha_0x27);
    suite_add_test(t_isalpha_0x28);
    suite_add_test(t_isalpha_0x29);
    suite_add_test(t_isalpha_0x2a);
    suite_add_test(t_isalpha_0x2b);
    suite_add_test(t_isalpha_0x2c);
    suite_add_test(t_isalpha_0x2d);
    suite_add_test(t_isalpha_0x2e);
    suite_add_test(t_isalpha_0x2f);
    suite_add_test(t_isalpha_0x30);
    suite_add_test(t_isalpha_0x31);
    suite_add_test(t_isalpha_0x32);
    suite_add_test(t_isalpha_0x33);
    suite_add_test(t_isalpha_0x34);
    suite_add_test(t_isalpha_0x35);
    suite_add_test(t_isalpha_0x36);
    suite_add_test(t_isalpha_0x37);
    suite_add_test(t_isalpha_0x38);
    suite_add_test(t_isalpha_0x39);
    suite_add_test(t_isalpha_0x3a);
    suite_add_test(t_isalpha_0x3b);
    suite_add_test(t_isalpha_0x3c);
    suite_add_test(t_isalpha_0x3d);
    suite_add_test(t_isalpha_0x3e);
    suite_add_test(t_isalpha_0x3f);
    suite_add_test(t_isalpha_0x40);
    suite_add_test(t_isalpha_0x41);
    suite_add_test(t_isalpha_0x42);
    suite_add_test(t_isalpha_0x43);
    suite_add_test(t_isalpha_0x44);
    suite_add_test(t_isalpha_0x45);
    suite_add_test(t_isalpha_0x46);
    suite_add_test(t_isalpha_0x47);
    suite_add_test(t_isalpha_0x48);
    suite_add_test(t_isalpha_0x49);
    suite_add_test(t_isalpha_0x4a);
    suite_add_test(t_isalpha_0x4b);
    suite_add_test(t_isalpha_0x4c);
    suite_add_test(t_isalpha_0x4d);
    suite_add_test(t_isalpha_0x4e);
    suite_add_test(t_isalpha_0x4f);
    suite_add_test(t_isalpha_0x50);
    suite_add_test(t_isalpha_0x51);
    suite_add_test(t_isalpha_0x52);
    suite_add_test(t_isalpha_0x53);
    suite_add_test(t_isalpha_0x54);
    suite_add_test(t_isalpha_0x55);
    suite_add_test(t_isalpha_0x56);
    suite_add_test(t_isalpha_0x57);
    suite_add_test(t_isalpha_0x58);
    suite_add_test(t_isalpha_0x59);
    suite_add_test(t_isalpha_0x5a);
    suite_add_test(t_isalpha_0x5b);
    suite_add_test(t_isalpha_0x5c);
    suite_add_test(t_isalpha_0x5d);
    suite_add_test(t_isalpha_0x5e);
    suite_add_test(t_isalpha_0x5f);
    suite_add_test(t_isalpha_0x60);
    suite_add_test(t_isalpha_0x61);
    suite_add_test(t_isalpha_0x62);
    suite_add_test(t_isalpha_0x63);
    suite_add_test(t_isalpha_0x64);
    suite_add_test(t_isalpha_0x65);
    suite_add_test(t_isalpha_0x66);
    suite_add_test(t_isalpha_0x67);
    suite_add_test(t_isalpha_0x68);
    suite_add_test(t_isalpha_0x69);
    suite_add_test(t_isalpha_0x6a);
    suite_add_test(t_isalpha_0x6b);
    suite_add_test(t_isalpha_0x6c);
    suite_add_test(t_isalpha_0x6d);
    suite_add_test(t_isalpha_0x6e);
    suite_add_test(t_isalpha_0x6f);
    suite_add_test(t_isalpha_0x70);
    suite_add_test(t_isalpha_0x71);
    suite_add_test(t_isalpha_0x72);
    suite_add_test(t_isalpha_0x73);
    suite_add_test(t_isalpha_0x74);
    suite_add_test(t_isalpha_0x75);
    suite_add_test(t_isalpha_0x76);
    suite_add_test(t_isalpha_0x77);
    suite_add_test(t_isalpha_0x78);
    suite_add_test(t_isalpha_0x79);
    suite_add_test(t_isalpha_0x7a);
    suite_add_test(t_isalpha_0x7b);
    suite_add_test(t_isalpha_0x7c);
    suite_add_test(t_isalpha_0x7d);
    suite_add_test(t_isalpha_0x7e);
    suite_add_test(t_isalpha_0x7f);
    suite_add_test(t_isalpha_0x80);
    suite_add_test(t_isalpha_0x81);
    suite_add_test(t_isalpha_0x82);
    suite_add_test(t_isalpha_0x83);
    suite_add_test(t_isalpha_0x84);
    suite_add_test(t_isalpha_0x85);
    suite_add_test(t_isalpha_0x86);
    suite_add_test(t_isalpha_0x87);
    suite_add_test(t_isalpha_0x88);
    suite_add_test(t_isalpha_0x89);
    suite_add_test(t_isalpha_0x8a);
    suite_add_test(t_isalpha_0x8b);
    suite_add_test(t_isalpha_0x8c);
    suite_add_test(t_isalpha_0x8d);
    suite_add_test(t_isalpha_0x8e);
    suite_add_test(t_isalpha_0x8f);
    suite_add_test(t_isalpha_0x90);
    suite_add_test(t_isalpha_0x91);
    suite_add_test(t_isalpha_0x92);
    suite_add_test(t_isalpha_0x93);
    suite_add_test(t_isalpha_0x94);
    suite_add_test(t_isalpha_0x95);
    suite_add_test(t_isalpha_0x96);
    suite_add_test(t_isalpha_0x97);
    suite_add_test(t_isalpha_0x98);
    suite_add_test(t_isalpha_0x99);
    suite_add_test(t_isalpha_0x9a);
    suite_add_test(t_isalpha_0x9b);
    suite_add_test(t_isalpha_0x9c);
    suite_add_test(t_isalpha_0x9d);
    suite_add_test(t_isalpha_0x9e);
    suite_add_test(t_isalpha_0x9f);
    suite_add_test(t_isalpha_0xa0);
    suite_add_test(t_isalpha_0xa1);
    suite_add_test(t_isalpha_0xa2);
    suite_add_test(t_isalpha_0xa3);
    suite_add_test(t_isalpha_0xa4);
    suite_add_test(t_isalpha_0xa5);
    suite_add_test(t_isalpha_0xa6);
    suite_add_test(t_isalpha_0xa7);
    suite_add_test(t_isalpha_0xa8);
    suite_add_test(t_isalpha_0xa9);
    suite_add_test(t_isalpha_0xaa);
    suite_add_test(t_isalpha_0xab);
    suite_add_test(t_isalpha_0xac);
    suite_add_test(t_isalpha_0xad);
    suite_add_test(t_isalpha_0xae);
    suite_add_test(t_isalpha_0xaf);
    suite_add_test(t_isalpha_0xb0);
    suite_add_test(t_isalpha_0xb1);
    suite_add_test(t_isalpha_0xb2);
    suite_add_test(t_isalpha_0xb3);
    suite_add_test(t_isalpha_0xb4);
    suite_add_test(t_isalpha_0xb5);
    suite_add_test(t_isalpha_0xb6);
    suite_add_test(t_isalpha_0xb7);
    suite_add_test(t_isalpha_0xb8);
    suite_add_test(t_isalpha_0xb9);
    suite_add_test(t_isalpha_0xba);
    suite_add_test(t_isalpha_0xbb);
    suite_add_test(t_isalpha_0xbc);
    suite_add_test(t_isalpha_0xbd);
    suite_add_test(t_isalpha_0xbe);
    suite_add_test(t_isalpha_0xbf);
    suite_add_test(t_isalpha_0xc0);
    suite_add_test(t_isalpha_0xc1);
    suite_add_test(t_isalpha_0xc2);
    suite_add_test(t_isalpha_0xc3);
    suite_add_test(t_isalpha_0xc4);
    suite_add_test(t_isalpha_0xc5);
    suite_add_test(t_isalpha_0xc6);
    suite_add_test(t_isalpha_0xc7);
    suite_add_test(t_isalpha_0xc8);
    suite_add_test(t_isalpha_0xc9);
    suite_add_test(t_isalpha_0xca);
    suite_add_test(t_isalpha_0xcb);
    suite_add_test(t_isalpha_0xcc);
    suite_add_test(t_isalpha_0xcd);
    suite_add_test(t_isalpha_0xce);
    suite_add_test(t_isalpha_0xcf);
    suite_add_test(t_isalpha_0xd0);
    suite_add_test(t_isalpha_0xd1);
    suite_add_test(t_isalpha_0xd2);
    suite_add_test(t_isalpha_0xd3);
    suite_add_test(t_isalpha_0xd4);
    suite_add_test(t_isalpha_0xd5);
    suite_add_test(t_isalpha_0xd6);
    suite_add_test(t_isalpha_0xd7);
    suite_add_test(t_isalpha_0xd8);
    suite_add_test(t_isalpha_0xd9);
    suite_add_test(t_isalpha_0xda);
    suite_add_test(t_isalpha_0xdb);
    suite_add_test(t_isalpha_0xdc);
    suite_add_test(t_isalpha_0xdd);
    suite_add_test(t_isalpha_0xde);
    suite_add_test(t_isalpha_0xdf);
    suite_add_test(t_isalpha_0xe0);
    suite_add_test(t_isalpha_0xe1);
    suite_add_test(t_isalpha_0xe2);
    suite_add_test(t_isalpha_0xe3);
    suite_add_test(t_isalpha_0xe4);
    suite_add_test(t_isalpha_0xe5);
    suite_add_test(t_isalpha_0xe6);
    suite_add_test(t_isalpha_0xe7);
    suite_add_test(t_isalpha_0xe8);
    suite_add_test(t_isalpha_0xe9);
    suite_add_test(t_isalpha_0xea);
    suite_add_test(t_isalpha_0xeb);
    suite_add_test(t_isalpha_0xec);
    suite_add_test(t_isalpha_0xed);
    suite_add_test(t_isalpha_0xee);
    suite_add_test(t_isalpha_0xef);
    suite_add_test(t_isalpha_0xf0);
    suite_add_test(t_isalpha_0xf1);
    suite_add_test(t_isalpha_0xf2);
    suite_add_test(t_isalpha_0xf3);
    suite_add_test(t_isalpha_0xf4);
    suite_add_test(t_isalpha_0xf5);
    suite_add_test(t_isalpha_0xf6);
    suite_add_test(t_isalpha_0xf7);
    suite_add_test(t_isalpha_0xf8);
    suite_add_test(t_isalpha_0xf9);
    suite_add_test(t_isalpha_0xfa);
    suite_add_test(t_isalpha_0xfb);
    suite_add_test(t_isalpha_0xfc);
    suite_add_test(t_isalpha_0xfd);
    suite_add_test(t_isalpha_0xfe);
    suite_add_test(t_isalpha_0xff);
     return suite_run();
}
