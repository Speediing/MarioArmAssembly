//

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
        push    {r0-r10, lr}

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
        bl      checkEdge

endRight:
        bl      gravity

        pop     {r0-r10,lr}
        mov     pc, lr

.globl moveLeft
moveLeft:
        push    {r0-r10, lr}

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
        pop     {r0-r10,lr}
        mov     pc, lr

.globl jump
jump:                                               //loop that makes mario jump three squares
        push    {r2-r8, lr}


        bl      readMario

        //update the gamestate
        mov     r5, r0                               //address of Mario
        mov     r8, r0                               //address of Mario
        mov     r6, r1                               //XPos Mario
        mov     r7, r2                               //YPos Mario
        mov     r4, #0
jumploop:
        ldrb    r2,  [r8, #-25]                      //load the cell above
tst:    cmp     r2,  #0                              //check if the cell above is a sky cell
        bne     endJump                              //if not sky(question box or brick), Mario comes down

        mov     r2, #0                               //restore background sky
        mov     r0, r6
        mov     r1, r7
        bl      drawCell                              //draw sky

        ldr     r3, =0x1388
        bl      Wait			        	//wait for a second

        mov     r2, #3                                //#3 stands for Mario
        mov     r0, r6                                //XPos
        sub     r1, r7, #1                            //YPos
        mov     r7, r1
        bl      drawCell                                //draw Mario

        mov     r3, #0
        mov     r5, #3
        strb    r3, [r8], #-25                  //update game state
        strb    r5, [r8]                        //update game state
        ldr     r3, =0xffff
        bl      Wait				//wait for a second
        add     r4, #1
        cmp     r4, #4
        ble     jumploop

endJump:
                push    {lr}
                bl      gravity
                cmp     r2, #4                  //check if Mario hit a brick
                beq     hitBrick
                cmp     r2, #5                  //check if Mario hit a question booooox
                beq     hitQBox
                pop     {lr}


doneJump:       pop     {r2-r8,lr}
                mov     pc, lr


hitBrick:       push    {r5, lr}
                mov     r5,  #0
                strb    r5,  [r8, #-25]
                mov     r2,  #0
                sub     r7,  #1
                mov     r0,  r6
                mov     r1,  r7
                bl      drawCell
                pop     {r5, lr}
                mov     pc, lr


hitQBox:
                push    {r5, lr}

                mov     r5,  #0
                strb    r5,  [r8, #-25]         //QBox is in fact sky although not re-drawn on the screen, in order to prevent multiple coins
                mov     r5,  #8
                strb    r5,  [r8, #-50]
                mov     r2,  #8
                sub     r7,  #2
                mov     r0,  r6
                mov     r1,  r7
                bl      drawCell

                pop     {r5, lr}

                mov     pc, lr



.globl runJump
runJump:                                               //loop that makes mario jump three squares
                push    {r3-r9, lr}

                bl      readMario

                //update the gamestate
                mov     r3, #0                          //sky
                mov     r4, #3                          //Mario
                mov     r5, r0                          //address of Mario

//                cmp     r8, #1
//                bne     rjum
//                strb    r3, [r0], #-130
//                b       con
//rjum:           strb    r3, [r0], #-120
//con:            strb    r4, [r0]

                mov     r6, r1
                mov     r7, r2
                mov     r4, #0

//start of tst of endJump

                ldrb    r2,  [r8, #-25]                      //load the cell above
                cmp     r2,  #0                              //check if the cell above is a sky cell
                bne     endJump                              //if not sky(question box or brick), Mario comes down

//end tst



rjumploop:      cmp  r6, #24
                beq   end

                mov     r2, #0                               //restore background sky
                mov     r0, r6
                mov     r1, r7

                bl      drawCell
                ldr     r3, =0x1388
                bl      Wait				    //wait for a second

                mov     r2, #3                               //#3 stands for Mario
                cmp     r8, #1
                bne     righJump
                mov     r3, #0
                strb    r3, [r5], #-26
                ldrb    r2,  [r5, #-26]                      //load the cell above
                cmp     r2,  #0                              //check if the cell above is a sky cell
                movne   r4,  #4                              //if not sky(question box or brick), Mario comes down
                sub     r6, #1
                b       cont

righJump:       add     r6, #1
                mov     r3, #0
                strb    r3, [r5], #-24
                ldrb    r2,  [r5, #-24]                      //load the cell above
                cmp     r2,  #0                              //check if the cell above is a sky cell
                movne   r4,  #4                              //if not sky(question box or brick), Mario comes down

cont:
                mov     r9, #3
                strb    r9, [r5]
                sub     r7, #1
                mov     r0, r6

                mov     r1, r7
                mov     r7, r1

//start of tst of endJump

                //ldrb    r2,  [r8, #-25]                      //load the cell above
                //cmp     r2,  #0                              //check if the cell above is a sky cell
                //bne     endJump                              //if not sky(question box or brick), Mario comes down

//end tst
                mov     r2, #3  //delete later

                bl      drawCell
                ldr     r3, =0xffff
                bl      Wait				    //wait for a second
                add     r4, #1
                cmp     r4, #4
                ble     rjumploop
end:            bl      gravity

                pop     {r3-r9,lr}
                mov     pc, lr


gravity:
                push    {r2-r9, lr}

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
                strb    r3, [r0], #25                        //post-increment to erase Mario with sky
                strb    r4, [r0]                             //update Mario's position

                mov     r6, r1
                mov     r7, r2
fall:
                mov     r2, #0                               //restore background sky
                mov     r0, r6
                mov     r1, r7

                bl      drawCell
                ldr     r3, =0xffff
                bl      Wait				        //wait for a second

                mov     r2, #3                                 //#3 stands for Mario
                mov     r0, r6                                 //XPos
                sub     r1, r7, #-1                            //YPos
                mov     r7, r1
                bl      drawCell
                ldr     r3, =0xffff
                bl      Wait				//wait for a second
                b       checkUnder


endGravity:
                pop     {r2-r9, lr}
                mov     pc, lr


checkEdge:      push    {r0-r10, lr}
                //right edge of the map
                bl      readMario            //r0-adr, r1-x, r2-y
                cmp     r1,   #24
                bne     doneCheckEdge
                ldr  r7, =currentLevel
                ldrb  r5, [r7]
                cmp  r5, #2
                beq   mapThree
                ldr     r0,  =GameMap2
                ldr  r1,     =GameMap
                ldr  r2, =EndMap2
                mov  r6, #2
                strb  r6, [r7]
                b   switch
mapThree:

                ldr     r0,  =GameMap3
                ldr  r1,     =GameMap2
                ldr  r2, =EndMap3
                mov  r6, #3
                strb  r6, [r7]


switch:
                bl      switchMap  //future function: detect map?



                ldr     r0,  =GameMap2
                ldr     r1,  =EndMap2
                bl      drawMap
                bl      readButtons


doneCheckEdge:  pop     {r0-r10,lr}
                mov     pc, lr


//r0:new map, r1: old map, r2: end new Map
switchMap:

          push  {r4-r10, lr}
            mov  r4, #0
            mov  r5, r0
            mov  r6, r1
            mov  r7, r2
swapLoop:
          ldrb   r0, [r5], #1
          strb   r0, [r6], #1
          cmp    r5, r7
          bne     swapLoop
          pop     {r4-r10, lr}
          mov     pc, lr
