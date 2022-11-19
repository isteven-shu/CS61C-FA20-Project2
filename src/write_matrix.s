.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    add s1, x0, a1
    add s2, x0, a2
    add s3, x0, a3

    # open file
    add a1, x0, a0
    addi a2, x0, 1
    jal fopen
    addi t0, x0, -1
    beq a0, t0, exception93
    add s0, x0, a0  # file descriptor

    # write file
    add a1, x0, s0
    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)
    add a2, x0, sp
    addi a3, x0, 2
    addi a4, x0, 4
    jal fwrite
    addi sp, sp, 8
    addi a3, x0, 2
    blt a0, a3, exception94

    add a1, x0, s0
    add a2, x0, s1
    add a3, x0, s2
    mul a3, a3, s3
    addi a4, x0, 4
    jal fwrite
    add a3, x0, s2
    mul a3, a3, s3
    blt a0, a3, exception94

    # close file
    add a1, x0, s0
    jal fclose
    bne a0, x0, exception95

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20

    ret

exception93:
    addi a1, x0, 93
    jal exit2

exception94:
    addi a1, x0, 94
    jal exit2

exception95:
    addi a1, x0, 95
    jal exit2
