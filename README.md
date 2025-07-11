# Blackjack in x86 Assembly

Welcome to **Blackjack**, a command-line game implemented in x86 Assembly language using the Irvine32 library.
Try to get as close to 21 as possible without going over, and beat dealers hand.

# **Project Overview**
Project was written in x86 Assembly (MASM) using Irvine32 Library

# **How to Play**
- You're dealt two cards at the start.
-    Cards range between 2 to 10, with:
-    Jack, Queen, and King = 10 Points
-    Ace = 11 or 1
- You can choose to:
-    **Hit** (draw another card)
-    **Stand** (ends turn, dealer plays)

If total exceeds 21, you **bust** and lose the game.
If dealer draws until they reach 17 or higher.
The highest score or score <= 21, wins.

# **Requirements**
- MASM32 or Irvine32 setup
- Windows OS
- Command line interface

This project uses the **Irvine32** library. Make sure it's installed and properly implemented in the enviornment.

```assembly
INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

