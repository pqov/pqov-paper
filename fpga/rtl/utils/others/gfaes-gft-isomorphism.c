
#include "stdio.h"
#include "stdint.h"
#define GF_BIT 8


// gf4 := gf2[x]/x^2+x+1
static inline uint8_t gf4_mul_2(uint8_t a) {
    uint8_t r = a << 1;
    r ^= (a >> 1) * 7;
    return r;
}
static inline uint8_t gf4_mul(uint8_t a, uint8_t b) {
    uint8_t r = a * (b & 1);
    return r ^ (gf4_mul_2(a) * (b >> 1));
}
///////////
// gf16 := gf4[y]/y^2+y+x
static inline uint8_t gf16_mul(uint8_t a, uint8_t b) {
    uint8_t a0 = a & 3;
    uint8_t a1 = (a >> 2);
    uint8_t b0 = b & 3;
    uint8_t b1 = (b >> 2);
    uint8_t a0b0 = gf4_mul(a0, b0);
    uint8_t a1b1 = gf4_mul(a1, b1);
    uint8_t a0b1_a1b0 = gf4_mul(a0 ^ a1, b0 ^ b1) ^ a0b0 ^ a1b1;
    uint8_t a1b1_x2 = gf4_mul_2(a1b1);
    return ((a0b1_a1b0 ^ a1b1) << 2) ^ a0b0 ^ a1b1_x2;
}
////////////
// gf256 := gf16[X]/X^2+X+xy
static inline uint8_t gf256_mul(uint8_t a, uint8_t b) {
    uint8_t a0 = a & 15;
    uint8_t a1 = (a >> 4);
    uint8_t b0 = b & 15;
    uint8_t b1 = (b >> 4);
    uint8_t a0b0 = gf16_mul(a0, b0);
    uint8_t a1b1 = gf16_mul(a1, b1);
    uint8_t a0b1_a1b0 = gf16_mul(a0 ^ a1, b0 ^ b1) ^ a0b0 ^ a1b1;
    uint8_t a1b1_x8 = gf16_mul(a1b1, 8);
    return ((a0b1_a1b0 ^ a1b1) << 4) ^ a0b0 ^ a1b1_x8;
}

////////////////////////////////////

static
void get_inv_mat( uint32_t * i_mat , const uint32_t * mat , unsigned l )
{
  uint32_t mat0[32];
  for(int i=0;i<l;i++) mat0[i]=mat[i];
  for(int i=0;i<l;i++) i_mat[i] = 1<<i;

  for(int i=0;i<l;i++) {
    uint32_t pivot = 1<<i;

    if( 0 == ( mat0[i]&pivot ) ) {
      for(int j=i+1;j<l;j++) {
        if( 0 == (mat0[j]&pivot) ) { continue; }
        mat0[i] ^= mat0[j];
        i_mat[i] ^= i_mat[j];
        break;
      }
    }
    for(int j=0;j<l;j++) {
      if( i==j ) continue;
      if( mat0[j]&pivot ) {
        mat0[j] ^= mat0[i];
        i_mat[j] ^= i_mat[i];
      }
    }
  }
}

//////////////////////////////////


void gen_matrix( uint32_t * mat , uint8_t gfele )
{
  mat[0] = 1;
  mat[1] = gfele;
  if (GF_BIT == 8) {
    for(int i=2;i<8;i++) mat[i] = gf256_mul(mat[i-1], gfele );
  }
  else {
    for(int i=2;i<4;i++) mat[i] = gf16_mul(mat[i-1], gfele );
  }
}

int is_legal_isomorphism( const uint32_t * x )
{
  if (GF_BIT == 8) {
    uint32_t x8 = gf256_mul( x[7] , x[1] );
    // aes reduce polynomial    x8 + x4 + x3 + x + 1
    uint32_t r = x8 ^ x[4] ^ x[3] ^ x[1] ^ 1;
    return (0==r)? 1 : 0;
  } else {
    uint32_t x4 = gf16_mul( x[3] , x[1] );
    // aes reduce polynomial    x4 + x + 1
    uint32_t r = x4 ^ x[1] ^ 1;
    return (0==r)? 1 : 0;
  }
}

int find_gfaes_to_gft_isomorphism( uint32_t * mat )
{
  if (GF_BIT == 8) {
    for(int i=16;i<256;i++) {
      uint8_t x = i;
      gen_matrix( mat , x );
      if( is_legal_isomorphism(mat) ) return 1;
    }
  } else {
    for(int i=4;i<16;i++) {
      uint8_t x = i;
      gen_matrix( mat , x );
      if( is_legal_isomorphism(mat) ) return 1;
    }
  }
  return 0;
}


void print_vector( uint32_t vec , int l )
{
  printf("[");
  for(int i=0;i<l;i++) {
    printf("%d,", (vec&(1<<i))?1:0 );
  }
  printf("],\n");
}

int main()
{
  uint32_t gfaes_to_gft[GF_BIT];
  find_gfaes_to_gft_isomorphism( gfaes_to_gft );
  printf("gfaes_to_gft = [\n");
  for(int i=0;i<GF_BIT;i++) print_vector( gfaes_to_gft[i] , GF_BIT );
  printf("]\n");
  printf("\n");

  uint32_t gft_to_gfaes[GF_BIT];
  get_inv_mat( gft_to_gfaes , gfaes_to_gft , GF_BIT );
  printf("gft_to_gfaes = [\n");
  for(int i=0;i<GF_BIT;i++) print_vector( gft_to_gfaes[i] , GF_BIT );
  printf("]\n");
  printf("\n");


  return 0;

}
