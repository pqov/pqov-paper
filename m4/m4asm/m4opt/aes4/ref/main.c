#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "x86aesni.h"

static void dump(unsigned char ct[48]){
    printf("unsigned char ct[48] = {");
    for(int i=0;i<48;i++){
        if(i!=0) printf(",");
        printf("0x%02x", ct[i]);
    }
    printf("};\n");
}


int main(void){


    unsigned char key[32] = {0};
    unsigned char msg[48] = {0};
    unsigned char nonce[12] = {0};
    unsigned char ct[48];
    unsigned char ekey[240];


    AES256_Key_Expansion(key, ekey);
    AES256_CTR_Encrypt(ct, 3, ekey, nonce, 0);

    dump(ct);


    memset(key, 0x42, sizeof key);
    AES256_Key_Expansion(key, ekey);
    AES256_CTR_Encrypt(ct, 3, ekey, nonce, 0);

    dump(ct);

    return 0;
}   