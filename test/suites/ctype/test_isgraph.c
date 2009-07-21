
#include "ctype_test.h"
void t_isgraph_0x00()
{
    Assert(isgraph(0)  == 0 ,"isgraph should be 0 for 0x00");
}

void t_isgraph_0x01()
{
    Assert(isgraph(1)  == 0 ,"isgraph should be 0 for 0x01");
}

void t_isgraph_0x02()
{
    Assert(isgraph(2)  == 0 ,"isgraph should be 0 for 0x02");
}

void t_isgraph_0x03()
{
    Assert(isgraph(3)  == 0 ,"isgraph should be 0 for 0x03");
}

void t_isgraph_0x04()
{
    Assert(isgraph(4)  == 0 ,"isgraph should be 0 for 0x04");
}

void t_isgraph_0x05()
{
    Assert(isgraph(5)  == 0 ,"isgraph should be 0 for 0x05");
}

void t_isgraph_0x06()
{
    Assert(isgraph(6)  == 0 ,"isgraph should be 0 for 0x06");
}

void t_isgraph_0x07()
{
    Assert(isgraph(7)  == 0 ,"isgraph should be 0 for 0x07");
}

void t_isgraph_0x08()
{
    Assert(isgraph(8)  == 0 ,"isgraph should be 0 for 0x08");
}

void t_isgraph_0x09()
{
    Assert(isgraph(9)  == 0 ,"isgraph should be 0 for 0x09");
}

void t_isgraph_0x0a()
{
    Assert(isgraph(10)  == 0 ,"isgraph should be 0 for 0x0a");
}

void t_isgraph_0x0b()
{
    Assert(isgraph(11)  == 0 ,"isgraph should be 0 for 0x0b");
}

void t_isgraph_0x0c()
{
    Assert(isgraph(12)  == 0 ,"isgraph should be 0 for 0x0c");
}

void t_isgraph_0x0d()
{
    Assert(isgraph(13)  == 0 ,"isgraph should be 0 for 0x0d");
}

void t_isgraph_0x0e()
{
    Assert(isgraph(14)  == 0 ,"isgraph should be 0 for 0x0e");
}

void t_isgraph_0x0f()
{
    Assert(isgraph(15)  == 0 ,"isgraph should be 0 for 0x0f");
}

void t_isgraph_0x10()
{
    Assert(isgraph(16)  == 0 ,"isgraph should be 0 for 0x10");
}

void t_isgraph_0x11()
{
    Assert(isgraph(17)  == 0 ,"isgraph should be 0 for 0x11");
}

void t_isgraph_0x12()
{
    Assert(isgraph(18)  == 0 ,"isgraph should be 0 for 0x12");
}

void t_isgraph_0x13()
{
    Assert(isgraph(19)  == 0 ,"isgraph should be 0 for 0x13");
}

void t_isgraph_0x14()
{
    Assert(isgraph(20)  == 0 ,"isgraph should be 0 for 0x14");
}

void t_isgraph_0x15()
{
    Assert(isgraph(21)  == 0 ,"isgraph should be 0 for 0x15");
}

void t_isgraph_0x16()
{
    Assert(isgraph(22)  == 0 ,"isgraph should be 0 for 0x16");
}

void t_isgraph_0x17()
{
    Assert(isgraph(23)  == 0 ,"isgraph should be 0 for 0x17");
}

void t_isgraph_0x18()
{
    Assert(isgraph(24)  == 0 ,"isgraph should be 0 for 0x18");
}

void t_isgraph_0x19()
{
    Assert(isgraph(25)  == 0 ,"isgraph should be 0 for 0x19");
}

void t_isgraph_0x1a()
{
    Assert(isgraph(26)  == 0 ,"isgraph should be 0 for 0x1a");
}

void t_isgraph_0x1b()
{
    Assert(isgraph(27)  == 0 ,"isgraph should be 0 for 0x1b");
}

void t_isgraph_0x1c()
{
    Assert(isgraph(28)  == 0 ,"isgraph should be 0 for 0x1c");
}

void t_isgraph_0x1d()
{
    Assert(isgraph(29)  == 0 ,"isgraph should be 0 for 0x1d");
}

void t_isgraph_0x1e()
{
    Assert(isgraph(30)  == 0 ,"isgraph should be 0 for 0x1e");
}

void t_isgraph_0x1f()
{
    Assert(isgraph(31)  == 0 ,"isgraph should be 0 for 0x1f");
}

void t_isgraph_0x20()
{
    Assert(isgraph(32)  == 0 ,"isgraph should be 0 for  ");
}

void t_isgraph_0x21()
{
    Assert(isgraph(33) ,"isgraph should be 1 for !");
}

void t_isgraph_0x22()
{
    Assert(isgraph(34) ,"isgraph should be 1 for 0x22");
}

void t_isgraph_0x23()
{
    Assert(isgraph(35) ,"isgraph should be 1 for #");
}

void t_isgraph_0x24()
{
    Assert(isgraph(36) ,"isgraph should be 1 for $");
}

void t_isgraph_0x25()
{
    Assert(isgraph(37) ,"isgraph should be 1 for %");
}

void t_isgraph_0x26()
{
    Assert(isgraph(38) ,"isgraph should be 1 for &");
}

void t_isgraph_0x27()
{
    Assert(isgraph(39) ,"isgraph should be 1 for '");
}

void t_isgraph_0x28()
{
    Assert(isgraph(40) ,"isgraph should be 1 for (");
}

void t_isgraph_0x29()
{
    Assert(isgraph(41) ,"isgraph should be 1 for )");
}

void t_isgraph_0x2a()
{
    Assert(isgraph(42) ,"isgraph should be 1 for *");
}

void t_isgraph_0x2b()
{
    Assert(isgraph(43) ,"isgraph should be 1 for +");
}

