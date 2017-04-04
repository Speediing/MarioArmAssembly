
.section .text

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
        ldr     r6, =0x1C9C380          // 30 seconds in hex
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
                mov     r5, r8
                mov     r6, r9
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
