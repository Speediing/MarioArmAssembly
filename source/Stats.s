//  
//Menu.s
//Functions:
//Print_Menu_Start, Print_Menu_Quit, Print_Menu_Black_Start, Print_Menu_Black_Quit
//Print_Menu_Starting_Game, Print_Menu_Quitting_Game, Menu_Controller, Game_End_Menu
//Game_Over, Game_Win


.section .text

/*********************************************************************************/

//Print_Menu_Start
//Args: None
//Return: None
//This function sets the location and colours to print out the strings for game name etc.
//This function will print <> around the start.
/*********************************************************************************/
.globl Print_Init_Stats
Print_Init_Stats:
	push	{r4-r10, lr}

	ldr		r0, =0x10			// x coordinate
	ldr		r1, =0x10			// y coordinate
	ldr		r2, =0xFFFF	
	ldr		r3, =Scores
	bl		Draw_String

	ldr		r0, =0x150			// x coordinate
	ldr		r1, =0x10			// y coordinate
	ldr		r2, =0xFFFF	
	ldr		r3, =Coins
	bl		Draw_String

	ldr		r0, =0x290			// x coordinate
	ldr		r1, =0x10			// y coordinate
	ldr		r2, =0xFFFF	
	ldr		r3, =Lives
	bl		Draw_String

	pop		{r4-r10, lr}
	mov		pc, lr


/*********************************************************************************/
//Print_Menu_Starting_Game
//Args: None
//Return: None 
//This function prints out the Starting_Game string
/*********************************************************************************/
/*
.globl Print_Menu_Starting_Game
Print_Menu_Starting_Game:
	push	{r4-r10, lr}


	//Starting Game
	mov	r0, 	 #500		//x
	mov	r1,	 #600		//y
	ldr	r2,	 =0x0F00	// colour
	ldr	r3, 	 =Starting_Game
	bl	Draw_String

	ldr	r0, =0x0000		//Black
	bl	FillScreen		//FILL THE SCREEEEEEEEEEN

	pop	{r4-r10, lr}
	mov	pc, lr


*/


/*********************************************************************************/
//Print_Menu_Quitting_Game
//Args: None
//Return: None
//This function prints out the Quitting_Game string
/*********************************************************************************/
/*

.globl Print_Menu_Quitting_Game
Print_Menu_Quitting_Game:
	push	{r4-r10, lr}

	//Quitting Game
	mov	r0, 	#500
	mov	r1, 	#600
	ldr	r2, 	=0xFFFF
	ldr	r3, 	=Quitting_Game
	bl	Draw_String

	ldr	r0, 	=0x0000
	bl	FillScreen

	pop	{r4-r10, lr}
	mov	pc, lr
*/
/*********************************************************************************/
//Menu_Controller
//Args: r4 = start/quit flag 0 = START, 1 = QUIT
//Return: r1 = start/quit return flag 0 = START, 1 = QUIT
//This function determines which button is pressed on the main menu screen.
//The function runs on a loop waiting on input. When input is entered, it will
//be compared to up,down etc. Based on the flag it will determine what to print
//to the screen.
/*********************************************************************************/
/*
.globl Menu_Controller
Menu_Controller:
	push	{r4-r10, lr}
	mov	r4, #0

Menu_Wait:
	bl	 ReadButtons		//read in data

	//no input
	ldr     r1,	=0xFFFF
    	cmp     r0,	r1
    	beq     Menu_Wait

	//dpadup
   	ldr	r1,	=4
    	cmp	r0,	r1
	beq	dpadup_Menu

	//dpaddown_button:
	ldr	r1,	=5
	cmp	r0,	r1
	beq	dpaddown_Menu

	//A_button:
	ldr	r1,	=8
	cmp	r0,	r1
	beq	A_Menu

	b	Menu_Wait

dpadup_Menu:
	

	cmp	r4, 	#0				//Check if flag 0
	beq	Menu_Wait				//if 0, up does nothing

	cmp	r4, 	#1				//if 1, make <quit> black
	bleq	Print_Menu_Black_Quit

	cmp	r4, 	#1				//if 1, print <start>
	bleq	Print_Menu_Start

	moveq	r4,	 #0				//set flag to 0
	b	Menu_Wait

dpaddown_Menu:
	

	cmp	r4, 	#1				//Check if flag 1
	beq	Menu_Wait				//if 1, down does nothing

	cmp	r4,	 #0				//if 0, make <start> black
	bleq	Print_Menu_Black_Start

	cmp	r4, 	#0				//if 0, print <quit>
	bleq	Print_Menu_Quit

	moveq	r4,	 #1				//set flag to 0
	b	Menu_Wait


	
A_Menu:
	
	bl	Print_Menu_Black_Start			//set everything to black
	bl	Print_Menu_Black_Quit

	cmp	r4,	 #0				//if 0, start
	bleq	Print_Menu_Starting_Game
	moveq	r1, 	#0

	cmp	r4, 	#1				//if 1, end
	bleq	Print_Menu_Quitting_Game
	moveq	r1, 	#1

	b	Menu_Controller_Done


Menu_Controller_Done:
	pop	{r4-r10, lr}
	mov	pc, lr
/*********************************************************************************/
//The Game over Menu
//once game is over it prints out the Message Game over
//and if user presses start it sends them back to the main menu


/*********************************************************************************/
/*.globl Game_Over
Game_Over:

//Instructions
//Game Over

	push	{r4-r10, lr}
	
	ldr	r0,	=0x0000	
	bl	FillScreen

	mov	r0,	 #300
	mov	r1,	 #300
	ldr	r2, 	=0xC3FF
	ldr	r3, 	=Game_Over_String
	bl	Draw_String

	b	Game_Over_Done

Game_Over_Done:


	mov	r0, 	#300
	ldr	r1,	 =330
	ldr	r2, 	=0xC3FF
	ldr	r3, 	=Game_Over_Message
	bl	Draw_String

	bl	 Game_End_Menu

	pop	{r4-r10, lr}
	mov	pc, lr*/