void t_isgraph_0x2c()
{
    Assert(isgraph(44) ,"isgraph should be 1 for ,");
}

void t_isgraph_0x2d()
{
    Assert(isgraph(45) ,"isgraph should be 1 for -");
}

void t_isgraph_0x2e()
{
    Assert(isgraph(46) ,"isgraph should be 1 for .");
}

void t_isgraph_0x2f()
{
    Assert(isgraph(47) ,"isgraph should be 1 for /");
}

void t_isgraph_0x30()
{
    Assert(isgraph(48) ,"isgraph should be 1 for 0");
}

void t_isgraph_0x31()
{
    Assert(isgraph(49) ,"isgraph should be 1 for 1");
}

void t_isgraph_0x32()
{
    Assert(isgraph(50) ,"isgraph should be 1 for 2");
}

void t_isgraph_0x33()
{
    Assert(isgraph(51) ,"isgraph should be 1 for 3");
}

void t_isgraph_0x34()
{
    Assert(isgraph(52) ,"isgraph should be 1 for 4");
}

void t_isgraph_0x35()
{
    Assert(isgraph(53) ,"isgraph should be 1 for 5");
}

void t_isgraph_0x36()
{
    Assert(isgraph(54) ,"isgraph should be 1 for 6");
}

void t_isgraph_0x37()
{
    Assert(isgraph(55) ,"isgraph should be 1 for 7");
}

void t_isgraph_0x38()
{
    Assert(isgraph(56) ,"isgraph should be 1 for 8");
}

void t_isgraph_0x39()
{
    Assert(isgraph(57) ,"isgraph should be 1 for 9");
}

void t_isgraph_0x3a()
{
    Assert(isgraph(58) ,"isgraph should be 1 for :");
}

void t_isgraph_0x3b()
{
    Assert(isgraph(59) ,"isgraph should be 1 for ;");
}

void t_isgraph_0x3c()
{
    Assert(isgraph(60) ,"isgraph should be 1 for <");
}

void t_isgraph_0x3d()
{
    Assert(isgraph(61) ,"isgraph should be 1 for =");
}

void t_isgraph_0x3e()
{
    Assert(isgraph(62) ,"isgraph should be 1 for >");
}

void t_isgraph_0x3f()
{
    Assert(isgraph(63) ,"isgraph should be 1 for ?");
}

void t_isgraph_0x40()
{
    Assert(isgraph(64) ,"isgraph should be 1 for @");
}

void t_isgraph_0x41()
{
    Assert(isgraph(65) ,"isgraph should be 1 for A");
}

void t_isgraph_0x42()
{
    Assert(isgraph(66) ,"isgraph should be 1 for B");
}

void t_isgraph_0x43()
{
    Assert(isgraph(67) ,"isgraph should be 1 for C");
}

void t_isgraph_0x44()
{
    Assert(isgraph(68) ,"isgraph should be 1 for D");
}

void t_isgraph_0x45()
{
    Assert(isgraph(69) ,"isgraph should be 1 for E");
}

void t_isgraph_0x46()
{
    Assert(isgraph(70) ,"isgraph should be 1 for F");
}

void t_isgraph_0x47()
{
    Assert(isgraph(71) ,"isgraph should be 1 for G");
}

void t_isgraph_0x48()
{
    Assert(isgraph(72) ,"isgraph should be 1 for H");
}

void t_isgraph_0x49()
{
    Assert(isgraph(73) ,"isgraph should be 1 for I");
}

void t_isgraph_0x4a()
{
    Assert(isgraph(74) ,"isgraph should be 1 for J");
}

void t_isgraph_0x4b()
{
    Assert(isgraph(75) ,"isgraph should be 1 for K");
}

void t_isgraph_0x4c()
{
    Assert(isgraph(76) ,"isgraph should be 1 for L");
}

void t_isgraph_0x4d()
{
    Assert(isgraph(77) ,"isgraph should be 1 for M");
}

void t_isgraph_0x4e()
{
    Assert(isgraph(78) ,"isgraph should be 1 for N");
}

void t_isgraph_0x4f()
{
    Assert(isgraph(79) ,"isgraph should be 1 for O");
}

void t_isgraph_0x50()
{
    Assert(isgraph(80) ,"isgraph should be 1 for P");
}

void t_isgraph_0x51()
{
    Assert(isgraph(81) ,"isgraph should be 1 for Q");
}

void t_isgraph_0x52()
{
    Assert(isgraph(82) ,"isgraph should be 1 for R");
}

void t_isgraph_0x53()
{
    Assert(isgraph(83) ,"isgraph should be 1 for S");
}

void t_isgraph_0x54()
{
    Assert(isgraph(84) ,"isgraph should be 1 for T");
}

void t_isgraph_0x55()
{
    Assert(isgraph(85) ,"isgraph should be 1 for U");
}

void t_isgraph_0x56()
{
    Assert(isgraph(86) ,"isgraph should be 1 for V");
}

void t_isgraph_0x57()
{
    Assert(isgraph(87) ,"isgraph should be 1 for W");
}

void t_isgraph_0x58()
{
    Assert(isgraph(88) ,"isgraph should be 1 for X");
}

void t_isgraph_0x59()
{
    Assert(isgraph(89) ,"isgraph should be 1 for Y");
}

void t_isgraph_0x5a()
{
    Assert(isgraph(90) ,"isgraph should be 1 for Z");
}

void t_isgraph_0x5b()
{
    Assert(isgraph(91) ,"isgraph should be 1 for [");
}

void t_isgraph_0x5c()
{
    Assert(isgraph(92) ,"isgraph should be 1 for 0x5c");
}

void t_isgraph_0x5d()
{
    Assert(isgraph(93) ,"isgraph should be 1 for ]");
}

