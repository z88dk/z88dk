#include <input.h>
#include <stdbool.h>
#include <stdio.h>

/* Global variables required for the in_GetKey state machine */

extern unsigned char in_KeyDebounce;
extern unsigned char in_KeyStartRepeat;
extern unsigned char in_KeyRepeatPeriod;

/* UDK structure for joystick testing */
struct in_UDK keyboard_joy;

/*
 * @brief Helper function to synchronize with the P2000T's 50Hz V-Sync.
 * This ensures consistent timing for input polling and other time-sensitive operations.
 */
void wait_frame(void) {
#asm
  halt
#endasm
}

/*
 * @brief Disables the P2000's keyboard and timer routines.
 * The P2000 contains a Z8430 Counter/Timer Circuit (CTC).
 * The video chip triggers a countdown pulse on the CTC every vertical retrace (20ms).
 * Disabling the keyboard also disables these timers.
 */
void disable_keyboard(void){
#asm
  call $0023
#endasm
}

/*
 * @brief Enables the P2000's keyboard and timer routines, restoring normal operation.
 */
void enable_keyboard(void) {
#asm
  call $0020
#endasm

}

/*
 * @brief Clears the P2000 ROM key buffer.
 * Note that many key events may also be intercepted by the ROM routines.
 */
void clear_key_buffer(void) {
#asm
  call $001B
#endasm
}

/*
 * @brief Tests the `in_Inkey()` function, which provides an instantaneous snapshot of key presses.
 * This function continuously polls the keyboard and prints the ASCII code of any pressed key.
 * Press 'q' to exit the test.
 */
void test_inkey(void) {
  unsigned int key;
  printf("\n--- Testing in_Inkey() (Snapshot) ---\n");
  printf("Press keys to see them. Press 'q' to exit.\n\n");

  while (1) {
    wait_frame();

    key = in_Inkey();
    if (key) {
      printf("%c", (char)key);
      if (key == 'q')
        break;
    }
  }
}

/*
 * @brief Tests the `in_GetKey()` function, which provides debounced and repeating key input.
 * It demonstrates the effect of `in_KeyDebounce`, `in_KeyStartRepeat`, and `in_KeyRepeatPeriod`
 * by setting them to observable values. Press 'q' to exit the test.
 *
 * Note: This mainly showcases that you in_GetKey is not a great experience, maybe the 
 * values used for repeat, and debounce are wrong?
 */
void test_getkey(void) {
  unsigned int key;
  disable_keyboard();
  printf("\n--- Testing in_GetKey() (Generic) ---\n");
  printf("Press keys to see them. Press 'q' to exit.\n\n");

  in_KeyDebounce = 2;   
  in_KeyStartRepeat = 30; 
  in_KeyRepeatPeriod = 8;
  clear_key_buffer();

  while (1) {
    // This is truly not a great experience, in_GetKey is likely better
    // implemented by using the ROM routines.
    key = in_GetKey();

    if (key) {
      printf("%c", (char)key);
      if (key == 'q')
        break;
    }
    in_Wait(20);
  }
  enable_keyboard();
}

/*
 * @brief Tests the `in_JoyKeyboard()` function, simulating a joystick using keyboard keys.
 * Uses 'w', 'a', 's', 'd' for directional input and spacebar for fire.
 * Press 'q' to exit the test.
 */
void test_joykeyboard(void) {
  unsigned char joy_state;
  printf("\n--- Testing in_JoyKeyboard() ---\n");
  printf("Use 'w','a','s','d' <space>. Press 'q' to exit.\n\n");

  keyboard_joy.up = in_LookupKey('w');
  keyboard_joy.down = in_LookupKey('s');
  keyboard_joy.left = in_LookupKey('a');
  keyboard_joy.right = in_LookupKey('d');
  keyboard_joy.fire = in_LookupKey(' ');

  while (1) {
    wait_frame();

    if (in_Inkey() == 'q')
      break;

    joy_state = in_JoyKeyboard(&keyboard_joy);
    if (joy_state & in_UP)
      printf("UP ");
    if (joy_state & in_DOWN)
      printf("DOWN ");
    if (joy_state & in_LEFT)
      printf("LEFT ");
    if (joy_state & in_RIGHT)
      printf("RIGHT ");
    if (joy_state & in_FIRE) 
      printf("FIRE ");
    if (joy_state)
      printf("\n");
  }
}

/*
 * @brief Tests the `in_KeyPressed()` function, demonstrating how to query the continuous state of a specific key.
 * It monitors the 'p' key and reports when it is pressed or released.
 * Press 'q' to exit the test.
 */
void test_keypressed(void) {
  unsigned int scancode_p;
  bool was_pressed = false;

  printf("\n--- Testing in_KeyPressed() ---\n");
  printf("Hold/release the 'p' key to see its state.\n");
  printf("Press 'q' to exit.\n\n");

  scancode_p = in_LookupKey('p');
  if (scancode_p == 0) {
    printf("ERROR: Could not find scancode for 'p'.\n");
    return;
  }

  while (1) {
    wait_frame();

    if (in_Inkey() == 'q') {
      break;
    }

    if (in_KeyPressed(scancode_p)) {
      if (!was_pressed) {
        printf("'p' is PRESSED\n");
        was_pressed = true;
      }
    } else {
      if (was_pressed) {
        printf("'p' is RELEASED\n");
        was_pressed = false;
      }
    }
  }
}