/*********************************************************************************/
/*
.globl Game_End_Menu
Game_End_Menu:

	push	{r4-r10, lr}


Game_End_Wait:

	bl	ReadButtons			//read in data

	//no input
	ldr     r1,	 =0xFFFF
	cmp     r0, 	r1
	beq     Game_End_Wait

	//Start Button
 	ldr	r1, 	=0xFFF7
	cmp	r0, 	r1
	bleq	Reset_Game
	beq 	Game_End_Done

	bl	Restart_Game


Game_End_Done:
	pop	{r4-r10, lr}
	mov	pc, lr  */
/*********************************************************************************/
//Reset Game
//**********************************************************************************/
/*
.globl Reset_Game
Reset_Game:

push {lr}

  bl FillScreen
  //Start Game Again
  bl gameLoop

  pop {lr}
  mov pc, lr
*/
/*********************************************************************************/
//If game is Pause Mid Game
/*********************************************************************************/
/*
.globl pauseMidGame
pauseMidGame:

push	{r4-r12, lr}
	
	cmp	 r0,	 #4
	beq	NextPrint

NextPrint:
ldr	r0,	=22
ldr	r1,	=190
ldr	r2,	=0x0FEFE
ldr	r3, 	=PauseMenu
bl	Draw_String

ldr	r0,	=22
ldr	r1,	=220
ldr	r2,	=0x0FEFE
ldr	r3,	=InGameQuit
bl	Draw_String



ldr	r0,	=0
ldr	r1, 	=190
ldr	r2, 	=0x0FEFE	
ldr	r3, 	=fmt_Pointer			// address
bl	Draw_String				// print arrow

// Arrow pointing at "QUIT" is blacked out
ldr	r0,	=22				// x coor
ldr	r1,	=220				// y coor
ldr	r2,	=0x0000				// colour
ldr	r3,	=fmt_Pointer			// address

bl	Draw_String	

bl	ReadButtons

pop	{r4-r12, lr}
mov 	pc, lr */
/*********************************************************************************/
//Draw_Char
//Args: R0 = x, R1 = y, R2 = Colour, R3 = Character
//Return: None
//This function is a more general for of DrawCharB and allows for printing at a
//user specified (x,y) and a different Character
.globl Draw_Char
Draw_Char:
	push		{r4-r10, lr}

	chAdr		.req	r4
	px			.req	r5
	py			.req	r6
	row			.req	r7
	mask		.req	r8
	colour		.req	r9
	pxINIT		.req	r10

	ldr			chAdr, 	=font		// load the address of the font map
	add			chAdr, 	r3, lsl #4	// char address = font base + (char * 16)

	mov			colour, r2
	mov			py, 	r1			// init the Y coordinate (pixel coordinate)
	mov			pxINIT,	r0

charLoop$:
	mov     px, pxINIT			// init the X coordinate

	mov	mask, #0x01						//set the bitmask to 1 in the LSB
	
	ldrb	row, [chAdr], #1	// load the row byte, post increment chAdr

rowLoop$:
	tst	row, mask		// test row byte against the bitmask
	beq	noPixel$

	mov	r0, px
	mov	r1, py
	mov	r2, colour
	bl	DrawPixel		// draw r2 coloured pixel at (px, py)

noPixel$:
	add	px, #1			// increment x coordinate by 1
	lsl	mask, #1			// shift bitmask left by 1

	tst	mask, #0x100		// test if the bitmask has shifted 8 times (test 9th bit)
	beq	rowLoop$

	add	py, #1			// increment y coordinate by 1

	tst	chAdr, #0xF
	bne	charLoop$		// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)


	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask
	.unreq	colour
	.unreq	pxINIT

	pop	{r4-r10, lr}
	mov	pc, lr
//------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
//Draw_String
//Args: R0 = x, R1 = y, R2 = Colour, R3 = address of string
//Return: None
//This function takes in the address of a string in .asciz form and will print it out
//to the screen. It first loads the individual value and will then call the Draw_Char function.
//The function will loop until the /0 character is encountered.
.globl Draw_String
Draw_String:
	push 	{r4-r10, lr}	//*******do we push before or after .req

	senAdr	.req	r4
	px	.req	r5
	py	.req	r6
	colour	.req	r7


	mov	px, r0
	mov	py, r1
	mov	colour, r2
	mov	senAdr, r3

	mov	r8, #0	//index = 0

	ldrb	r9, [senAdr]

Draw_String_Loop:
	mov	r0, px
	mov	r1, py
	mov	r2, colour
	mov	r3, r9
	bl	Draw_Char

	add	r8, #1			//increment index
	add	px, #10			//*******increment spacing for letters*******CHANGE SPACING HERE

	ldrb	r9, [senAdr, r8] 	//load next letter in string
	
	cmp	r9, #0			//compare to /0
	bne	Draw_String_Loop
	
Draw_String_Loop_Done:
	.unreq	senAdr
	.unreq	px
	.unreq	py
	.unreq	colour	

	pop 	{r4-r10, lr}
	mov	pc, lr

.section .data
.align 4

Starting_Game:
	.asciz	"Mario Start!!"

Quitting_Game:
	.asciz	"Exiting Mario"

Game_Over_Message:
	.asciz	"Press <Start> to play again, press any button to return to main menu"


Scores:
        .asciz "SCORES X "

Lives: 
        .asciz "LIVES X "

Coins:
        .asciz "COINS X "


.globl fmt_Pointer
fmt_Pointer:		.asciz	">>"

font:
	.incbin "font.bin"

