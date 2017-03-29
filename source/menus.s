//
// Main menu and pause menu


.section .text

.globl mainMenu
mainMenu:
        push   {r2-r9, lr}
        bl      DrawMainMenuScreen   //print the main menu
        bl      DrawMenuMushroom     //print selection indictor (a mushroom)
        mov     r8, #0               //initialize state to 0 (start selected)

readMainMenuLoop:                       //FSM: state 0(start) and 1(quit)
        bl      readMainMenuButtons

        cmp     r0 ,#1              //up button pressed
        beq     MainUpPressed

        cmp     r0 ,#2              //down button pressed
        beq     MainDownPressed

        cmp     r0 ,#3
        beq     MainAPressed       //A button pressed
        b       readMainMenuLoop


.globl MainUpPressed
MainUpPressed:
        cmp     r8, #0          //if is state 0
        beq     readMainMenuLoop    //keep reading buttons (do nothing)

        bl      DrawMenuMushroom //if is state 1, switch to and draw state 0
        mov     r8, #0

        b       readMainMenuLoop      //keep reading menu buttons
.globl MainDownPressed
MainDownPressed:
        cmp     r8,#1            //if is state 1
        beq     readMainMenuLoop     //keep reading buttons (do nothing)
        mov     r8, #1
        bl      DrawMenuMushroom2 //if is state 0, switch to and draw state 1


        b       readMainMenuLoop
.globl MainAPressed
MainAPressed:
        cmp     r8, #0           //if state 0 (start) is selected
        beq     StartGame      //start game
        cmp     r8, #1           //if state 1 (quit) is selected
        beq     exitGame         //exit game

ExitMainMenu:
        pop    {r2-r9, lr}
        mov     pc,lr
//------------------------------------------------------------------------------------



//------------------------------------------------------------------------------------

.globl pauseMenu
pauseMenu:
        push    {r5, lr}
        mov     r5,     #1      // initialize r5 to resume mode
        bl      DrawPauseMenu
        bl      DrawMenuStar1

PauseLabel:
        b       readPauseButtons

.globl  PauseStPressed
PauseStPressed:
        b       PauseDone

.globl PauseDnPressed
PauseDnPressed:
        cmp     r5,     #1
        moveq   r5,     #2
        beq     DrawMenuStar2

        cmp     r5,     #2
        moveq   r5,     #3
        beq     DrawMenuStar3

        b       PauseNext

.globl PauseUpPressed
PauseUpPressed:
        cmp     r5,     #2
        moveq   r5,     #1
        beq     DrawMenuStar1

        cmp     r5,     #3
        moveq   r5,     #2
        beq     DrawMenuStar2
        b       PauseNext

.globl PauseAPressed
PauseAPressed:
        cmp     r5,     #1      //resume selected -> resume game
        beq     StartGame
        cmp     r5,     #2      //restart selected > restart game
        beq     main
        cmp     r5,     #3      //quit selected -> end Game
        beq     exitGame

PauseNext:
        ldr     r1, =0xfffff
        bl      Wait
        b       PauseLabel
PauseDone:
        pop     {r5, lr}
        mov     pc, lr
