.data
    enter_n: .string "Enter n (0 < n <= 10): "
    bad_n: .string "N does not match constraint (0 < n <= 10)\n"
    
    enter_element: .string "Enter array element: "
    sep: .string " "
.text

j break

#####

.macro read_n(%x)
    jal    read_n
    mv     %x a0
.end_macro

read_n:
    la     a0 enter_n
    li     a7 4
    ecall
    li     a7 5 # reading n to t0
    ecall
    mv     t0 a0

    # check 0<n<=10
    bgtz   t0 okn0
    # here n <= 0
    la     a0 bad_n
    li     a7 4
    ecall
    j      read_n
    okn0:   

    li     t1 10
    ble    t0 t1 okn10
    # here 10 < n
    la     a0 bad_n
    li     a7 4
    ecall
    j      read_n
    okn10:

    # here 0 < n <= 10 (OK)
    mv     a0 t0
    ret

#####

.macro fill_A(%n, %array)
    mv     a0 %array
    mv     a1 %n
    jal    fill_A
.end_macro 

# array-begin = a0, size = a1
fill_A:
    mv     t0 a0
    mv     t1 a1      # counter n..0
    
    loop1:
    beqz   t1 end1
    la     a0 enter_element
    li     a7 4
    ecall
    li     a7 5
    ecall
    
    # a0 = element
    sw     a0 (t0)
    addi   t0 t0 4
    addi   t1 t1 -1
    j      loop1
    end1:
    ret

#####

.macro find_positive(%to, %n, %arr)
    mv     a0 %arr
    mv     a1 %n
    jal    find_positive
    mv     %to a0
.end_macro

# arr = a0, n = a1; ret = a0 = pos_idx
find_positive:
    li     t0 0 # first positive index
    mv     t1 a0

    loop2:
    beq    t0 a1 end2
    lw     t2 (t1)
    addi   t0 t0 1
    addi   t1 t1 4
    blez   t2 loop2
    # found! break
    addi   t0 t0 -1
    end2:

    mv     a0 t0
    ret

#####

.macro find_negative(%to, %n, %arr)
    mv     a0 %n
    mv     a1 %arr
    jal    find_negative
    mv     %to a0
.end_macro 

# n = a0, array = a1; ret = a0 = neg_idx
find_negative:
    mv     t0 a0     # last negative index
    mv     t1 a1 
    li     t2 0     # counter
    
    loop3:
    beq    t2 a0 end3
    lw     t4 (t1)
    addi   t2 t2 1
    addi   t1 t1 4
    bgez   t4 loop3
    mv     t0 t2
    addi   t0 t0 -1
    j loop3
    end3:
    mv     a0 t0
    ret

#####

.macro print_array(%array, %size)
    mv     a0 %array
    mv     a1 %size
    jal    print_array
.end_macro 


# a0 = array, a1 = size
print_array:
    mv     t0 a0
    mv     t1 a1

    loop4:
    beqz   t1 end4
    li     a7 1
    lw     a0 (t0)
    ecall
    addi   t0 t0 4
    addi   t1 t1 -1
    li     a7 4
    la     a0 sep
    ecall
    j      loop4
    end4:
    ret

#####

.macro fill_B(%size, %n, %pos_idx, %neg_idx, %arrayA, %arrayB)
    mv     a0 %n
    mv     a1 %pos_idx
    mv     a2 %neg_idx
    mv     a3 %arrayA
    mv     a4 %arrayB
    jal fill_B
    mv %size a0
.end_macro 

# n = a0, pos_idx = a1, neg_idx = a2
# arrayA = a3, arrayB = a4
# ret = size_b = a0
fill_B:
    li     t0 0  # counter
    li     t1 0  # res = size
    # a3 = iter over A
    # a4 = iter over B
    
    loop5:
    beq    t0 a0 end5
    lw     t6 (a3)
    mv     t5 t0
    addi   t0 t0 1
    addi   a3 a3 4
    beq    t5 a1 loop5 # skip first positive element
    beq    t5 a2 loop5 # skip last negative element
    sw     t6 (a4)
    addi   a4 a4 4
    addi   t1 t1 1
    j      loop5
    end5:
    mv a0 t1
    ret

#####



break: