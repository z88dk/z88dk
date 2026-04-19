#if ; no expression
#endif
#if *1 ; syntax error in expression
#endif
#if asmpc ; not constant expression
#endif
#else ; else without if
#elseif ; elseif without if
#elif ; elif without if
#endif ; endif without if
#if 1
#else
#else ; two elses
#endif
#if 1
#else
#elseif ; elseif after else
#endif
#if 1
#else
#elif ; elif after else
#endif
