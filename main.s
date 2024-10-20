.include "helper.s"
.text
    # arrayA
    addi sp sp -40
    mv   s3 sp
    .eqv arrayA s3
    
    # n = s0, first_pos_idx = s1, last_neg_idx = s2
    read_n(s0)
    fill_A(s0, arrayA)
    
    find_positive(s1, s0, arrayA)
    find_negative(s2, s0, arrayA)
    
    # arrayB
    addi sp sp -40
    mv   s4 sp

    fill_B(s9, s0, s1, s2, arrayA, s4)
    
    print_array(sp, s9)

    # clear stack
    addi sp sp 80

    li   a7 10
    ecall