void t_isgraph_0x5e()
{
    Assert(isgraph(94) ,"isgraph should be 1 for ^");
}

void t_isgraph_0x5f()
{
    Assert(isgraph(95) ,"isgraph should be 1 for _");
}

void t_isgraph_0x60()
{
    Assert(isgraph(96) ,"isgraph should be 1 for `");
}

void t_isgraph_0x61()
{
    Assert(isgraph(97) ,"isgraph should be 1 for a");
}

void t_isgraph_0x62()
{
    Assert(isgraph(98) ,"isgraph should be 1 for b");
}

void t_isgraph_0x63()
{
    Assert(isgraph(99) ,"isgraph should be 1 for c");
}

void t_isgraph_0x64()
{
    Assert(isgraph(100) ,"isgraph should be 1 for d");
}

void t_isgraph_0x65()
{
    Assert(isgraph(101) ,"isgraph should be 1 for e");
}

void t_isgraph_0x66()
{
    Assert(isgraph(102) ,"isgraph should be 1 for f");
}

void t_isgraph_0x67()
{
    Assert(isgraph(103) ,"isgraph should be 1 for g");
}

void t_isgraph_0x68()
{
    Assert(isgraph(104) ,"isgraph should be 1 for h");
}

void t_isgraph_0x69()
{
    Assert(isgraph(105) ,"isgraph should be 1 for i");
}

void t_isgraph_0x6a()
{
    Assert(isgraph(106) ,"isgraph should be 1 for j");
}

void t_isgraph_0x6b()
{
    Assert(isgraph(107) ,"isgraph should be 1 for k");
}

void t_isgraph_0x6c()
{
    Assert(isgraph(108) ,"isgraph should be 1 for l");
}

void t_isgraph_0x6d()
{
    Assert(isgraph(109) ,"isgraph should be 1 for m");
}

void t_isgraph_0x6e()
{
    Assert(isgraph(110) ,"isgraph should be 1 for n");
}

void t_isgraph_0x6f()
{
    Assert(isgraph(111) ,"isgraph should be 1 for o");
}

void t_isgraph_0x70()
{
    Assert(isgraph(112) ,"isgraph should be 1 for p");
}

void t_isgraph_0x71()
{
    Assert(isgraph(113) ,"isgraph should be 1 for q");
}

void t_isgraph_0x72()
{
    Assert(isgraph(114) ,"isgraph should be 1 for r");
}

void t_isgraph_0x73()
{
    Assert(isgraph(115) ,"isgraph should be 1 for s");
}

void t_isgraph_0x74()
{
    Assert(isgraph(116) ,"isgraph should be 1 for t");
}

void t_isgraph_0x75()
{
    Assert(isgraph(117) ,"isgraph should be 1 for u");
}

void t_isgraph_0x76()
{
    Assert(isgraph(118) ,"isgraph should be 1 for v");
}

void t_isgraph_0x77()
{
    Assert(isgraph(119) ,"isgraph should be 1 for w");
}

void t_isgraph_0x78()
{
    Assert(isgraph(120) ,"isgraph should be 1 for x");
}

void t_isgraph_0x79()
{
    Assert(isgraph(121) ,"isgraph should be 1 for y");
}

void t_isgraph_0x7a()
{
    Assert(isgraph(122) ,"isgraph should be 1 for z");
}

void t_isgraph_0x7b()
{
    Assert(isgraph(123) ,"isgraph should be 1 for {");
}

void t_isgraph_0x7c()
{
    Assert(isgraph(124) ,"isgraph should be 1 for |");
}

void t_isgraph_0x7d()
{
    Assert(isgraph(125) ,"isgraph should be 1 for }");
}

void t_isgraph_0x7e()
{
    Assert(isgraph(126) ,"isgraph should be 1 for ~");
}

void t_isgraph_0x7f()
{
    Assert(isgraph(127)  == 0 ,"isgraph should be 0 for 0x7f");
}

void t_isgraph_0x80()
{
    Assert(isgraph(128)  == 0 ,"isgraph should be 0 for 0x80");
}

void t_isgraph_0x81()
{
    Assert(isgraph(129)  == 0 ,"isgraph should be 0 for 0x81");
}

void t_isgraph_0x82()
{
    Assert(isgraph(130)  == 0 ,"isgraph should be 0 for 0x82");
}

void t_isgraph_0x83()
{
    Assert(isgraph(131)  == 0 ,"isgraph should be 0 for 0x83");
}

void t_isgraph_0x84()
{
    Assert(isgraph(132)  == 0 ,"isgraph should be 0 for 0x84");
}

void t_isgraph_0x85()
{
    Assert(isgraph(133)  == 0 ,"isgraph should be 0 for 0x85");
}

void t_isgraph_0x86()
{
    Assert(isgraph(134)  == 0 ,"isgraph should be 0 for 0x86");
}

void t_isgraph_0x87()
{
    Assert(isgraph(135)  == 0 ,"isgraph should be 0 for 0x87");
}

void t_isgraph_0x88()
{
    Assert(isgraph(136)  == 0 ,"isgraph should be 0 for 0x88");
}

void t_isgraph_0x89()
{
    Assert(isgraph(137)  == 0 ,"isgraph should be 0 for 0x89");
}

void t_isgraph_0x8a()
{
    Assert(isgraph(138)  == 0 ,"isgraph should be 0 for 0x8a");
}

void t_isgraph_0x8b()
{
    Assert(isgraph(139)  == 0 ,"isgraph should be 0 for 0x8b");
}

void t_isgraph_0x8c()
{
    Assert(isgraph(140)  == 0 ,"isgraph should be 0 for 0x8c");
}

void t_isgraph_0x8d()
{
    Assert(isgraph(141)  == 0 ,"isgraph should be 0 for 0x8d");
}

