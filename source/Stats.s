/************************************************************************************/
//Stats.s
//This file displays the game stats at any point in the game.
/************************************************************************************/

/*
Global variables used (and initial value): These are stored in gameState.s, data section

livesNum:
        .byte  3


currentLevel:
        .byte  1


currentCoins:
        .byte  0


currentScore:
        .byte  0

*/

.section .text

/************************************************************************************/
/*Print_Init_Stats
/*Args: null
/*Return: null
/*This function prints the stats names (scores, lives, coins), initialized to 000
/************************************************************************************/

.globl Print_Init_Stats
Print_Init_Stats:
	push	        {r4-r10, lr}

	ldr		r0, =16			// starting x coordinate
	ldr		r1, =16			// starting y coordinate
	ldr		r2, =Scores                     // address of string
	bl		DrawString                     // draw string
	ldr		r0, =135			// starting x coordinate
	ldr		r1, =16			// starting y coordinate
	ldr		r2, =Zeros                     // address of string
	bl		DrawString                     // draw zeros

	ldr		r0, =336			// starting x coordinate
	ldr		r1, =16			// starting y coordinate
	ldr		r2, =Coins                      // address of string
	bl		DrawString                     // draw string
	ldr		r0, =489			// starting x coordinate
	ldr		r1, =16			// starting y coordinate
	ldr		r2, =Zeros                     // address of string
	bl		DrawString                     // draw zeros

        ldr		r0, =656			// starting x coordinate
	ldr		r1, =16			// starting y coordinate
	ldr		r2, =Lives                      // address of string
	bl		DrawString                     // draw string
	ldr		r0, =796			// starting x coordinate
	ldr		r1, =16			// starting y coordinate
	ldr		r2, =Zeros                     // address of string
	bl		DrawString                     // draw zeros

	pop		{r4-r10, lr}
	mov		pc, lr


/************************************************************************************/
/*Draw_Stats
/*Args:
/*Return:
/*This function displays the game stats (scores, coins, lives) on the screen
/************************************************************************************/
.globl  Draw_Stats
Draw_Stats:
				push	        {r0-r10, lr}

        ldr            r7, =currentScore
        ldr            r8, =currentCoins
        ldr            r9, =livesNum

        ldrb            r4, [r7]
        ldrb            r5, [r8]
        ldrb            r6, [r9]

        add             r4, #48
        add             r5, #48
        add             r6, #48                          //convert decimal to ascii

        mov             r0, #3
        mov             r1, #0
        mov             r2, #0
        bl              drawCell                        //erase previous score by redrawing background

				ldr							r0, =125      			// starting x coordinate
				ldr							r1, =16 			// starting y coordinate
				mov             r2, r4                         // ascii value of score
				bl							Draw_Char                     // draw updated score

        mov             r0, #15
        mov             r1, #0
        mov             r2, #0
        bl              drawCell                        //erase previous coin by redrawing background

				ldr							r0, =509			// starting x coordinate
				ldr							r1, =16		         	// starting y coordinatere
				mov             r2, r5                        // ascii updated score
				bl							Draw_Char                     // draw updated coins

        mov             r0, #24
        mov             r1, #0
        mov             r2, #0
        bl              drawCell                        //erase previous lives by redrawing background

				ldr							r0, =816			// starting x coordinate
				ldr							r1, =16			// starting y coordinate
			  mov             r2, r6                         // ascii updated lives
				bl							Draw_Char                     // draw updated lives

				pop							{r0-r10, lr}
				mov							pc, lr


/************************************************************************************/
/*Draw_String
/*Args: r0 = xPos, r1 = yPos, r2 = Colour, r3 = address of the string in data section
/*Return: null
/*This function draws the specified string on the screen starting at (x,y) by calling
/*draw_char
/************************************************************************************/

.globl DrawString
DrawString:
	push 	{r4-r10, lr}

	strAdr	        .req	r4
	px	        .req	r5
	py	        .req	r6

	mov	        px, r0
	mov	        py, r1
	mov	        strAdr, r2

	mov     	r8, #0
	ldrb	        r9, [strAdr]

DrawStringLoop:
	mov	        r0, px                  //x coordinate
	mov	        r1, py                  //y coordinate
	mov	        r2, r9                  //address
	bl	        Draw_Char               //draw character

	add	        r8, #1			//increment the index by 1
	add	        px, #10			//spacing between each characters

	ldrb	        r9, [strAdr, r8]	//load next character and increment address after

	cmp	        r9, #0			//check if reached the end of string

	bne	        DrawStringLoop

	.unreq	        strAdr
	.unreq	        px
	.unreq	        py

	pop 	        {r4-r10, lr}
	mov	        pc, lr

/************************************************************************************/
/*Draw_Char
/*Args: r0 = xPos, r1 = yPos, r2 = character to draw
/*Return: null
/*This function is derived from the tutorial example and made into a way such that
/*user can draw a specified character at coordinates (x,y)
/************************************************************************************/

.globl Draw_Char
Draw_Char:
	push		{r4-r10, lr}

	chAdr		.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask		.req	r8

	ldr		chAdr, 	=font		// load the address of the font map
	add		chAdr, 	r2, lsl #4	// char address = font base + (char * 16)

	mov		py, 	r1		// starting y coordinate
	mov		r9,	r0              // starting x coordinate

charLoop$:
	mov             px, r9  		// init the X coordinate

	mov	        mask, #0x01		//set the bitmask to 1 in the LSB

	ldrb	        row, [chAdr], #1	// load the row byte, post increment chAdr

rowLoop$:
	tst	        row, mask		// test row byte against the bitmask
	beq	        noPixel$

	mov	        r0, px                  // x coordinate
	mov	        r1, py                  // y coordinate
	ldr	        r2, =0xFFFF             // colour: white
	bl	        DrawPixel		// draw white pixel at (px, py)

noPixel$:
	add	        px, #1			// increment x coordinate by 1
	lsl	        mask, #1		// shift bitmask left by 1

	tst	        mask, #0x100		// test if the bitmask has shifted 8 times (test 9th bit)
	beq	        rowLoop$

	add     	py, #1			// increment y coordinate by 1

	tst	        chAdr, #0xF
	bne     	charLoop$		// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)


	.unreq	         chAdr
	.unreq	         px
	.unreq	         py
	.unreq	        row
	.unreq	        mask


	pop		{r4-r10, lr}
        mov             pc,     lr

/************************************************************************************/
// The data section stores all the characters/strings that the game stats will need
/************************************************************************************/

.section .data
.align 4

Scores:
        .asciz "SCORES X "

Lives:
        .asciz "LIVES X "

Coins:
        .asciz "COINS X "
	
zero:
        .asciz "0"

Zeros:
        .asciz "00"

font:
	.incbin "font.bin"
