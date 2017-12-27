.data
msg1:   .asciiz "Enter first integers: "
msg2:   .asciiz "Enter second integers: "
msg3:   .asciiz "Greatest common divisor: "


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
    move    $t0, $v0            # $t0 = first integer


    # print msg2 on the console interface
    li      $v0, 4              # call system call: print string
    la      $a0, msg2           # load address of string into $a0
    syscall                     # run the syscall

    li      $v0, 5              # readInt
    syscall                     # return $v0
    move    $t1, $v0            # $a1 = second integer

    move    $a0, $t0
    move    $a1, $t1            # $a0, %a1 as argurmant
    jal     gcd
    move    $t0, $v0            # save return value in t0 (because v0 will be used by system call)


    # print msg3 on the console interface
    li      $v0, 4              # call system call: print string
    la      $a0, msg3           # load address of string into $a0
    syscall                     # run the syscall

    #load the answer to $a0
    move    $a0, $t0           
    li      $v0, 1              # call system call: print integer
    syscall                     # run the syscall


    li $v0, 10                  # call system call: exit
    syscall                     # run the syscall


#------------------------- procedure factorial -----------------------------
# load two integers in $a0 $a1, return value in v0. 
.text   
gcd:
    addi $sp, $sp, -4       # adiust stack for 1 items
    sw   $ra, 0($sp)        # save the return address
    addi $t0, $a0, 0        # move $a0 to $t0
    addi $t1, $a1, 0        # move $a1 to $t1
    beq  $t1, $0, find      # if $t1 == 0, return $t2
    div  $t0, $t1           # divid for mod
    mfhi $t2                # save $t0 % $t1 to $t2
    move $a0, $t1
    move $a1, $t2
    jal gcd

find:
    move $v0, $t0
    lw   $ra, 0($sp)            # restore the return address
    addi $sp, $sp, 4           # adjust stack pointer to pop 1 items
    jr   $ra

