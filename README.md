# Hogwarts Express - Assembly Game

This is a side-scrolling adventure game developed in **16-bit Assembly Language** using **NASM** and **DOSBox**. The game features the Hogwarts Express train journey with interactive mechanics and custom graphics.

## 👥 Project Members
* **Amna Asghar** (22L-6819)
* **Abdul Moiez** (22L-6849)

## 🎮 Game Features
- **Dynamic Environment:** Features a moving Hogwarts Express train, scrolling mountains, and a bridge.
- **Custom Resolution:** Uses **Mode 0x54** (132x43 resolution) for a widescreen cinematic experience.
- **Interactive Gameplay:** - Control a **Rabbit** that can jump over obstacles.
  - Collect **Carrots** to increase your score.
  - Real-time score tracking displayed at the top.
- **Intro Screen:** Professional instructions page before the game starts.

## 🛠️ Requirements
- **DOSBox** (Emulator)
- **NASM** (Assembler)

## 🚀 How to Run
1. Open DOSBox and mount your project folder:
mount c c:\path\to\your\folder
c:

3. Assemble the code using NASM:
nasm "game.asm" -o game.com

4. Run the game:
game.com


## ⌨️ Controls
- **UP ARROW:** Jump (Rabbit)
- **ESC:** Exit Game

## 📜 Technical Overview
The game directly manipulates **Video Memory (0xB800)** for high-performance rendering.