void t_isgraph_0x8e()
{
    Assert(isgraph(142)  == 0 ,"isgraph should be 0 for 0x8e");
}

void t_isgraph_0x8f()
{
    Assert(isgraph(143)  == 0 ,"isgraph should be 0 for 0x8f");
}

void t_isgraph_0x90()
{
    Assert(isgraph(144)  == 0 ,"isgraph should be 0 for 0x90");
}

void t_isgraph_0x91()
{
    Assert(isgraph(145)  == 0 ,"isgraph should be 0 for 0x91");
}

void t_isgraph_0x92()
{
    Assert(isgraph(146)  == 0 ,"isgraph should be 0 for 0x92");
}

void t_isgraph_0x93()
{
    Assert(isgraph(147)  == 0 ,"isgraph should be 0 for 0x93");
}

void t_isgraph_0x94()
{
    Assert(isgraph(148)  == 0 ,"isgraph should be 0 for 0x94");
}

void t_isgraph_0x95()
{
    Assert(isgraph(149)  == 0 ,"isgraph should be 0 for 0x95");
}

void t_isgraph_0x96()
{
    Assert(isgraph(150)  == 0 ,"isgraph should be 0 for 0x96");
}

void t_isgraph_0x97()
{
    Assert(isgraph(151)  == 0 ,"isgraph should be 0 for 0x97");
}

void t_isgraph_0x98()
{
    Assert(isgraph(152)  == 0 ,"isgraph should be 0 for 0x98");
}

void t_isgraph_0x99()
{
    Assert(isgraph(153)  == 0 ,"isgraph should be 0 for 0x99");
}

void t_isgraph_0x9a()
{
    Assert(isgraph(154)  == 0 ,"isgraph should be 0 for 0x9a");
}

void t_isgraph_0x9b()
{
    Assert(isgraph(155)  == 0 ,"isgraph should be 0 for 0x9b");
}

void t_isgraph_0x9c()
{
    Assert(isgraph(156)  == 0 ,"isgraph should be 0 for 0x9c");
}

void t_isgraph_0x9d()
{
    Assert(isgraph(157)  == 0 ,"isgraph should be 0 for 0x9d");
}

void t_isgraph_0x9e()
{
    Assert(isgraph(158)  == 0 ,"isgraph should be 0 for 0x9e");
}

void t_isgraph_0x9f()
{
    Assert(isgraph(159)  == 0 ,"isgraph should be 0 for 0x9f");
}

void t_isgraph_0xa0()
{
    Assert(isgraph(160)  == 0 ,"isgraph should be 0 for 0xa0");
}

void t_isgraph_0xa1()
{
    Assert(isgraph(161)  == 0 ,"isgraph should be 0 for 0xa1");
}

void t_isgraph_0xa2()
{
    Assert(isgraph(162)  == 0 ,"isgraph should be 0 for 0xa2");
}

void t_isgraph_0xa3()
{
    Assert(isgraph(163)  == 0 ,"isgraph should be 0 for 0xa3");
}

void t_isgraph_0xa4()
{
    Assert(isgraph(164)  == 0 ,"isgraph should be 0 for 0xa4");
}

void t_isgraph_0xa5()
{
    Assert(isgraph(165)  == 0 ,"isgraph should be 0 for 0xa5");
}

void t_isgraph_0xa6()
{
    Assert(isgraph(166)  == 0 ,"isgraph should be 0 for 0xa6");
}

void t_isgraph_0xa7()
{
    Assert(isgraph(167)  == 0 ,"isgraph should be 0 for 0xa7");
}

void t_isgraph_0xa8()
{
    Assert(isgraph(168)  == 0 ,"isgraph should be 0 for 0xa8");
}

void t_isgraph_0xa9()
{
    Assert(isgraph(169)  == 0 ,"isgraph should be 0 for 0xa9");
}

void t_isgraph_0xaa()
{
    Assert(isgraph(170)  == 0 ,"isgraph should be 0 for 0xaa");
}

void t_isgraph_0xab()
{
    Assert(isgraph(171)  == 0 ,"isgraph should be 0 for 0xab");
}

void t_isgraph_0xac()
{
    Assert(isgraph(172)  == 0 ,"isgraph should be 0 for 0xac");
}

void t_isgraph_0xad()
{
    Assert(isgraph(173)  == 0 ,"isgraph should be 0 for 0xad");
}

void t_isgraph_0xae()
{
    Assert(isgraph(174)  == 0 ,"isgraph should be 0 for 0xae");
}

void t_isgraph_0xaf()
{
    Assert(isgraph(175)  == 0 ,"isgraph should be 0 for 0xaf");
}

void t_isgraph_0xb0()
{
    Assert(isgraph(176)  == 0 ,"isgraph should be 0 for 0xb0");
}

void t_isgraph_0xb1()
{
    Assert(isgraph(177)  == 0 ,"isgraph should be 0 for 0xb1");
}

void t_isgraph_0xb2()
{
    Assert(isgraph(178)  == 0 ,"isgraph should be 0 for 0xb2");
}

void t_isgraph_0xb3()
{
    Assert(isgraph(179)  == 0 ,"isgraph should be 0 for 0xb3");
}

void t_isgraph_0xb4()
{
    Assert(isgraph(180)  == 0 ,"isgraph should be 0 for 0xb4");
}

void t_isgraph_0xb5()
{
    Assert(isgraph(181)  == 0 ,"isgraph should be 0 for 0xb5");
}

void t_isgraph_0xb6()
{
    Assert(isgraph(182)  == 0 ,"isgraph should be 0 for 0xb6");
}

void t_isgraph_0xb7()
{
    Assert(isgraph(183)  == 0 ,"isgraph should be 0 for 0xb7");
}

