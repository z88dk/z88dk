/*
 *      Header for command entries for Topic 5
 *
 *      Do not include yourself - included by application.h
 *
 *      7/4/99 djm
 */


#ifdef TOPIC5_1
.in_com_5_1
        defb    in_com_5_1end - in_com_5_1
        APPLBYTE(TOPIC5_1CODE)
        APPLNAME(TOPIC5_1KEY)
        APPLTEXT(TOPIC5_1)
#ifdef TOPIC5_1HELP1
        defb    (in_com_hlp5_1 - in_help) /256
        defb    (in_com_hlp5_1 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC5_1HELP1) */
#ifdef TOPIC5_1ATTR
        APPLBYTE(TOPIC5_1ATTR)
#else
        defb    0
#endif /* TOPIC5_1ATTR */
        defb    in_com_5_1end - in_com_5_1
.in_com_5_1end
#endif /* TOPIC5_1 */


#ifdef TOPIC5_2
.in_com_5_2
        defb    in_com_5_2end - in_com_5_2
        APPLBYTE(TOPIC5_2CODE)
        APPLNAME(TOPIC5_2KEY)
        APPLTEXT(TOPIC5_2)
#ifdef TOPIC5_2HELP1
        defb    (in_com_hlp5_2 - in_help) /256
        defb    (in_com_hlp5_2 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC5_2HELP1) */
#ifdef TOPIC5_2ATTR
        APPLBYTE(TOPIC5_2ATTR)
#else
        defb    0
#endif /* TOPIC5_2ATTR */
        defb    in_com_5_2end - in_com_5_2
.in_com_5_2end
#endif /* TOPIC5_2 */


#ifdef TOPIC5_3
.in_com_5_3
        defb    in_com_5_3end - in_com_5_3
        APPLBYTE(TOPIC5_3CODE)
        APPLNAME(TOPIC5_3KEY)
        APPLNAME(TOPIC5_3)
#ifdef TOPIC5_3HELP1
        defb    (in_com_hlp5_3 - in_help) /256
        defb    (in_com_hlp5_3 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_3HELP1) */
#ifdef TOPIC5_3ATTR
        APPLBYTE(TOPIC5_3ATTR)
#else
        defb    0
#endif /* TOPIC5_3ATTR */
        defb    in_com_5_3end - in_com_5_3
.in_com_5_3end
#endif /* TOPIC5_3 */


#ifdef TOPIC5_4
.in_com_5_4
        defb    in_com_5_4end - in_com_5_4
        APPLBYTE(TOPIC5_4CODE)
        APPLNAME(TOPIC5_4KEY)
        APPLNAME(TOPIC5_4)
#ifdef TOPIC5_4HELP1
        defb    (in_com_hlp5_4 - in_help) /256
        defb    (in_com_hlp5_4 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_4HELP1) */
#ifdef TOPIC5_4ATTR
        APPLBYTE(TOPIC5_4ATTR)
#else
        defb    0
#endif /* TOPIC5_4ATTR */
        defb    in_com_5_4end - in_com_5_4
.in_com_5_4end
#endif /* TOPIC5_4 */


#ifdef TOPIC5_5
.in_com_5_5
        defb    in_com_5_5end - in_com_5_5
        APPLBYTE(TOPIC5_5CODE)
        APPLNAME(TOPIC5_5KEY)
        APPLNAME(TOPIC5_5)
#ifdef TOPIC5_5HELP1
        defb    (in_com_hlp5_5 - in_help) /256
        defb    (in_com_hlp5_5 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_5HELP1) */
#ifdef TOPIC5_5ATTR
        APPLBYTE(TOPIC5_5ATTR)
#else
        defb    0
#endif /* TOPIC5_5ATTR */
        defb    in_com_5_5end - in_com_5_5
.in_com_5_5end
#endif /* TOPIC5_5 */


#ifdef TOPIC5_6
.in_com_5_6
        defb    in_com_5_6end - in_com_5_6
        APPLBYTE(TOPIC5_6CODE)
        APPLNAME(TOPIC5_6KEY)
        APPLNAME(TOPIC5_6)
#ifdef TOPIC5_6HELP1
        defb    (in_com_hlp5_6 - in_help) /256
        defb    (in_com_hlp5_6 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_6HELP1) */
#ifdef TOPIC5_6ATTR
        APPLBYTE(TOPIC5_6ATTR)
#else
        defb    0
#endif /* TOPIC5_6ATTR */
        defb    in_com_5_6end - in_com_5_6
