.data
msg1:   .asciiz "Pascal Triangle \nPlease enter the number of levels(1~30): "
space:  .asciiz " "
cr:     .asciiz "\n"


.text
.globl main
#------------------------- main -----------------------------
main:
    # print msg1 on the console interface
    li      $v0, 4              # call system call: print string
    la      $a0, msg1           # load address of string into $a0
    syscall                     # run the syscall

    li      $v0, 5              # readInt
    syscall                     # return $v0
    move    $a0, $v0            # $a0 = input levels, send to loop

    jal     pascal
    move    $t0, $v0            # save return value in t0 (because v0 will be used by system call)


    li $v0, 10                  # call system call: exit
    syscall                     # run the syscall


#------------------------- procedure factorial -----------------------------
# load Array address in a0, return value in v0. 
.text   
pascal:
    addi $sp, $sp, -4       # adiust stack for 1 items
    sw  $ra, 0($sp)         # save the return address
    addi $t5, $a0, 0        # move $a0 to $t5
    addi $t5, $t5, -1       # let the $t1 $t5 compare after become $t1 < $t5
    addi $t1, $0, -1         # $t1 is i, from i = 0 to i = $a0-1
    add $t3, $0, $0         # $t3 is temp which is pascal element number 

outerLoop:            
    addi $t1, $t1, 1            # $t1 is i, from i = 0 to i = $a0-1
    add $t2, $0, $0             # $t2 is j, from j = 0 to j = i
    beq $t2, $0, printtemp1     # if j == 0, then temp set to 1(jump to temp1) 

innerLoop:
    addi $t2, $t2, 1            # let j++                  
    #if
    beq $t2, $t1, printtemp1     # if j == i, then temp set to 1(jump to temp1)
    #else
    add $t4, $0, $0         # $t4 is for temporary calculation
    add $t4, $t4, $t1
    sub $t4, $t4, $t2
    addi $t4, $t4, 1
    mul $t3, $t3, $t4       
    div $t3, $t3, $t2       # temp = temp*(i-j+1)/j
    jal print               # jump to print

continue:
    bne  $t2, $t1, innerLoop    # If j <= i, then loop in innerLoop

    # print "\n"
    li      $v0, 4              # call system call: print string
    la      $a0, cr             # load address of string into $a0
    syscall                     # run the syscall

    bne  $t1, $t5, outerLoop    # If i < n, then loop in outerLoop
    lw   $ra, 0($sp)            # restore the return address
    addi $sp, $sp, 4           # adjust stack pointer to pop 1 items
    jr   $ra


printtemp1:
    add     $t3, $0, 1          # set temp to 1
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    move    $a0, $t3          
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall
    jal     continue
    

print:
    li      $v0, 4              # call system call: print string
    la      $a0, space          # load address of string into $a0
    syscall                     # run the syscall

    move    $a0, $t3         
    li      $v0, 1             # call system call: print integer
    syscall                     # run the syscall
    jal     continue