void t_isgraph_0xb8()
{
    Assert(isgraph(184)  == 0 ,"isgraph should be 0 for 0xb8");
}

void t_isgraph_0xb9()
{
    Assert(isgraph(185)  == 0 ,"isgraph should be 0 for 0xb9");
}

void t_isgraph_0xba()
{
    Assert(isgraph(186)  == 0 ,"isgraph should be 0 for 0xba");
}

void t_isgraph_0xbb()
{
    Assert(isgraph(187)  == 0 ,"isgraph should be 0 for 0xbb");
}

void t_isgraph_0xbc()
{
    Assert(isgraph(188)  == 0 ,"isgraph should be 0 for 0xbc");
}

void t_isgraph_0xbd()
{
    Assert(isgraph(189)  == 0 ,"isgraph should be 0 for 0xbd");
}

void t_isgraph_0xbe()
{
    Assert(isgraph(190)  == 0 ,"isgraph should be 0 for 0xbe");
}

void t_isgraph_0xbf()
{
    Assert(isgraph(191)  == 0 ,"isgraph should be 0 for 0xbf");
}

void t_isgraph_0xc0()
{
    Assert(isgraph(192)  == 0 ,"isgraph should be 0 for 0xc0");
}

void t_isgraph_0xc1()
{
    Assert(isgraph(193)  == 0 ,"isgraph should be 0 for 0xc1");
}

void t_isgraph_0xc2()
{
    Assert(isgraph(194)  == 0 ,"isgraph should be 0 for 0xc2");
}

void t_isgraph_0xc3()
{
    Assert(isgraph(195)  == 0 ,"isgraph should be 0 for 0xc3");
}

void t_isgraph_0xc4()
{
    Assert(isgraph(196)  == 0 ,"isgraph should be 0 for 0xc4");
}

void t_isgraph_0xc5()
{
    Assert(isgraph(197)  == 0 ,"isgraph should be 0 for 0xc5");
}

void t_isgraph_0xc6()
{
    Assert(isgraph(198)  == 0 ,"isgraph should be 0 for 0xc6");
}

void t_isgraph_0xc7()
{
    Assert(isgraph(199)  == 0 ,"isgraph should be 0 for 0xc7");
}

void t_isgraph_0xc8()
{
    Assert(isgraph(200)  == 0 ,"isgraph should be 0 for 0xc8");
}

void t_isgraph_0xc9()
{
    Assert(isgraph(201)  == 0 ,"isgraph should be 0 for 0xc9");
}

void t_isgraph_0xca()
{
    Assert(isgraph(202)  == 0 ,"isgraph should be 0 for 0xca");
}

void t_isgraph_0xcb()
{
    Assert(isgraph(203)  == 0 ,"isgraph should be 0 for 0xcb");
}

void t_isgraph_0xcc()
{
    Assert(isgraph(204)  == 0 ,"isgraph should be 0 for 0xcc");
}

void t_isgraph_0xcd()
{
    Assert(isgraph(205)  == 0 ,"isgraph should be 0 for 0xcd");
}

void t_isgraph_0xce()
{
    Assert(isgraph(206)  == 0 ,"isgraph should be 0 for 0xce");
}

void t_isgraph_0xcf()
{
    Assert(isgraph(207)  == 0 ,"isgraph should be 0 for 0xcf");
}

void t_isgraph_0xd0()
{
    Assert(isgraph(208)  == 0 ,"isgraph should be 0 for 0xd0");
}

void t_isgraph_0xd1()
{
    Assert(isgraph(209)  == 0 ,"isgraph should be 0 for 0xd1");
}

void t_isgraph_0xd2()
{
    Assert(isgraph(210)  == 0 ,"isgraph should be 0 for 0xd2");
}

void t_isgraph_0xd3()
{
    Assert(isgraph(211)  == 0 ,"isgraph should be 0 for 0xd3");
}

void t_isgraph_0xd4()
{
    Assert(isgraph(212)  == 0 ,"isgraph should be 0 for 0xd4");
}

void t_isgraph_0xd5()
{
    Assert(isgraph(213)  == 0 ,"isgraph should be 0 for 0xd5");
}

void t_isgraph_0xd6()
{
    Assert(isgraph(214)  == 0 ,"isgraph should be 0 for 0xd6");
}

void t_isgraph_0xd7()
{
    Assert(isgraph(215)  == 0 ,"isgraph should be 0 for 0xd7");
}

void t_isgraph_0xd8()
{
    Assert(isgraph(216)  == 0 ,"isgraph should be 0 for 0xd8");
}

void t_isgraph_0xd9()
{
    Assert(isgraph(217)  == 0 ,"isgraph should be 0 for 0xd9");
}

void t_isgraph_0xda()
{
    Assert(isgraph(218)  == 0 ,"isgraph should be 0 for 0xda");
}

void t_isgraph_0xdb()
{
    Assert(isgraph(219)  == 0 ,"isgraph should be 0 for 0xdb");
}

void t_isgraph_0xdc()
{
    Assert(isgraph(220)  == 0 ,"isgraph should be 0 for 0xdc");
}

void t_isgraph_0xdd()
{
    Assert(isgraph(221)  == 0 ,"isgraph should be 0 for 0xdd");
}

void t_isgraph_0xde()
{
    Assert(isgraph(222)  == 0 ,"isgraph should be 0 for 0xde");
}

void t_isgraph_0xdf()
{
    Assert(isgraph(223)  == 0 ,"isgraph should be 0 for 0xdf");
}

void t_isgraph_0xe0()
{
    Assert(isgraph(224)  == 0 ,"isgraph should be 0 for 0xe0");
}

void t_isgraph_0xe1()
{
    Assert(isgraph(225)  == 0 ,"isgraph should be 0 for 0xe1");
}