.in_com_5_6end
#endif /* TOPIC5_6 */


#ifdef TOPIC5_7
.in_com_5_7
        defb    in_com_5_7end - in_com_5_7
        APPLBYTE(TOPIC5_7CODE)
        APPLNAME(TOPIC5_7KEY)
        APPLNAME(TOPIC5_7)
#ifdef TOPIC5_7HELP1
        defb    (in_com_hlp5_7 - in_help) /256
        defb    (in_com_hlp5_7 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_7HELP1) */
#ifdef TOPIC5_7ATTR
        APPLBYTE(TOPIC5_7ATTR)
#else
        defb    0
#endif /* TOPIC5_7ATTR */
        defb    in_com_5_7end - in_com_5_7
.in_com_5_7end
#endif /* TOPIC5_7 */


#ifdef TOPIC5_8
.in_com_5_8
        defb    in_com_5_8end - in_com_5_8
        APPLBYTE(TOPIC5_8CODE)
        APPLNAME(TOPIC5_8KEY)
        APPLNAME(TOPIC5_8)
#ifdef TOPIC5_8HELP1
        defb    (in_com_hlp5_8 - in_help) /256
        defb    (in_com_hlp5_8 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_8HELP1) */
#ifdef TOPIC5_8ATTR
        APPLBYTE(TOPIC5_8ATTR)
#else
        defb    0
#endif /* TOPIC5_8ATTR */
        defb    in_com_5_8end - in_com_5_8
.in_com_5_8end
#endif /* TOPIC5_8 */


#ifdef TOPIC5_9
.in_com_5_9
        defb    in_com_5_9end - in_com_5_9
        APPLBYTE(TOPIC5_9CODE)
        APPLNAME(TOPIC5_9KEY)
        APPLNAME(TOPIC5_9)
#ifdef TOPIC5_9HELP1
        defb    (in_com_hlp5_9 - in_help) /256
        defb    (in_com_hlp5_9 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_9HELP1) */
#ifdef TOPIC5_9ATTR
        APPLBYTE(TOPIC5_9ATTR)
#else
        defb    0
#endif /* TOPIC5_9ATTR */
        defb    in_com_5_9end - in_com_5_9
.in_com_5_9end
#endif /* TOPIC5_9 */


#ifdef TOPIC5_10
.in_com_5_10
        defb    in_com_5_10end - in_com_5_10
        APPLBYTE(TOPIC5_10CODE)
        APPLNAME(TOPIC5_10KEY)
        APPLNAME(TOPIC5_10)
#ifdef TOPIC5_10HELP1
        defb    (in_com_hlp5_10 - in_help) /256
        defb    (in_com_hlp5_10 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_10HELP1) */
#ifdef TOPIC5_10ATTR
        APPLBYTE(TOPIC5_10ATTR)
#else
        defb    0
#endif /* TOPIC5_10ATTR */
        defb    in_com_5_10end - in_com_5_10
.in_com_5_10end
#endif /* TOPIC5_10 */


#ifdef TOPIC5_11
.in_com_5_11
        defb    in_com_5_11end - in_com_5_11
        APPLBYTE(TOPIC5_11CODE)
        APPLNAME(TOPIC5_11KEY)
        APPLNAME(TOPIC5_11)
#ifdef TOPIC5_11HELP1
        defb    (in_com_hlp5_11 - in_help) /256
        defb    (in_com_hlp5_11 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_11HELP1) */
#ifdef TOPIC5_11ATTR
        APPLBYTE(TOPIC5_11ATTR)
#else
        defb    0
#endif /* TOPIC5_11ATTR */
        defb    in_com_5_11end - in_com_5_11
.in_com_5_11end
#endif /* TOPIC5_11 */


#ifdef TOPIC5_12
.in_com_5_12
        defb    in_com_5_12end - in_com_5_12
        APPLBYTE(TOPIC5_12CODE)
        APPLNAME(TOPIC5_12KEY)
        APPLNAME(TOPIC5_12)
#ifdef TOPIC5_12HELP1
        defb    (in_com_hlp5_12 - in_help) /256
        defb    (in_com_hlp5_12 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_12HELP1) */
#ifdef TOPIC5_12ATTR
        APPLBYTE(TOPIC5_12ATTR)
#else
        defb    0
#endif /* TOPIC5_12ATTR */
        defb    in_com_5_12end - in_com_5_12
.in_com_5_12end
#endif /* TOPIC5_12 */


