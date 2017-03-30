//

.section .text

// ************** CLEAR SCREEN FUNCTION *********************
.globl clearScreen
clearScreen:
        push    {r0-r12, lr}

	mov	r4,	#0			//x value
	mov	r5,	#0			//Y value
	mov	r6,	#0			//black color
	ldr	r7,	=1023			//Width of screen
	ldr	r8,	=767			//Height of the screen

Looping:
	mov	r0,	r4			//Setting x
	mov	r1,	r5			//Setting y
	mov	r2,	r6			//setting pixel color
	push    {lr}
	bl	DrawPixel
	pop     {lr}
	add	r4,	#1			//increment x by 1
	cmp	r4,	r7			//compare with width
	blt	Looping
	mov	r4,	#0			//reset x
	add	r5,	#1			//increment Y by 1
	cmp	r5,	r8			//compare with height
	blt	Looping
        pop     {r0-r12,lr}
	mov	pc,	lr			//return
//******************** CLEAR SCREEN FUNCTION **************************

/* Draw Pixel
 *  r0 - x
 *  r1 - y
 *  r2 - color
 */

//************************DRAW PIXEL FUNCTION ************************
.globl DrawPixel
DrawPixel:
	push	{r4-r10, lr}

	offset	.req	r4   	                        // offset = (y * 1024) + x = x + (y << 10)

	add		offset,	r0, r1, lsl #10

	lsl		offset, #1  	                // offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)

	ldr	        r0, =FrameBufferPointer  	// store the colour (half word) at framebuffer pointer + offset
	ldr	        r0, [r0]
	strh	        r2, [r0, offset]

	pop		{r4-r10, lr}
	mov             pc, lr
//************************DRAW PIXEL FUNCTION ****************************

//  ********************** DRAW WIN MESSAGE *******************
.globl DrawWinMessage
DrawWinMessage:

        push {r4,r5,r6,r7,r8,lr}
        ldr     r6,     =YouWin     // draws menu with cursor on resume
        mov     r4,     #235
        mov     r5,     #100

        ldr     r7,     =555    // Width of Pause menu (Asset dimensions are  360 x 432 )
        ldr     r8,     =164    // Height of MenuTitleScreen

drawWinMessageLoop:
	mov	r0,	r4			//passing x for ro which is used by the Draw pixel function
	mov	r1,	r5			//passing y for r1 which is used by the Draw pixel formula

	ldrh	r2,	[r6],#2			//setting pixel color by loading it from the data section. We load hald word
	bl	DrawPixel
	add	r4,	#1			//increment x position
	cmp	r4,	r7			//compare with image width
	blt	drawWinMessageLoop
	mov	r4,	#235			//reset x
	add	r5,	#1			//increment Y
	cmp	r5,	r8			//compare y with image height
	blt	drawWinMessageLoop
        ldr     r1, =0xffff
        bl      Wait				//wait for a second
        ldr     r2, =livesNum
        mov     r5, #3      // reset number of lives
        str     r5, [r2]
        ldr     r5, =currentLevel
        mov     r6, #1
        strb    r6,  [r5]
   //this is to test if any buttons is pressed, if yes, go to main menu and reset game -- needs fixing    
 temp:       bl      readMainMenuButtons
        cmp     r0, #0
        beq     gotoMainMenu
        cmp     r0, #1
        beq     gotoMainMenu       
        cmp     r0, #2
        beq     gotoMainMenu
        cmp     r0, #3
        beq     gotoMainMenu   
    
  gotoMainMenu:
      bl    mainMenu

        pop     {r4,r5,r6,r7,r8,lr}
	mov	pc,	lr
  //  ********************** DRAW WIN MESSAGE *******************


  //  ********************** DRAW LOSE MESSAGE *******************
  .globl DrawLoseMessage
  DrawLoseMessage:

          push {r4,r5,r6,r7,r8,lr}
          ldr     r6,     =YouLose     // draws menu with cursor on resume
          mov     r4,     #235
          mov     r5,     #100
          ldr     r7,     =713    // Width of Pause menu (Asset dimensions are  360 x 432 )
          ldr     r8,     =165    // Height of MenuTitleScreen

  drawLoseMessageLoop:
  	mov	r0,	r4			//passing x for ro which is used by the Draw pixel function
  	mov	r1,	r5			//passing y for r1 which is used by the Draw pixel formula

  	ldrh	r2,	[r6],#2			//setting pixel color by loading it from the data section. We load hald word
  	bl	DrawPixel
  	add	r4,	#1			//increment x position
  	cmp	r4,	r7			//compare with image with
  	blt	drawLoseMessageLoop
  	mov	r4,	#235			//reset x
  	add	r5,	#1			//increment Y
  	cmp	r5,	r8			//compare y with image height
  	blt	drawLoseMessageLoop
    ldr     r1, =0xffff
    bl      Wait				//wait for a second
    pop     {r4,r5,r6,r7,r8,lr}
  	mov	pc,	lr
    //  ********************** DRAW LOSE MESSAGE ************************

