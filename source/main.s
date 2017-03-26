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

        bl      DrawMenuScreen  
        bl      DrawMenuMushroom    
 //       bl      DrawMenuMushroom2  

ReadMenu:        
        bl      readMenuButtons 
        b       ReadMenu
        
.globl ExitMenu
ExitMenu:
        bl      clearScreen
        
//        bl      clearScreen

        ldr     r0,        =GameMap       // load initial map
        ldr     r1,        =EndMap        // load initial map
        bl      drawMap                   // draw initial map

        



read:
        bl      readButtons

/*
	ldr		r0, =0x0000
	bl		FillScreen
	bl		Print_Menu_Start
	bl		Menu_Controller
  */
//	cmp		r1, #0
	bl    read




.globl endGame
endGame:




.globl Restart_Game
Restart_Game:

	b read



.globl haltLoop$
haltLoop$:
	b	haltLoop$