void t_isgraph_0xe2()
{
    Assert(isgraph(226)  == 0 ,"isgraph should be 0 for 0xe2");
}

void t_isgraph_0xe3()
{
    Assert(isgraph(227)  == 0 ,"isgraph should be 0 for 0xe3");
}

void t_isgraph_0xe4()
{
    Assert(isgraph(228)  == 0 ,"isgraph should be 0 for 0xe4");
}

void t_isgraph_0xe5()
{
    Assert(isgraph(229)  == 0 ,"isgraph should be 0 for 0xe5");
}

void t_isgraph_0xe6()
{
    Assert(isgraph(230)  == 0 ,"isgraph should be 0 for 0xe6");
}

void t_isgraph_0xe7()
{
    Assert(isgraph(231)  == 0 ,"isgraph should be 0 for 0xe7");
}

void t_isgraph_0xe8()
{
    Assert(isgraph(232)  == 0 ,"isgraph should be 0 for 0xe8");
}

void t_isgraph_0xe9()
{
    Assert(isgraph(233)  == 0 ,"isgraph should be 0 for 0xe9");
}

void t_isgraph_0xea()
{
    Assert(isgraph(234)  == 0 ,"isgraph should be 0 for 0xea");
}

void t_isgraph_0xeb()
{
    Assert(isgraph(235)  == 0 ,"isgraph should be 0 for 0xeb");
}

void t_isgraph_0xec()
{
    Assert(isgraph(236)  == 0 ,"isgraph should be 0 for 0xec");
}

void t_isgraph_0xed()
{
    Assert(isgraph(237)  == 0 ,"isgraph should be 0 for 0xed");
}

void t_isgraph_0xee()
{
    Assert(isgraph(238)  == 0 ,"isgraph should be 0 for 0xee");
}

void t_isgraph_0xef()
{
    Assert(isgraph(239)  == 0 ,"isgraph should be 0 for 0xef");
}

void t_isgraph_0xf0()
{
    Assert(isgraph(240)  == 0 ,"isgraph should be 0 for 0xf0");
}

void t_isgraph_0xf1()
{
    Assert(isgraph(241)  == 0 ,"isgraph should be 0 for 0xf1");
}

void t_isgraph_0xf2()
{
    Assert(isgraph(242)  == 0 ,"isgraph should be 0 for 0xf2");
}

void t_isgraph_0xf3()
{
    Assert(isgraph(243)  == 0 ,"isgraph should be 0 for 0xf3");
}

void t_isgraph_0xf4()
{
    Assert(isgraph(244)  == 0 ,"isgraph should be 0 for 0xf4");
}

void t_isgraph_0xf5()
{
    Assert(isgraph(245)  == 0 ,"isgraph should be 0 for 0xf5");
}

void t_isgraph_0xf6()
{
    Assert(isgraph(246)  == 0 ,"isgraph should be 0 for 0xf6");
}

void t_isgraph_0xf7()
{
    Assert(isgraph(247)  == 0 ,"isgraph should be 0 for 0xf7");
}

void t_isgraph_0xf8()
{
    Assert(isgraph(248)  == 0 ,"isgraph should be 0 for 0xf8");
}

void t_isgraph_0xf9()
{
    Assert(isgraph(249)  == 0 ,"isgraph should be 0 for 0xf9");
}

void t_isgraph_0xfa()
{
    Assert(isgraph(250)  == 0 ,"isgraph should be 0 for 0xfa");
}

void t_isgraph_0xfb()
{
    Assert(isgraph(251)  == 0 ,"isgraph should be 0 for 0xfb");
}

void t_isgraph_0xfc()
{
    Assert(isgraph(252)  == 0 ,"isgraph should be 0 for 0xfc");
}

void t_isgraph_0xfd()
{
    Assert(isgraph(253)  == 0 ,"isgraph should be 0 for 0xfd");
}

void t_isgraph_0xfe()
{
    Assert(isgraph(254)  == 0 ,"isgraph should be 0 for 0xfe");
}

void t_isgraph_0xff()
{
    Assert(isgraph(255)  == 0 ,"isgraph should be 0 for 0xff");
}



