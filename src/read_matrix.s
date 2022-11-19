.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

    add s1, x0, a1  # return address1
    add s2, x0, a2  # return address2
    # open file
    add a1, x0, a0
    addi a2, x0, 0
    jal fopen
    addi t0, x0, -1
    beq a0, t0, exception90
    add s0, x0, a0  # file descriptor
    # read rows and cols
    addi sp, sp, -8
    add a1, x0, s0
    add a2, x0, sp
    addi a3, x0, 8
    jal fread
    addi a3, x0, 8
    bne a0, a3, exception91
    lw s3, 0(sp)    # rows
    lw s4, 4(sp)    # cols
    addi sp, sp, 8
    # malloc
    add a0, x0, s3
    mul a0, a0, s4
    addi t0, x0, 4
    mul a0, a0, t0
    add s5, x0, a0  # num of bytes of the matrix
    jal malloc
    beq a0, x0, exception88
    add s6, x0, a0  # allocated address
    # read matrix
    add a1, x0, s0
    add a2, x0, s6
    add a3, x0, s5
    jal fread
    bne a0, s5, exception91

    add a1, x0, s0
    jal fclose
    bne a0, x0, exception92

    add a0, x0, s6
    sw s3, 0(s1)
    sw s4, 0(s2)

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret

exception88:
    addi a1, x0, 88
    jal exit2

exception90:
    addi a1, x0, 90
    jal exit2

exception91:
    addi a1, x0, 91
    jal exit2

exception92:
    addi a1, x0, 92
    jal exit2
