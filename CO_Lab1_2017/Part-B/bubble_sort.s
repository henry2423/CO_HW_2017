.data
msg1:   .asciiz "The array before sort : \n"
msg2:   .asciiz "\nThe array after  sort : \n"
space:  .asciiz " "
Array:  .word 5, 3, 6, 7, 31, 23, 43, 12, 45, 1

.text
.globl main
#------------------------- main -----------------------------
main:
    # print msg1 on the console interface
    li      $v0, 4              # call system call: print string
    la      $a0, msg1           # load address of string into $a0
    syscall                     # run the syscall

    la      $a0, Array          # Copy the base address of your array into $a0
    add     $t0, $zero, $a0     # save return value in t0 (because v0 will be used by system call)
    
    # print the result of procedure factorial on the console interface
    lw      $a0, 0($t0)           
    li      $v0, 1             # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 4($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 8($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 12($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 16($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 20($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 24($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 28($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 32($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 36($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall




    la      $a0, Array          # Copy the base address of your array into $a0
    jal     sort

    move     $t0, $v0        # save return value in t0 (because v0 will be used by system call)     




    # print msg2 on the console interface
    li      $v0, 4              # call system call: print string
    la      $a0, msg2           # load address of string into $a0
    syscall                     # run the syscall

    # print the result of procedure factorial on the console interface
    lw      $a0, 0($t0)           
    li      $v0, 1             # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 4($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 8($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 12($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 16($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 20($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 24($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 28($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 32($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    lw      $a0, 36($t0)           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    li $v0, 10                  # call system call: exit
    syscall                     # run the syscall


#------------------------- procedure factorial -----------------------------
# load Array address in a0, return value in v0. 
.text   
sort:
    addi $sp, $sp, -8   # adiust stack for 1 items
    sw  $ra, 4($sp)     # save the return address
    sw  $a0, 0($sp)     # save the Array address 
    add $t0, $a0, 36    # move 40 bytes to record the end of array

outerLoop:            
    add $t1, $0, $0     # $t1 is a flag see the list is sorted
    la  $a0, Array      # Set $a0 to the base address of the Array (for every time loop in)

innerLoop:                  # The inner loop will iterate over the Array checking if a swap is needed
    lw  $t2, 0($a0)         # sets $t0 to the current in array
    lw  $t3, 4($a0)         # sets $t1 to the next in array
    slt $t4, $t2, $t3       # $t4 = 1 when $t2 < $t3
    bne $t4, $0, continue   # if $t5 = 1, then swap them, or continue to find next pair
    add $t1, $0, 1          # if swap, it need to check the list again
    jal swap                # jump to swap

continue:
    addi $a0, $a0, 4            # let $a0 point to next element
    bne  $a0, $t0, innerLoop    # If $a0 is not at the end of Array, jump back to innerLoop
    bne  $t1, $0, outerLoop     # $t1 = 1, another pass is needed, jump back to outterLoop
    lw   $ra, 4($sp)            # restore the return address
    lw   $a0, 0($sp)            # restore the Array address
    addi $sp, $sp, 8            # adjust stack pointer to pop 1 items
    move $v0, $a0               # Set $v0 as return address
    jr   $ra

swap:
    sw  $t2, 4($a0)         # store the greater numbers contents in the higher position in array
    sw  $t3, 0($a0)         # store the lesser numbers contents in the lower position in array
    jr  $ra