//************************DRAW MENU PAUSE SCREEN ******************************

.globl DrawPauseMenu
DrawPauseMenu:

        push {r4,r5,r6,r7,r8,lr}
        ldr     r6,     =PauseMenu     // draws menu with cursor on resume
        b       NextPause

NextPause:
        mov     r4,     #235
        mov     r5,     #100

        ldr     r7,     =595    // Width of Pause menu (Asset dimensions are  360 x 432 )
        ldr     r8,     =532    // Height of MenuTitleScreen

drawPauseMenuLoop:
	mov	r0,	r4			//passing x for ro which is used by the Draw pixel function
	mov	r1,	r5			//passing y for r1 which is used by the Draw pixel formula

	ldrh	r2,	[r6],#2			//setting pixel color by loading it from the data section. We load hald word
	bl	DrawPixel
	add	r4,	#1			//increment x position
	cmp	r4,	r7			//compare with image with
	blt	drawPauseMenuLoop
	mov	r4,	#235			//reset x
	add	r5,	#1			//increment Y
	cmp	r5,	r8			//compare y with image height
	blt	drawPauseMenuLoop

        pop     {r4,r5,r6,r7,r8,lr}
	mov	pc,	lr

//************************DRAW MAIN MENU SCREEN ******************************
.globl DrawMainMenuScreen
DrawMainMenuScreen:

        push {r4,r5,r6,r7,r8,lr}
        ldr     r6,     =mainMenuScreen    // draws menu with cursor on resume

        mov     r4,     #0
        mov     r5,     #0

        mov     r7,     #840    // Width of MenuTitleScreen
        mov     r8,     #680    // Height of MenuTitleScreen


drawMMLoop:
	mov	r0,	r4			//passing x for ro which is used by the Draw pixel function
	mov	r1,	r5			//passing y for r1 which is used by the Draw pixel formula

	ldrh	r2,	[r6],#2			//setting pixel color by loading it from the data section. We load hald word
	bl	DrawPixel
	add	r4,	#1			//increment x position
	cmp	r4,	r7			//compare with image with
	blt	drawMMLoop
	mov	r4,	#0			//reset x
	add	r5,	#1			//increment Y
	cmp	r5,	r8			//compare y with image height
	blt	drawMMLoop

        pop     {r4,r5,r6,r7,r8,lr}
	mov	pc,	lr			//return

//************************DRAW MENU TITLE SCREEN ******************************


//************************DRAW STAR FOR PAUSE MENU ******************************

.globl DrawMenuStar1
DrawMenuStar1:
        push {r0-r8,lr}

        mov	r0,	  #7      // Start X position of your picture
	mov	r1,	  #5       // Start Y Position
        mov     r2,       #11
        bl      drawCell

        mov	r0,	  #7      // Start X position of your picture
	mov	r1,	  #9       // Start Y Position
        mov     r2,       #12
        bl      drawCell


        mov	r0,	  #7      // Start X position of your picture
	mov	r1,	  #12       // Start Y Position
        mov     r2,       #12
        bl      drawCell


        pop     {r0-r8,lr}
	mov	pc,	lr

.globl  DrawMenuStar2
DrawMenuStar2:
        push {r0-r8,lr}

        mov	r0,	  #7    // Start X position of your picture
	mov	r1,	  #5       // Start Y Position
        mov     r2,       #12
        bl      drawCell

        mov	r0,	  #7      // Start X position of your picture
	mov	r1,	  #9       // Start Y Position
        mov     r2,       #11
        bl      drawCell

        mov	r0,	  #7      // Start X position of your picture
	mov	r1,	  #12       // Start Y Position
        mov     r2,       #12
        bl      drawCell

        pop     {r0-r8,lr}
	mov	pc,	lr

.globl  DrawMenuStar3
DrawMenuStar3:
        push {r0-r8,lr}

        mov	r0,	  #7     // Start X position of your picture
	mov	r1,	  #5       // Start Y Position
        mov     r2,       #12
        bl      drawCell

        mov	r0,	  #7      // Start X position of your picture
	mov	r1,	  #9       // Start Y Position
        mov     r2,       #12
        bl      drawCell

        mov	r0,	  #7      // Start X position of your picture
	mov	r1,	  #12       // Start Y Position
        mov     r2,       #11
        bl      drawCell

        pop     {r0-r8,lr}
	mov	pc,	lr
//************************DRAW STAR FOR PAUSE MENU ******************************


//************************DRAW MENU MUSHROOM*******************************
.globl DrawMenuMushroom
DrawMenuMushroom:
        push {r0-r8,lr}

        mov	r0,	  #6      // Start X position of your picture
	mov	r1,	  #12       // Start Y Position
        mov     r2,       #10
        bl      drawCell

        mov	r0,	  #6      // Start X position of your picture
	mov	r1,	  #14       // Start Y Position
        mov     r2,       #0
        bl      drawCell

        pop     {r0-r8,lr}
	mov	pc,	lr