#ifdef TOPIC5_13
.in_com_5_13
        defb    in_com_5_13end - in_com_5_13
        APPLBYTE(TOPIC5_13CODE)
        APPLNAME(TOPIC5_13KEY)
        APPLNAME(TOPIC5_13)
#ifdef TOPIC5_13HELP1
        defb    (in_com_hlp5_13 - in_help) /256
        defb    (in_com_hlp5_13 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_13HELP1) */
#ifdef TOPIC5_13ATTR
        APPLBYTE(TOPIC5_13ATTR)
#else
        defb    0
#endif /* TOPIC5_13ATTR */
        defb    in_com_5_13end - in_com_5_13
.in_com_5_13end
#endif /* TOPIC5_13 */


#ifdef TOPIC5_14
.in_com_5_14
        defb    in_com_5_14end - in_com_5_14
        APPLBYTE(TOPIC5_14CODE)
        APPLNAME(TOPIC5_14KEY)
        APPLNAME(TOPIC5_14)
#ifdef TOPIC5_14HELP1
        defb    (in_com_hlp5_14 - in_help) /256
        defb    (in_com_hlp5_14 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_14HELP1) */
#ifdef TOPIC5_14ATTR
        APPLBYTE(TOPIC5_14ATTR)
#else
        defb    0
#endif /* TOPIC5_14ATTR */
        defb    in_com_5_14end - in_com_5_14
.in_com_5_14end
#endif /* TOPIC5_14 */


#ifdef TOPIC5_15
.in_com_5_15
        defb    in_com_5_15end - in_com_5_15
        APPLBYTE(TOPIC5_15CODE)
        APPLNAME(TOPIC5_15KEY)
        APPLNAME(TOPIC5_15)
#ifdef TOPIC5_15HELP1
        defb    (in_com_hlp5_15 - in_help) /256
        defb    (in_com_hlp5_15 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_15HELP1) */
#ifdef TOPIC5_15ATTR
        APPLBYTE(TOPIC5_15ATTR)
#else
        defb    0
#endif /* TOPIC5_15ATTR */
        defb    in_com_5_15end - in_com_5_15
.in_com_5_15end
#endif /* TOPIC5_15 */


#ifdef TOPIC5_16
.in_com_5_16
        defb    in_com_5_16end - in_com_5_16
        APPLBYTE(TOPIC5_16CODE)
        APPLNAME(TOPIC5_16KEY)
        APPLNAME(TOPIC5_16)
#ifdef TOPIC5_16HELP1
        defb    (in_com_hlp5_16 - in_help) /256
        defb    (in_com_hlp5_16 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_16HELP1) */
#ifdef TOPIC5_16ATTR
        APPLBYTE(TOPIC5_16ATTR)
#else
        defb    0
#endif /* TOPIC5_16ATTR */
        defb    in_com_5_16end - in_com_5_16
.in_com_5_16end
#endif /* TOPIC5_16 */


#ifdef TOPIC5_17
.in_com_5_17
        defb    in_com_5_17end - in_com_5_17
        APPLBYTE(TOPIC5_17CODE)
        APPLNAME(TOPIC5_17KEY)
        APPLNAME(TOPIC5_17)
#ifdef TOPIC5_17HELP1
        defb    (in_com_hlp5_17 - in_help) /256
        defb    (in_com_hlp5_17 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_17HELP1) */
#ifdef TOPIC5_17ATTR
        APPLBYTE(TOPIC5_17ATTR)
#else
        defb    0
#endif /* TOPIC5_17ATTR */
        defb    in_com_5_17end - in_com_5_17
.in_com_5_17end
#endif /* TOPIC5_17 */


#ifdef TOPIC5_18
.in_com_5_18
        defb    in_com_5_18end - in_com_5_18
        APPLBYTE(TOPIC5_18CODE)
        APPLNAME(TOPIC5_18KEY)
        APPLNAME(TOPIC5_18)
#ifdef TOPIC5_18HELP1
        defb    (in_com_hlp5_18 - in_help) /256
        defb    (in_com_hlp5_18 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_18HELP1) */
#ifdef TOPIC5_18ATTR
        APPLBYTE(TOPIC5_18ATTR)
#else
        defb    0
#endif /* TOPIC5_18ATTR */
        defb    in_com_5_18end - in_com_5_18
.in_com_5_18end
#endif /* TOPIC5_18 */


