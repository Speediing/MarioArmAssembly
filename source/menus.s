.section .text


//------------------------------------------------------------------------------------
printMenuStart:
        push {r4-r10,lr}
							
//	bl      DrawStartGameSelected
  //      bl      DrawQuitGame        

		
	pop		{r4-r10,lr}
	mov		pc, lr
//------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------
.globl mainMenu
mainMenu:
        push {r4,lr}
        //initalize gpio 
        //print the start and quit with the start selected so far
    //    bl printMenuStart

        //go into game wait method

        //this is the state, 0 for start selected 1 for quit selected
      //  mov r4, #0
menuWaitLoop:
       // bl ReadButtons

        //cmp r0 ,#4
        //beq       upPressed
        //r0 = 5 means down
        //cmp r0 ,#5
        //beq       downPressed
        //r0 = 8 means A
        //cmp r0 ,#8
       // beq       aPressed

upPressed:
        //cmp r4, #0
       // beq     menuWaitLoop
   
  //      bl      DrawStartGameSelected
    //    bl      DrawQuitGame       
        
        //changes state to 0
      //  mov r4, #0

        //b       menuWaitLoop
downPressed:
        //cmp r4,#1
        //beq     menuWaitLoop

        //bl      DrawStartGame
        //bl      DrawQuitGameSelected  

        //mov r4, #1
        //b               menuWaitLoop
aPressed:
   //     cmp r4, #0
   //     beq endMainMenu
   //     cmp r4, #1
    //    beq quitMain
quitMain:
        
//	mov		r0, #500
//	mov		r1, #600
//	ldr		r2, =0xFFFF
//	ldr		r3, =Quitting_Game
//	bl		Draw_String
	
//	ldr		r0, =0x0000
//	bl		FillScreen
  //      mov             r0 ,r4                
   //     b               quitEndMenu
        
endMainMenu:

     //   bl clearScreen

quitEndMenu:        
   //     pop {r4,lr}
     //   mov     pc,lr
//------------------------------------------------------------------------------------



//------------------------------------------------------------------------------------
.globl pauseMidGame
pauseMidGame:
       // push {lr}
PauseGame:
	//bl	DrawPauseFrame		//Draw the background of the pause menu

PauseRestartOption:
//	bl	DrawRestartGameSelected	//Default to restart
//	bl	DrawQuitGame
//	bl	ReadButtons

//	cmp	r0, #4			//If up, loop back
//	beq	PauseRestartOption
//	cmp	r0, #5			//If down, go to quit option
//	beq	PauseQuitOption
//	cmp	r0, #8			//If A, start game
//	beq	newGameLoop
//	cmp	r0, #3			//If start, resume!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //      beq	ExitPause
	//b	PauseRestartOption	//If none/other, loop back

PauseQuitOption:
//	bl	DrawQuitGameSelected
/*	bl	DrawRestartGame
	bl	ReadButtons
	cmp	r0, #4			//If up, go to restart option
	beq	PauseRestartOption
	cmp	r0, #5			//If down, loop back
	beq	PauseQuitOption

	cmp	r0, #8			//If A, return to main menu
        moveq   r0, #1
	beq	mainMainMenu

	cmp	r0, #3			//If start, resume!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	beq	ExitPause
	b	PauseQuitOption		//If none/other, loop back
ExitPause:
        bl	DrawGameBounds   
endPauseLoop:

        pop {lr}
        mov     pc,lr   
*/
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
/*
.section	.data
.align 4

Quitting_Game:
	.asciz	"Exiting program..."	*/
		
