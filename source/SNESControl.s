
// SNES control of the game

.section .text

.globl initGPIO

initGPIO:
        push    {lr}

        // Sets GPIO pin 9 (latch) to output
        ldr     r0, =0x3F200000                 // Address of GPFSEL0
        ldr     r1, [r0]
        mov     r2, #7                          // Bit clears (0111)
        lsl     r2, #27
        bic     r1, r2                          // Clearing pin 9 bits
        mov     r3, #1
        lsl     r3, #27
        orr     r1, r3
        str     r1, [r0]                         // Storing value back to GPFSEL0


        // Sets GPIO pin 10 (Data) to input
        ldr     r0, =0x3F200004                  // Address of GPFSEL1
        ldr     r1, [r0]
        mov     r2, #7
        bic     r1, r2                           // Bit clears (0111)
        mov     r3 , #0
        orr     r1, r3
        str     r1, [r0]                         // Stores value back to GPFSEL1


        //Sets GPIO pin 11 (Clock) to output
        ldr     r0, =0x3F200004                  // Address for GPFSEL1
        ldr     r1, [r0]
        mov     r2, #7
        lsl     r2, #3                           // Shift left by 3
        bic     r1, r2                           // Bit clears (0111)
        mov     r3 , #1
        lsl     r3, #3
        orr     r1, r3
        str     r1, [r0]                         // Stores value back to GPFSEL1

        pop     {lr}
	      mov	pc, lr


.globl  readButtons

readButtons:
        push    {r7, r9, lr}
        mov     r9, r0
        ldr     r1, =0xf1240
        //bl      Wait				//wait for a second
        bl      Read_SNES			//run the snes routine
        cmp     r5, r9
        beq     next
        mov     r5, #0

checkSt:
        mov     r7, r9
        lsr     r7, #3
        and     r7, #1
        cmp     r7, #0
        bne     checkUp

checkUp:
        mov     r7, r9
        lsr     r7, #4
        and     r7, #1
d:        cmp     r7, #0
        bne     checkL
        b       next

/*checkDn:
        mov     r7, r9
        lsr     r7, #5
        and     r7, #1
        cmp     r7, #0
        bne     checkL*/

checkL:
        mov     r7, r9
        lsr     r7, #6
        and     r7, #1
        cmp     r7, #0
        bne     checkR
        ldr     r1, =0x1388
        bl      Wait				//wait for a second
        bl      moveLeft
        mov  r5, #1
        ldr     r1, =0x1388
        bl      Wait				//wait for a second
        b       checkA
checkR:
        mov     r7, r9
        lsr     r7, #7
        and     r7, #1
        cmp     r7, #0
        bne     checkA
        ldr     r3, =0xffff
        //bl      Wait				//wait for a second
        bl      moveRight
        mov  r5, #2
        ldr     r3, =0xffff
        //bl      Wait				//wait for a second

        b       checkA

checkA:
        mov     r7, r9
        lsr     r7, #8
        and     r7, #1
        cmp     r7, #0
        bne     next
        ldr     r1, =0x1388
        bl      Wait				//wait for a second
        cmp  r5, #0
        mov  r8, r5
        beq     regJump
        bl      runJump
        b       next
regJump:        bl      jump
        ldr     r1, =0x1388
        bl      Wait				//wait for a second

next:
       b       readButtons

endRead:
        pop    {r7, r9, lr}
        mov     pc, lr


	//parameter r3 = time to wait
	//returns nothing
	///////////////
  .globl	Wait
  Wait:
          push    {r1, r2,  lr}
          ldr     r0, =0x3F003004                  // Addess of CLO
          ldr     r1, [r0]
          add     r1, r3

  WaitLoop:               // Waits for a time interval
          ldr     r2, [r0]
          cmp     r1, r2				// Stops when CLO = r1
          bhi     WaitLoop
          pop     {r1,r2, lr}
          mov     pc, lr




//////////////////////
	//Read_SNES
	//Primary function to get snes data
	//no parameters
	//returns the pressed buttons (r0)
	/////////////////
Read_SNES:

        push    {r4, r8, r9,lr}
        mov     r9, #0       		//init r9 for output
        mov     r1, #1
        bl      WriteClock		//write 1 on clock line
        bl      WriteLatch		//write 1 on latch line
        mov     r1, #12
        bl      Wait			//Wait for 12 microseconds
        mov     r1, #0
        bl      WriteLatch		//Bring latch back down to 0
        mov     r8, #0       		//init counter for each of the 16 bits
bitLoop:
        mov     r1, #6			//wait for 6 microseconds
        bl      Wait
        mov     r1, #0
        bl      WriteClock		//write 0 on clock line
        mov     r1, #6			//wait for 6 microseconds
        bl      Wait
        bl      ReadData		//check the dataline
        lsl     r4, r8			//shift the bit to allign with r8
        orr     r9, r4			//add it to the output
        mov     r1, #1
        bl      WriteClock		//write on the clock 1
        add     r8, #1
        cmp     r8, #16
        blt     bitLoop			//if r8<16 loop back
        mov     r0, r9
        pop     {r4, r8, r9,lr}
        mov     pc, lr



///////	/////////////////
	//Write_Clock
	//Function that writes either 1 or 0 on the clock line
	//Takes one parameter
	//1)the value to write(r1)
	//Returns nothing
	////////////////


WriteClock:
	push	{lr}
        mov   r0, #11
        ldr   r2, =0x3f200000		//gpio base register
        mov   r3, #1
        lsl   r3, r0
        teq   r1, #0			//test if the parameter is for write or clear
        streq r3, [r2, #40]		//gpio clear0
        strne r3, [r2, #28]		//gpio set0
        pop   {lr}
        mov   pc, lr


///////	/////////////////
	//Write_Latch
	//Function that writes either 1 or 0 on the latch line
	//Takes one parameter
	//1)the value to write(r1)
	//returns nothing
	////////////////


WriteLatch:
	push	{lr}
        mov 	r0, 	#9
        ldr 	r2, 	=0x3f200000		//base gpio register
        mov 	r3, 	#1
        lsl 	r3, 	r0
        teq 	r1, 	#0			//test if to write or clear
        streq 	r3, 	[r2, #40]		//gpio clear0
        strne 	r3, 	[r2, #28]		//gpio set 0
	pop	{lr}
        mov     pc, 	lr


///////	/////////////////
	//Read_Data
	//Reads a bit from the gpio data line at wherever BitNum(r4) is
	//takes the data and add it to output(r5)
	//takes no parameters
	//returns the new output of the controller(r4)
	/////////////////

ReadData:
	push	{lr}
        mov r0, #10
        ldr r2, =0x3f200000		//gpio base register
        ldr r1, [r2, #52]		//gplev0
        mov r3, #1
        lsl r3, r0
        and r1, r3
        teq r1, #0			//test if bit is 0 or not
        moveq r4, #0
        movne r4, #1
	pop	{lr}
        mov     pc, lr

stop:
        b       stop

haltLoop$:
	b	haltLoop$
