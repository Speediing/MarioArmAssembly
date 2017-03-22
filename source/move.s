.section .text

/*
This subroutine moves Mario's position in the game map

Parameters:
        r0 - which button is pressed (which direction to move)

*/

//-------------------------------------------------------------------------------------
.globl readMario
readMario:
        push    {r4, r5, r6, r7, lr}
        mov     r6, #0                  //x coordinate of Mario
        mov     r7, #7                  //y coordinate of Mario
        ldr     r4, =GameMap
        add     r4, #175                //The upper most possible location for Mario (25*7=175) - coordinates (0, 7)

continueReadMario:
        ldrb    r5, [r4]
        cmp     r5, #3                  //check the cell contains Mario
        beq     returnMario
        add     r4, #1
        add     r6, #1                  //r6 contains the x coordinate of Mario
        cmp     r6, #25
        blt     continueReadMario
        add     r7, #1                  //increment y coordinate
        mov     r6, #0                  //reset x coordinate
        bl      continueReadMario

returnMario:

        mov     r0, r4                  //address of Mario
        mov     r1, r6                  //return x coordinate of Mario
        mov     r2, r7                  //return y coordinate of Mario
        pop     {r4, r5, r6, r7, lr}
        mov     pc,  lr

//-------------------------------------------------------------------------------------


.globl moveRight
moveRight:
        push    {r3-r10, lr}

        bl      readMario
        cmp     r1, #24                             //TODO: Make this make a new screen
        beq     endRight

         //update the gamestate
        mov     r3, #0
        mov     r4, #3
        mov     r5, r0                               //address of Mario
        strb    r3, [r0], #1
        strb    r4, [r0]

        mov     r6, r1                               //store current Mario XPos in r6
        mov     r7, r2                               //store current Mario YPos in r7

        mov     r0, r6
        mov     r1, r7
        mov     r2, #0                               //restore background sky

        bl      drawCell

        mov     r2, #3                               //#3 stands for Mario
        add     r0, r6, #1                           //XPos
        mov     r1, r7                               //YPos

        bl      drawCell

endRight:
        bl      gravity
        pop     {r3-r10,lr}
        mov     pc, lr

.globl moveLeft
moveLeft:
        push    {r3-r7, lr}

        bl      readMario
        cmp     r1, #0
        beq     endLeft

         //update the gamestate
        mov     r3, #0
        mov     r4, #3
        mov     r5, r0                               //address of Mario
        strb    r3, [r0], #-1
        strb    r4, [r0]

        mov     r6, r1
        mov     r7, r2

        mov     r0, r6
        mov     r1, r7
        mov     r2, #0                               //restore background sky

        bl      drawCell

        mov     r2, #3                               //#3 stands for Mario
        sub     r6, r6, #1
        mov     r0, r6                               //XPos
        mov     r1, r7                               //YPos

        bl      drawCell
endLeft:
        bl       gravity
        pop     {r3-r7,lr}
        mov     pc, lr

.globl jump
jump:                                               //loop that makes mario jump three squares
        push    {r2-r8, lr}


        bl      readMario

        //update the gamestate
        mov     r5, r0                               //address of Mario
        mov  r8, r0
        mov     r6, r1
        mov     r7, r2
        mov     r4, #0
jumploop:
        ldrb    r2,  [r8, #-25]
tst:    cmp     r2,  #0
        bne     endJump
        mov     r2, #0                               //restore background sky
        mov     r0, r6
        mov     r1, r7

        bl      drawCell
        ldr     r3, =0x1388
        bl      Wait				//wait for a second

        mov     r2, #3                               //#3 stands for Mario
        mov     r0, r6                                //XPos
        sub     r1, r7, #1                            //YPos
        mov     r7, r1
        bl      drawCell
        mov     r3, #0
        mov     r5, #3

        strb    r3, [r8], #-25
        strb    r5, [r8]
        ldr     r3, =0xffff
        bl      Wait				//wait for a second
        add     r4, #1
        cmp     r4, #4
        ble     jumploop
endJump:
    bl      gravity


        pop     {r2-r8,lr}
        mov     pc, lr
.globl runJump
runJump:                                               //loop that makes mario jump three squares
                push    {r3-r7, lr}


                bl      readMario

                //update the gamestate
                mov     r3, #0
                mov     r4, #3
                mov     r5, r0
                cmp  r8, #1
                bne     rjum                        //address of Mario
                strb    r3, [r0], #-130
                b       con
rjum:           strb    r3, [r0], #-120
con:            strb    r4, [r0]

                mov     r6, r1
                mov     r7, r2
                mov     r4, #0
rjumploop:
                mov     r2, #0                               //restore background sky
                mov     r0, r6
                mov     r1, r7

                bl      drawCell
                ldr     r3, =0x1388
                bl      Wait				//wait for a second

                mov     r2, #3                               //#3 stands for Mario
                cmp  r8, #1
                bne  righJump
                sub  r6, #1
                b    cont
righJump:       add  r6, #1
cont:           sub  r7, #1
                mov     r0, r6
                                               //XPos
                mov     r1, r7                            //YPos
                mov     r7, r1
                bl      drawCell
                ldr     r3, =0xffff
                bl      Wait				//wait for a second
                add     r4, #1
                cmp     r4, #4
                ble     rjumploop
                bl      gravity


                pop     {r3-r7,lr}
                mov     pc, lr
gravity:
        push    {r2-r7, lr}

checkUnder:
        bl      readMario                       //r1- x r2- y
        ldr     r4, =GameMap
        mov     r5, #25
        mul     r2, r5
        add     r1, r1, r2
        add     r4, r4,  r1
        add     r4, #25
        ldrb    r4, [r4]
        cmp     r4, #0
        bne     endGravity
        bl      readMario
        //update the gamestate
        mov     r3, #0
        mov     r4, #3
        mov     r5, r0                               //address of Mario
        strb    r3, [r0], #25
        strb    r4, [r0]
        mov     r6, r1
        mov     r7, r2
fall:
        mov     r2, #0                               //restore background sky
        mov     r0, r6
        mov     r1, r7

        bl      drawCell
        ldr     r3, =0xffff
        bl      Wait				//wait for a second

        mov     r2, #3                               //#3 stands for Mario
        mov     r0, r6                                //XPos
        sub     r1, r7, #-1                            //YPos
        mov     r7, r1
        bl      drawCell
        ldr     r3, =0xffff
        bl      Wait				//wait for a second
        b       checkUnder


endGravity:
        pop     {r2-r7, lr}
        mov  pc, lr
