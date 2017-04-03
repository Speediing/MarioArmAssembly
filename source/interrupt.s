/* 1. At the start of you program you should call the InstallTable function. This function is responsible
to install you interrupt table
a. Use the following command: bl Interrupt_Install_Table
b. This function should be the same as the one in the exercise. Make sure you push all your
registers to the stack.
2. After that you need to enable IRQ line in CPSR register and IRQ table
a. Update timer value. This will be current time + delay
b. For IRQ
i. Load the value in 0x3F00B210 and put it in r0
ii. Move 10 to r1 //10 since we are enabling IRQ line 1 and 3 you can also enable
only 1
iii. Store the value of r1 in r0
c. Disable all other interrupts
i. Load the value in 0x3F00B214 and put it in r0
ii. Move 0 to r1
iii. Store the value of r1 in r0
d. For cpsr_c register
i. mrs r0,cpscr
ii. bic r0, #0x80
iii. msr cpsr_c, r0
3. For the IRQ function that should be executed when the interrupt is executed, you should do the
following:
a. Test if timer1 did the interrupt
i. Load the values stored in 0x3F00B204 to r1
ii. Tst bit 2
iii. If result is zero go to e
b. Check if the game was paused
i. You should have a label in memory where you store in it if the game is paused
or not
ii. If paused you go to e
c. If a,b,c are all valid you draw your value pack.
d. Enable CS timer Control
i. Load the value stored in 0x3F003000
ii. Put 1 in bit 1 and the rest are zeroes
e. Update time in C1
f. Repeat (2)
g. Then subs pc, lr, #4
*/





.section .text

/*

.globl UpdateTimer
UpdateTimer:
        push            {r1-r12}
        pop             {r1-r12}



.globl initInterrupt
initInterrupt:
        push    {r0-r12}                        // push all registers to stack
        ,
        //bl              Interrupt_Install_Table         // install interrupt table, *** CALL THIS IN MAIN ***


/*
        // *** ?? HOW DO YOU: "a. Update timer value. This will be current time + delay" ?? ***


       	//b. enable GPIO IRQ lines on Interrupt Controller
	ldr		r0, =0x3F00B210			// Enable IRQs 2
	//mov		r1, #0x001E0000			// bits 17 to 20 set (IRQs 49 to 52)
        mov             r1, #10
        str		r1, [r0]

        // c. Disable all other interrupts
        ldr		r0, =0x3F00B214			// Enable IRQs 2
	//mov		r1, #0x001E0000			// bits 17 to 20 set (IRQs 49 to 52)
        mov             r1, #0
        str		r1, [r0]

	// d. For cpsr_c register
        mrs             r0, cpscr
        bic             r0, #0x80
        msr             cpsr_c, r0

        pop    {r0-r12}
        mov     pc, lr





*/

.globl Interrupt_Install_Table
Interrupt_Install_Table:
        push            {r0-r12}

        ldr		r0, =IntTable
	mov		r1, #0x00000000

	// load the first 8 words and store at the 0 address
	ldmia	        r0!, {r2-r9}
	stmia	        r1!, {r2-r9}

	// load the second 8 words and store at the next address
	ldmia	        r0!, {r2-r9}
	stmia	        r1!, {r2-r9}

	// switch to IRQ mode and set stack pointer
	mov		r0, #0xD2
	msr		cpsr_c, r0
	mov		sp, #0x8000

	// switch back to Supervisor mode, set the stack pointer
	mov		r0, #0xD3
	msr		cpsr_c, r0
	mov		sp, #0x8000000

        //pop            {r0-r12}
	bx		lr
        //mov             pc, lr



.globl Interrupt
Interrupt:
        push {r0-r12, lr}
        ldr     r4, =0x3F003004         // Load address  C0 (system clock)
        ldr     r5, [r4]                // Load actual time of system clock
b:
        ldr     r6, =0x1312D00          // 20 seconds in hex
        add     r5, r6                  // Add actual time into timer

        ldr     r7, =0x3F003010         // Load address C1 (timer)
        str     r5, [r7]                // Load actaul time plus 20 seconds into timer