.globl  DrawMenuMushroom2
DrawMenuMushroom2:
        push {r0-r8,lr}

        mov	r0,	  #6      // Start X position of your picture
	mov	r1,	  #12       // Start Y Position
        mov     r2,       #0
        bl      drawCell

        mov	r0,	  #6      // Start X position of your picture
	mov	r1,	  #14       // Start Y Position
        mov     r2,       #10
        bl      drawCell

        pop     {r0-r8,lr}
	mov	pc,	lr
//************************DRAW MENU MUSHROOM*******************************


//******************************* MAP DRAWING ****************************
.globl drawMap
drawMap:
        push    {r7-r10, lr}
        XPos    .req    r9
        Width   .req    r10
        YPos    .req    r11
        Height  .req    r12
        mov     XPos,   #0   // in terms of grid, not screen pixels
        mov     YPos,   #0
        mov     Width,  #34
        mov     Height, #34

        mov     r7,  r0
        mov     r8,  r1
        bl      DrawMapLoop

DrawMapLoop:
        ldrb    r2, [r7],  #1        // load indexed number from array, and increment pointer after

        mov	r0,	  XPos       // Start X position of your picture
	mov	r1,	  YPos       // Start Y Position
        bl      drawCell

        cmp     r8, r7               // check if reached end of array
        beq     ExitDraw             // if reach the end of the map stop drawing

        add     XPos,     #1         // increment x postion
        cmp     XPos,     #24        // width of game map

        ble     DrawMapLoop          // loop
        mov     XPos,     #0         // reset XPos
        add     YPos,     #1         // incrementy YPos
        b       DrawMapLoop

ExitDraw:
        bl      Print_Init_Stats
        pop     {r7-r10, lr}
        mov     pc, lr

//-------------------------------------------------------------------------------------
// Parameters: r0: XPos, r1: YPos, r2: element to draw
.globl drawCell
drawCell:
        // in order to draw past (0, 0) we need to increase r4 and r7 by the same amount
        push    {r3-r8, lr}
        cmp     r2,     #1
        beq     DrawGround
        cmp     r2,     #2
        beq     DrawPipe
        cmp     r2,     #3
        beq     DrawMario
        cmp     r2,     #4
        beq     DrawBrick
        cmp     r2,     #5
        beq     DrawQBox
        cmp     r2,     #6
        beq     DrawCloud
        cmp     r2,     #7
        beq     monster1
        cmp     r2,     #9
        beq     monster2
        cmp     r2,     #8
        beq     DrawCoin
        cmp     r2,     #10
        beq     DrawMushroom
        cmp     r2,     #11
        beq     DrawStar
        cmp     r2,     #12
        beq     DrawOrangeSquare
        cmp     r2,     #15
        beq     DrawCastle
	ldr	r6,	=Sky  		        //Address of the picture
        b       drawCellLoop

DrawCloud:
        ldr     r6,     =cloud
        b       drawCellLoop

DrawGround:
        ldr     r6,     =Ground
        b       drawCellLoop

DrawPipe:
        ldr     r6,     =pipe
        b       drawCellLoop

DrawMario:
        ldr     r6,     =Mario
        b       drawCellLoop

DrawBrick:
        ldr     r6,     =brick
        b       drawCellLoop

DrawQBox:
        ldr     r6,     =qBox
        b       drawCellLoop

monster1:
        ldr     r6,     =Goomba
        b       drawCellLoop
monster2:
        ldr     r6,     =Turle
        b       drawCellLoop
DrawCastle:
        ldr     r6,     =castle
        b       drawCellLoop



DrawCoin:
        ldr     r6,     =coin
        b       drawCellLoop
DrawMushroom:
        ldr     r6,     =selectionMushroom
        b       drawCellLoop
DrawStar:
        ldr     r6,     =PauseStar
        b       drawCellLoop
DrawOrangeSquare:
        ldr     r6,     =OrangeSquare


drawCellLoop:
        mov     r10,    #34                     //restate width
        mov     r12,    #34                     //restate height
        mul	r4,	r0,     Width           // Start X position of your picture (x coordinate * 34)
        mov     r3,     r4
	mul	r5,	r1,     Height          // Start Y Position                 (y coordinate * 34)

        add     r7,     r4,     Width
        add     r8,     r5,     Height
next:
	mov	r0,	r4			//passing x for r0 which is used by the Draw pixel function
	mov	r1,	r5			//passing y for r1 which is used by the Draw pixel formula

	ldrh	r2,	[r6],    #2	        //setting pixel color by loading it from the data section. We load half word
	bl	DrawPixel

        add	r4,	#1			//increment x position
	cmp	r4,	r7			//compare with image width

        blt     next
        mov	r4,	r3			//reset x
	add	r5,	#1			//increment Y
	cmp	r5,	r8			//compare y with image height
        blt     next

        pop     {r3-r8, lr}
	mov	pc,	lr			//return