#ifdef TOPIC5_19
.in_com_5_19
        defb    in_com_5_19end - in_com_5_19
        APPLBYTE(TOPIC5_19CODE)
        APPLNAME(TOPIC5_19KEY)
        APPLNAME(TOPIC5_19)
#ifdef TOPIC5_19HELP1
        defb    (in_com_hlp5_19 - in_help) /256
        defb    (in_com_hlp5_19 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_19HELP1) */
#ifdef TOPIC5_19ATTR
        APPLBYTE(TOPIC5_19ATTR)
#else
        defb    0
#endif /* TOPIC5_19ATTR */
        defb    in_com_5_19end - in_com_5_19
.in_com_5_19end
#endif /* TOPIC5_19 */


#ifdef TOPIC5_20
.in_com_5_20
        defb    in_com_5_20end - in_com_5_20
        APPLBYTE(TOPIC5_20CODE)
        APPLNAME(TOPIC5_20KEY)
        APPLNAME(TOPIC5_20)
#ifdef TOPIC5_20HELP1
        defb    (in_com_hlp5_20 - in_help) /256
        defb    (in_com_hlp5_20 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_20HELP1) */
#ifdef TOPIC5_20ATTR
        APPLBYTE(TOPIC5_20ATTR)
#else
        defb    0
#endif /* TOPIC5_20ATTR */
        defb    in_com_5_20end - in_com_5_20
.in_com_5_20end
#endif /* TOPIC5_20 */


#ifdef TOPIC5_21
.in_com_5_21
        defb    in_com_5_21end - in_com_5_21
        APPLBYTE(TOPIC5_21CODE)
        APPLNAME(TOPIC5_21KEY)
        APPLNAME(TOPIC5_21)
#ifdef TOPIC5_21HELP1
        defb    (in_com_hlp5_21 - in_help) /256
        defb    (in_com_hlp5_21 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_21HELP1) */
#ifdef TOPIC5_21ATTR
        APPLBYTE(TOPIC5_21ATTR)
#else
        defb    0
#endif /* TOPIC5_21ATTR */
        defb    in_com_5_21end - in_com_5_21
.in_com_5_21end
#endif /* TOPIC5_21 */


#ifdef TOPIC5_22
.in_com_5_22
        defb    in_com_5_22end - in_com_5_22
        APPLBYTE(TOPIC5_22CODE)
        APPLNAME(TOPIC5_22KEY)
        APPLNAME(TOPIC5_22)
#ifdef TOPIC5_22HELP1
        defb    (in_com_hlp5_22 - in_help) /256
        defb    (in_com_hlp5_22 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_22HELP1) */
#ifdef TOPIC5_22ATTR
        APPLBYTE(TOPIC5_22ATTR)
#else
        defb    0
#endif /* TOPIC5_22ATTR */
        defb    in_com_5_22end - in_com_5_22
.in_com_5_22end
#endif /* TOPIC5_22 */


#ifdef TOPIC5_23
.in_com_5_23
        defb    in_com_5_23end - in_com_5_23
        APPLBYTE(TOPIC5_23CODE)
        APPLNAME(TOPIC5_23KEY)
        APPLNAME(TOPIC5_23)
#ifdef TOPIC5_23HELP1
        defb    (in_com_hlp5_23 - in_help) /256
        defb    (in_com_hlp5_23 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_23HELP1) */
#ifdef TOPIC5_23ATTR
        APPLBYTE(TOPIC5_23ATTR)
#else
        defb    0
#endif /* TOPIC5_23ATTR */
        defb    in_com_5_23end - in_com_5_23
.in_com_5_23end
#endif /* TOPIC5_23 */


#ifdef TOPIC5_24
.in_com_5_24
        defb    in_com_5_24end - in_com_5_24
        APPLBYTE(TOPIC5_24CODE)
        APPLNAME(TOPIC5_24KEY)
        APPLNAME(TOPIC5_24)
#ifdef TOPIC5_24HELP1
        defb    (in_com_hlp5_24 - in_help) /256
        defb    (in_com_hlp5_24 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC5_24HELP1) */
#ifdef TOPIC5_24ATTR
        APPLBYTE(TOPIC5_24ATTR)
#else
        defb    0
#endif /* TOPIC5_24ATTR */
        defb    in_com_5_24end - in_com_5_24
.in_com_5_24end
#endif /* TOPIC5_24 */

/*
 * If we have the first item of next topic, then we carry on!
 */

#ifdef TOPIC6_1
        defb    1               ;end marker of current topic
#endif
