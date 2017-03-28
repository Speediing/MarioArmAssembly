//

.section .text


//------------------------------------------------------------------------------------
//printMenuStart:
  //      push {r4-r10,lr}

//	bl      DrawStartGameSelected
  //      bl      DrawQuitGame


//	pop		{r4-r10,lr}
//	mov		pc, lr
//------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------
.globl mainMenu
mainMenu:
        push   {r2-r9, lr}
        bl      DrawMainMenuScreen   //print the main menu
        //bl      DrawMenuMushroom     //print selection indictor (a mushroom)
        mov     r5, #0                   //initialize state to 0 (start selected)
    //    bl      DrawMenuMushroom2

//ReadMenu:
        //bl      readMenuButtons
        //b       ReadMenu


/*

readMainMenuLoop: //FSM: state 0(start) and 1(quit)
        bl      readMainMenuButtons

        cmp r0 ,#1              //up button pressed
        beq     upPressed

        cmp r0 ,#2              //down button pressed
        beq     downPressed

        cmp r0 ,#3
        beq     aPressed        //A button pressed
        b       readMainMenuLoop

/*MenuMoveUp:
        bl      DrawMenuScreen
        bl      DrawMenuMushroom
        b       MenuNext
MenuMoveDown:
        bl      DrawMenuScreen
        bl      DrawMenuMushroom2
        b       MenuNext
MenuSelectA:
        b       endMenuRead*/


/*

upPressed:
        cmp     r5, #0          //if is state 0
        beq     readMenuLoop    //keep reading buttons (do nothing)

        bl      DrawMenuMushroom2 //if is state 1, switch to and draw state 0
        mov     r5, #0

        b       readMenuLoop      //keep reading menu buttons
downPressed:
        cmp     r5,#1            //if is state 1
        beq     readMenuLoop     //keep reading buttons (do nothing)

        bl      DrawMenuMushroom //if is state 0, switch to and draw state 1

        mov     r5, #1
        b       readMenuLoop
aPressed:
        cmp     r5, #0           //if state 0 (start) is selected
        beq     ExitMainMenu      //start game
        cmp     r5, #1           //if state 1 (quit) is selected
        beq     exitGame         //exit game

quitMain:

//	mov		r0, #500
//	mov		r1, #600
//	ldr		r2, =0xFFFF
//	ldr		r3, =Quitting_Game
//	bl		Draw_String

//	ldr		r0, =0x0000
//	bl		clearScreen
 //       mov             r0 ,r4
   //     b               quitEndMenu

*/


endMainMenu:

      //  bl clearScreen
        b       exitGame
//quitEndMenu:
        pop    {r2-r9, lr}
        mov     pc,lr
//------------------------------------------------------------------------------------



//------------------------------------------------------------------------------------

.globl StartPressed
StartPressed:
        push    {r5, lr}          
        mov     r5,     #1      // set r5 to resume mode        
        bl      DrawPauseMenu1
        b      readPauseButtons

.globl PauseDnPressed
PauseDnPressed:
        cmp     r5,     #1
        beq     DrawPause2 
        cmp     r5,     #2
        beq     DrawPause3      
        
.globl PauseUpPressed
PauseUpPressed:
        cmp     r5,     #2
        beq     DrawPause1 
        cmp     r5,     #3
        beq     DrawPause2 

DrawPause1:
        b       DrawPauseMenu1
        mov     r5, #1
        b       PauseNext
DrawPause2:
        b       DrawPauseMenu2
        mov     r5, #2
        b       PauseNext
DrawPause3:
        b       DrawPauseMenu3
        mov     r5, #3
        b       PauseNext

PauseNext:
        pop     {r5, lr}
        mov     pc, lr

       

PauseMenu:
       


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