c:

        ldr     r4, =0x3F00B210
        ldr     r5, =0xA
        str     r5, [r4]

         // 2. Enable IRQ
	mrs	r0, cpsr
	bic	r0, #0x80
	msr	cpsr_c, r0
        pop     {r0-r12, lr}
        bx lr

.globl IRQ
IRQ:
	push	{r0-r12, lr}

	// a. Test if timer1 did the interrupt
	ldr		r0, =0x3F00B204
	ldr		r1, [r0]
	tst		r1, #0x02		// bit 1
    //  cmp             r1, #0
        beq		Next


        // b. Check if the game was paused
        ldr     r7, =PauseFlag
        ldrb    r8, [r7]
        cmp     r8, #1
        beq     Next                 // if paused then branch to Next


d:
        // c. draw value pack
        //push   {lr}
        bl      RandomNumberGenerator
        mov     r9, r0                             //r9 == y
        mov     r8,  #20
        sub     r9, r8, r9
        bl      RandomNumberGenerator
        mov     r8, r0                             //r8 == x

        mov     r7, #25
        mov  r5, r8
          mov  r6, r9
        mul     r9 ,  r9 , r7
        add     r9, r8, r9
        ldr     r7, =GameMap
        ldrb    r2,  [r7, r9]
dogs:        cmp     r2, #0
        bne     d
        mov     r2, #13
        strb    r2,  [r7, r9]
        mov     r0, r5
        mov     r1, r6
        mov     r2, #13 // life muchroom
        bl      drawCell

notSky:

        //ldr     r5, =PauseFlag
        //ldrb    r6, [r5]

Wbreak:

        //pop   {lr}

Next:
        // d. Enable CS timer Control
        ldr             r0, =0x3F003000 //i. Load the value stored in 0x3F003000
    //  bic             r0, #0x1       //ii. Put 1 in bit 1 and the rest are zeros
        ldr r4, =0x02
        str r4, [r0]

        bl       Interrupt

irqEnd:
	pop		{r0-r12, lr}
	subs	        pc, lr, #4

hang:
	b		hang


.globl	RandomNumberGenerator
RandomNumberGenerator:
	push	{r1-r9, lr}

	ldr	r1, 	=w  		//5
	ldr	r2, 	=x  		//6
	ldr	r3,	=y  		//7
	ldr	r4, 	=z 	 	//8

	ldrb    r5,	[r1]       	//w
	ldrb    r6,	[r2]        	//x
	ldrb    r7,	[r3]        	//y
	ldrb    r8,	[r4]        	//z


	mov	r9,	r6			// mov x to t
	eor	r9,	r9,r9,lsl #11		// xor t shift by 11
	eor	r9,	r9,r9,lsl #8	        // xor t shift by 8
	mov	r6,	r7			// mov y to x
	mov	r7,	r8			// mov z to y
	mov     r8,	r5         		// mov w to z
	eor 	r5,	r5,r5,lsl #19		// xor w shift by 19
	eor 	r5,	r9			// xor w with t


	mov     r0, r5

	strb    r5, [r1]
	strb    r6, [r2]
	strb    r7, [r3]
	strb    r8, [r4]

	and     r0, #7

	pop     {r1-r9, lr}
	bx lr



.section .data

w:
	.byte	45
x:
	.byte   101
y:
	.byte  95
z:
	.byte  78


.section .data

IntTable:
	// Interrupt Vector Table (16 words)
	ldr		pc, reset_handler
	ldr		pc, undefined_handler
	ldr		pc, swi_handler
	ldr		pc, prefetch_handler
	ldr		pc, data_handler
	ldr		pc, unused_handler
	ldr		pc, irq_handler
	ldr		pc, fiq_handler

reset_handler:		.word Interrupt_Install_Table
undefined_handler:	.word hang
swi_handler:		.word hang
prefetch_handler:	.word hang
data_handler:		.word hang
unused_handler:		.word hang
irq_handler:		.word IRQ
fiq_handler:		.word hang
