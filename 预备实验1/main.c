#include <stdio.h>

//main.c

int main()
{
    int a, b, i, t, n;
    a = 0;
    b = 1;
    i = 1;
    scanf("%d", &n); 
    printf("%d\n", a); 
    printf("%d\n", b);
    
    while (i < n)
    {
        t = b;
        b = a + b;
        printf("%d\n", b); 
        a = t;
        i = i + 1;
    }
    
    return 0;  
}


//clang -ccc-print-phases main.c
//预处理：gcc main.c -E -o main.i
//词法分析：clang -E -Xclang -dump-tokens main.c
//语法分析：clang -E -Xclang -ast-dump main.c
//文本版AST(raw)：gcc -fdump-tree-original-raw main.c
//文本版AST(经过美化)：gcc -fdump-tree-original main.c
//语义分析：clang -S -emit-llvm main.c
//中间表示：gcc -fdump-tree-all-graph main.c 
//LLVM：llc main.ll -o main-llvm.S
//x86：gcc main.i -S -o main-x86.S
//arm：arm-linux-gnueabihf-gcc main.i -S -o main-arm.S