int test_isgraph()
{
    suite_setup("isgraph");
    suite_add_test(t_isgraph_0x00);
    suite_add_test(t_isgraph_0x01);
    suite_add_test(t_isgraph_0x02);
    suite_add_test(t_isgraph_0x03);
    suite_add_test(t_isgraph_0x04);
    suite_add_test(t_isgraph_0x05);
    suite_add_test(t_isgraph_0x06);
    suite_add_test(t_isgraph_0x07);
    suite_add_test(t_isgraph_0x08);
    suite_add_test(t_isgraph_0x09);
    suite_add_test(t_isgraph_0x0a);
    suite_add_test(t_isgraph_0x0b);
    suite_add_test(t_isgraph_0x0c);
    suite_add_test(t_isgraph_0x0d);
    suite_add_test(t_isgraph_0x0e);
    suite_add_test(t_isgraph_0x0f);
    suite_add_test(t_isgraph_0x10);
    suite_add_test(t_isgraph_0x11);
    suite_add_test(t_isgraph_0x12);
    suite_add_test(t_isgraph_0x13);
    suite_add_test(t_isgraph_0x14);
    suite_add_test(t_isgraph_0x15);
    suite_add_test(t_isgraph_0x16);
    suite_add_test(t_isgraph_0x17);
    suite_add_test(t_isgraph_0x18);
    suite_add_test(t_isgraph_0x19);
    suite_add_test(t_isgraph_0x1a);
    suite_add_test(t_isgraph_0x1b);
    suite_add_test(t_isgraph_0x1c);
    suite_add_test(t_isgraph_0x1d);
    suite_add_test(t_isgraph_0x1e);
    suite_add_test(t_isgraph_0x1f);
    suite_add_test(t_isgraph_0x20);
    suite_add_test(t_isgraph_0x21);
    suite_add_test(t_isgraph_0x22);
    suite_add_test(t_isgraph_0x23);
    suite_add_test(t_isgraph_0x24);
    suite_add_test(t_isgraph_0x25);
    suite_add_test(t_isgraph_0x26);
    suite_add_test(t_isgraph_0x27);
    suite_add_test(t_isgraph_0x28);
    suite_add_test(t_isgraph_0x29);
    suite_add_test(t_isgraph_0x2a);
    suite_add_test(t_isgraph_0x2b);
    suite_add_test(t_isgraph_0x2c);
    suite_add_test(t_isgraph_0x2d);
    suite_add_test(t_isgraph_0x2e);
    suite_add_test(t_isgraph_0x2f);
    suite_add_test(t_isgraph_0x30);
    suite_add_test(t_isgraph_0x31);
    suite_add_test(t_isgraph_0x32);
    suite_add_test(t_isgraph_0x33);
    suite_add_test(t_isgraph_0x34);
    suite_add_test(t_isgraph_0x35);
    suite_add_test(t_isgraph_0x36);
    suite_add_test(t_isgraph_0x37);
    suite_add_test(t_isgraph_0x38);
    suite_add_test(t_isgraph_0x39);
    suite_add_test(t_isgraph_0x3a);
    suite_add_test(t_isgraph_0x3b);
    suite_add_test(t_isgraph_0x3c);
    suite_add_test(t_isgraph_0x3d);
    suite_add_test(t_isgraph_0x3e);
    suite_add_test(t_isgraph_0x3f);
    suite_add_test(t_isgraph_0x40);
    suite_add_test(t_isgraph_0x41);
    suite_add_test(t_isgraph_0x42);
    suite_add_test(t_isgraph_0x43);
    suite_add_test(t_isgraph_0x44);
    suite_add_test(t_isgraph_0x45);
    suite_add_test(t_isgraph_0x46);
    suite_add_test(t_isgraph_0x47);
    suite_add_test(t_isgraph_0x48);
    suite_add_test(t_isgraph_0x49);
    suite_add_test(t_isgraph_0x4a);
    suite_add_test(t_isgraph_0x4b);
    suite_add_test(t_isgraph_0x4c);
    suite_add_test(t_isgraph_0x4d);
    suite_add_test(t_isgraph_0x4e);
    suite_add_test(t_isgraph_0x4f);
    suite_add_test(t_isgraph_0x50);
    suite_add_test(t_isgraph_0x51);
    suite_add_test(t_isgraph_0x52);
    suite_add_test(t_isgraph_0x53);
    suite_add_test(t_isgraph_0x54);
    suite_add_test(t_isgraph_0x55);
    suite_add_test(t_isgraph_0x56);
    suite_add_test(t_isgraph_0x57);
    suite_add_test(t_isgraph_0x58);
    suite_add_test(t_isgraph_0x59);
    suite_add_test(t_isgraph_0x5a);
    suite_add_test(t_isgraph_0x5b);
    suite_add_test(t_isgraph_0x5c);
    suite_add_test(t_isgraph_0x5d);
    suite_add_test(t_isgraph_0x5e);
    suite_add_test(t_isgraph_0x5f);
    suite_add_test(t_isgraph_0x60);
    suite_add_test(t_isgraph_0x61);
    suite_add_test(t_isgraph_0x62);
    suite_add_test(t_isgraph_0x63);
    suite_add_test(t_isgraph_0x64);
    suite_add_test(t_isgraph_0x65);
    suite_add_test(t_isgraph_0x66);
    suite_add_test(t_isgraph_0x67);
    suite_add_test(t_isgraph_0x68);
    suite_add_test(t_isgraph_0x69);
    suite_add_test(t_isgraph_0x6a);
    suite_add_test(t_isgraph_0x6b);
    suite_add_test(t_isgraph_0x6c);
    suite_add_test(t_isgraph_0x6d);
    suite_add_test(t_isgraph_0x6e);
    suite_add_test(t_isgraph_0x6f);
    suite_add_test(t_isgraph_0x70);
    suite_add_test(t_isgraph_0x71);
    suite_add_test(t_isgraph_0x72);
    suite_add_test(t_isgraph_0x73);
    suite_add_test(t_isgraph_0x74);
    suite_add_test(t_isgraph_0x75);
    suite_add_test(t_isgraph_0x76);
    suite_add_test(t_isgraph_0x77);
    suite_add_test(t_isgraph_0x78);
    suite_add_test(t_isgraph_0x79);
    suite_add_test(t_isgraph_0x7a);
    suite_add_test(t_isgraph_0x7b);
    suite_add_test(t_isgraph_0x7c);
    suite_add_test(t_isgraph_0x7d);
    suite_add_test(t_isgraph_0x7e);
    suite_add_test(t_isgraph_0x7f);
    suite_add_test(t_isgraph_0x80);
    suite_add_test(t_isgraph_0x81);
    suite_add_test(t_isgraph_0x82);
    suite_add_test(t_isgraph_0x83);
    suite_add_test(t_isgraph_0x84);
    suite_add_test(t_isgraph_0x85);
    suite_add_test(t_isgraph_0x86);
    suite_add_test(t_isgraph_0x87);
    suite_add_test(t_isgraph_0x88);
    suite_add_test(t_isgraph_0x89);
    suite_add_test(t_isgraph_0x8a);
    suite_add_test(t_isgraph_0x8b);
    suite_add_test(t_isgraph_0x8c);
    suite_add_test(t_isgraph_0x8d);
    suite_add_test(t_isgraph_0x8e);
    suite_add_test(t_isgraph_0x8f);
    suite_add_test(t_isgraph_0x90);
    suite_add_test(t_isgraph_0x91);
    suite_add_test(t_isgraph_0x92);
    suite_add_test(t_isgraph_0x93);
    suite_add_test(t_isgraph_0x94);
    suite_add_test(t_isgraph_0x95);
    suite_add_test(t_isgraph_0x96);
    suite_add_test(t_isgraph_0x97);
    suite_add_test(t_isgraph_0x98);
    suite_add_test(t_isgraph_0x99);
    suite_add_test(t_isgraph_0x9a);
    suite_add_test(t_isgraph_0x9b);
    suite_add_test(t_isgraph_0x9c);
    suite_add_test(t_isgraph_0x9d);
    suite_add_test(t_isgraph_0x9e);
    suite_add_test(t_isgraph_0x9f);
    suite_add_test(t_isgraph_0xa0);
    suite_add_test(t_isgraph_0xa1);
    suite_add_test(t_isgraph_0xa2);
    suite_add_test(t_isgraph_0xa3);
    suite_add_test(t_isgraph_0xa4);
    suite_add_test(t_isgraph_0xa5);
    suite_add_test(t_isgraph_0xa6);
    suite_add_test(t_isgraph_0xa7);
    suite_add_test(t_isgraph_0xa8);
    suite_add_test(t_isgraph_0xa9);
    suite_add_test(t_isgraph_0xaa);
    suite_add_test(t_isgraph_0xab);
    suite_add_test(t_isgraph_0xac);
    suite_add_test(t_isgraph_0xad);
    suite_add_test(t_isgraph_0xae);
    suite_add_test(t_isgraph_0xaf);
    suite_add_test(t_isgraph_0xb0);
    suite_add_test(t_isgraph_0xb1);
    suite_add_test(t_isgraph_0xb2);
    suite_add_test(t_isgraph_0xb3);
    suite_add_test(t_isgraph_0xb4);
    suite_add_test(t_isgraph_0xb5);
    suite_add_test(t_isgraph_0xb6);
    suite_add_test(t_isgraph_0xb7);
    suite_add_test(t_isgraph_0xb8);
    suite_add_test(t_isgraph_0xb9);
    suite_add_test(t_isgraph_0xba);
    suite_add_test(t_isgraph_0xbb);
    suite_add_test(t_isgraph_0xbc);
    suite_add_test(t_isgraph_0xbd);
    suite_add_test(t_isgraph_0xbe);
    suite_add_test(t_isgraph_0xbf);
    suite_add_test(t_isgraph_0xc0);
    suite_add_test(t_isgraph_0xc1);
    suite_add_test(t_isgraph_0xc2);
    suite_add_test(t_isgraph_0xc3);
    suite_add_test(t_isgraph_0xc4);
    suite_add_test(t_isgraph_0xc5);
    suite_add_test(t_isgraph_0xc6);
    suite_add_test(t_isgraph_0xc7);
    suite_add_test(t_isgraph_0xc8);
    suite_add_test(t_isgraph_0xc9);
    suite_add_test(t_isgraph_0xca);
    suite_add_test(t_isgraph_0xcb);
    suite_add_test(t_isgraph_0xcc);
    suite_add_test(t_isgraph_0xcd);
    suite_add_test(t_isgraph_0xce);
    suite_add_test(t_isgraph_0xcf);
    suite_add_test(t_isgraph_0xd0);
    suite_add_test(t_isgraph_0xd1);
    suite_add_test(t_isgraph_0xd2);
    suite_add_test(t_isgraph_0xd3);
    suite_add_test(t_isgraph_0xd4);
    suite_add_test(t_isgraph_0xd5);
    suite_add_test(t_isgraph_0xd6);
    suite_add_test(t_isgraph_0xd7);
    suite_add_test(t_isgraph_0xd8);
    suite_add_test(t_isgraph_0xd9);
    suite_add_test(t_isgraph_0xda);
    suite_add_test(t_isgraph_0xdb);
    suite_add_test(t_isgraph_0xdc);
    suite_add_test(t_isgraph_0xdd);
    suite_add_test(t_isgraph_0xde);
    suite_add_test(t_isgraph_0xdf);
    suite_add_test(t_isgraph_0xe0);
    suite_add_test(t_isgraph_0xe1);
    suite_add_test(t_isgraph_0xe2);
    suite_add_test(t_isgraph_0xe3);
    suite_add_test(t_isgraph_0xe4);
    suite_add_test(t_isgraph_0xe5);
    suite_add_test(t_isgraph_0xe6);
    suite_add_test(t_isgraph_0xe7);
    suite_add_test(t_isgraph_0xe8);
    suite_add_test(t_isgraph_0xe9);
    suite_add_test(t_isgraph_0xea);
    suite_add_test(t_isgraph_0xeb);
    suite_add_test(t_isgraph_0xec);
    suite_add_test(t_isgraph_0xed);
    suite_add_test(t_isgraph_0xee);
    suite_add_test(t_isgraph_0xef);
    suite_add_test(t_isgraph_0xf0);
    suite_add_test(t_isgraph_0xf1);
    suite_add_test(t_isgraph_0xf2);
    suite_add_test(t_isgraph_0xf3);
    suite_add_test(t_isgraph_0xf4);
    suite_add_test(t_isgraph_0xf5);
    suite_add_test(t_isgraph_0xf6);
    suite_add_test(t_isgraph_0xf7);
    suite_add_test(t_isgraph_0xf8);
    suite_add_test(t_isgraph_0xf9);
    suite_add_test(t_isgraph_0xfa);
    suite_add_test(t_isgraph_0xfb);
    suite_add_test(t_isgraph_0xfc);
    suite_add_test(t_isgraph_0xfd);
    suite_add_test(t_isgraph_0xfe);
    suite_add_test(t_isgraph_0xff);
     return suite_run();
}
