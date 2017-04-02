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
  bl              Interrupt_Install_Table

	//mov	sp, #0x8000
	bl	EnableJTAG

  //b       IRQ
	bl	InitFrameBuffer	        // Initialize the frame buffer for drawing
        bl      initGPIO                // Intializes GPIO

        bl Interrupt
        bl	clearScreen



        ldr  r2, =livesNum
        mov  r3, #3
        streq r3, [r2]
        ldr  r0, =currentLevel
        mov  r1, #1
        strb  r1, [r0]


        bl      mainMenu



.globl StartGame
StartGame:

        bl      clearScreen
.globl ReStartGame
ReStartGame:
         ldr  r0, =GameMap1
         ldr  r1, =GameMap
         ldr  r2, =EndMap1
         bl   switchMap
        
        

        ldr     r0,        =GameMap       // load initial map
        ldr     r1,        =EndMap        // load initial map
        bl      drawMap                   // draw initial map
        bl      Print_Init_Stats
                        bl      Draw_Stats

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
