/*
MarioMarioMarioMario
*/

.section    .init
.globl     _start

_start:
    b       main

.section .text
.globl main
main:
	mov	sp, #0x8000
	bl	EnableJTAG
	bl	InitFrameBuffer	        // Initialize the frame buffer for drawing
        bl      initGPIO                // Intializes GPIO
      	bl	clearScreen
        ldr  r0, =GameMap1
        ldr  r1, =GameMap
        ldr  r2, =EndMap1
        bl   switchMap

        bl      mainMenu

.globl StartGame
StartGame:
        bl      clearScreen

        ldr     r0,        =GameMap       // load initial map
        ldr     r1,        =EndMap        // load initial map
        bl      drawMap                   // draw initial map
        bl      Print_Init_Stats

read:
        bl      readButtons
	bl      read

.globl exitGame
exitGame:
        bl      clearScreen
        b       haltLoop$

.globl Restart_Game
Restart_Game:

	b read

.globl haltLoop$
haltLoop$:
	b	haltLoop$