/*
 * @brief Tests the `in_LookupKey()` function by verifying ASCII to scancode mappings.
 * It iterates through a predefined set of characters and compares their actual scancodes
 * with expected values.
 */
void test_key_lookup(void) {
  struct KeyLookupTest {
    char ascii_char;
    unsigned int expected_scancode; // H=Row, L=Mask
  } tests[] = {
      {'q', 0x0008}, // Row 0, Mask 0x08
      {'s', 0x0108}, // Row 1, Mask 0x08
      {'p', 0x0620}, // Row 6, Mask 0x20
      {' ', 0x0202}, // Row 2, Mask 0x02
      {'Z', 0x0104}, // Shifted 'z', maps to physical 'z' (Row 1, Mask 0x04)
      {0, 0}         // Sentinel
  };

  unsigned int scancode;
  int i;
  bool all_passed = true;

  printf("\n--- Testing in_LookupKey() ---\n");
  printf("Verifying ASCII to Scancode mappings:\n");
  printf("Char | Expected | Actual   | Result\n");
  printf("--------------------------------------\n");

  for (i = 0; tests[i].ascii_char != 0; i++) {
    scancode = in_LookupKey(tests[i].ascii_char);
    printf(" %c   | 0x%04X   | 0x%04X   | ", tests[i].ascii_char,
           tests[i].expected_scancode, scancode);

    if (scancode == tests[i].expected_scancode) {
      printf("PASS\n");
    } else {
      printf("FAIL\n");
      all_passed = false;
    }
  }

  printf("\nAll in_LookupKey tests: %s\n", all_passed ? "PASSED" : "FAILED");
}

/*
 * @brief Tests the `in_Wait()` function, which pauses execution for a specified duration.
 * This function waits for 2 seconds without interruption.
 */
void test_wait(void) {
  printf("\n--- Testing in_Wait() ---\n");
  printf("Waiting for 2 seconds (2000 ms).\n");
  in_Wait(2000);
  printf("Done.\n");
}

/*
 * @brief Tests the `in_Pause()` function, which pauses execution for a specified duration
 * but can be interrupted by a key press. It pauses for 5 seconds.
 */
void test_pause(void) {
  unsigned int remaining;
  printf("\n--- Testing in_Pause() ---\n");
  printf("Waiting for 5 seconds (5000 ms).\n");
  printf("Press a key to interrupt.\n");
  remaining = in_Pause(5000);
  if (remaining > 0) {
    printf("Interrupted with %u ms remaining.\n", remaining);
  } else {
    printf("Pause finished.\n");
  }
}

/*
 * @brief Displays the scancode (Row and Mask) for specific keys ('w', 'a', 's', 'd').
 * This helps in understanding how `in_LookupKey` translates ASCII characters into
 * hardware-specific key representations.
 */
void test_scancodes(void) {
  char keys[] = {'w', 'a', 's', 'd'};
  unsigned int scancode;
  int i;

  printf("\n--- Scancode Lookup Debug ---\n");
  printf("Key | Row | Mask (Hex)\n");
  printf("----------------------\n");

  for (i = 0; i < 4; i++) {
    scancode = in_LookupKey(keys[i]);

    /* * Scancode Format:
     * High Byte = Row (0-8)
     * Low Byte  = Bitmask (1, 2, 4, 8, 16, 32, 64, 128)
     */
    printf(" %c  |  %02X |  %02X\n", keys[i], (unsigned char)(scancode >> 8),
           (unsigned char)(scancode & 0xFF));
  }
}

void main(void) {
  char choice;

  printf("P2000T Input Test\n");

  while (1) {
    clear_key_buffer();
    printf("\n--- Input Test Menu ---\n");
    printf("1: Instant Scan (in_Inkey)\n");
    printf("2: Debounced Input (in_GetKey)\n");
    printf("3: Virtual Joystick (in_JoyKeyboard)\n");
    printf("4: Timed Wait (in_Wait)\n");
    printf("5: Interruptible Pause (in_Pause)\n");
    printf("6: Debug scancodes\n");
    printf("7: Key Pressed State (in_KeyPressed)\n");
    printf("q: Quit\n");
    printf("Choice: ");

    choice = getchar();
    printf("%c\n", choice);

    switch (choice) {
    case '1':
      test_inkey();
      break;
    case '2':
      test_getkey();
      break;
    case '3':
      test_joykeyboard();
      break;
    case '4':
      test_wait();
      break;
    case '5':
      test_pause();
      break;
    case '6':
      test_scancodes();
      break;
    case '7':
      test_keypressed();
      break;
    case 'q':
      return;
    default:
      printf("Invalid.\n");
      break;
    }
  }
}
