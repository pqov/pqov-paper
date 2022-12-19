/// @file blas_neon.h
/// @brief Inlined functions for implementing basic linear algebra functions for NEON.
///

#ifndef _BLAS_NEON_H_
#define _BLAS_NEON_H_

#include "gf16.h"

#include "config.h"

#include "gf16_neon.h"


//#include "assert.h"




static inline
uint8x16_t _load_Qreg( const uint8_t * v , unsigned n ) {
    uint8_t temp[16];
    //n &= 15;
    for(unsigned i=0;i<n;i++) temp[i]=v[i];
    return vld1q_u8( temp );
}

static inline
void load_Qregs( uint8x16_t *r, const uint8_t * v , unsigned n ) {
    while( n>=16 ) {
        r[0] = vld1q_u8( v );
        r++;
        v+=16;
        n-=16;
    }
    if(n) r[0] = _load_Qreg(v,n);
}

static inline
void _store_Qreg( uint8_t * v , unsigned n , uint8x16_t a ) {
    uint8_t temp[16];
    //n &= 15;
    vst1q_u8( temp , a );
    for(unsigned i=0;i<n;i++) v[i] = temp[i];
}

static inline
void store_Qregs( uint8_t * v , unsigned n , const uint8x16_t *r ) {
    while( n>=16 ) {
        vst1q_u8( v , r[0] );
        r++;
        v+=16;
        n-=16;
    }
    if(n) _store_Qreg(v,n,r[0]);
}



//////////////////////   basic functions  ///////////////////////////////////////////////




static inline
void gf256v_add_neon( uint8_t * accu_b, const uint8_t * a , unsigned _num_byte ) {
	while( _num_byte >= 48 ) {
        uint8x16_t a0 = vld1q_u8(a);
        uint8x16_t a1 = vld1q_u8(a+16);
        uint8x16_t a2 = vld1q_u8(a+32);
        uint8x16_t b0 = vld1q_u8(accu_b);
        uint8x16_t b1 = vld1q_u8(accu_b+16);
        uint8x16_t b2 = vld1q_u8(accu_b+32);
		vst1q_u8( accu_b    , a0^b0 );
		vst1q_u8( accu_b+16 , a1^b1 );
		vst1q_u8( accu_b+32 , a2^b2 );
		_num_byte -= 48;
		a += 48;
		accu_b += 48;
	}
	while( _num_byte >= 16 ) {
		vst1q_u8( accu_b , vld1q_u8(a)^vld1q_u8(accu_b) );
		_num_byte -= 16;
		a += 16;
		accu_b += 16;
	}
	//for(unsigned j=0;j<_num_byte;j++) { accu_b[j] ^= a[j]; }
    while( _num_byte-- ) { *accu_b ^= *a; accu_b++; a++; }
}

static inline
void gf256v_conditional_add_neon( uint8_t * accu_b, uint8_t predicate, const uint8_t * a , unsigned _num_byte ) {
    uint8x16_t mm = vdupq_n_u8(-predicate);
	while( _num_byte >= 16 ) {
		vst1q_u8( accu_b , (mm&vld1q_u8(a))^vld1q_u8(accu_b) );
		_num_byte -= 16;
		a += 16;
		accu_b += 16;
	}
	//for(unsigned j=0;j<_num_byte;j++) { accu_b[j] ^= a[j]*predicate; }
    while( _num_byte-- ) { *accu_b ^= a[0]*predicate; accu_b++; a++; }
}


static inline
void gf256v_set_zero_neon( uint8_t * vec , unsigned _num_byte )
{
    uint8x16_t zero = vdupq_n_u8(0);
    while(_num_byte>=16) {
        vst1q_u8( vec , zero );
        _num_byte -= 16;
        vec += 16;
    }
    while(_num_byte--) { *vec=0; vec++; }
}

///////////////////////////////


static inline
void gf16v_mul_scalar_neon( uint8_t * a, uint8_t gf16_b , unsigned _num_byte ) {
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t bp = vdupq_n_u8(gf16_b&0xf);
#if defined(_GF16_REDUCE_WITH_TBL_)
    uint8x16_t mask_3 = vld1q_u8(__gf16_reduce);
#else
    uint8x16_t mask_3 = vdupq_n_u8( 3 );
#endif

    while( _num_byte >= 16 ) {
        uint8x16_t aa = vld1q_u8(a);
        vst1q_u8( a , _gf16v_mul_neon(aa,bp,mask_f,mask_3) );
        _num_byte -= 16;
        a += 16;
    }
    if(_num_byte) {
        uint8_t temp[16];
        for(unsigned j=0;j<_num_byte;j++) temp[j]=a[j];
        uint8x16_t aa = vld1q_u8(temp);
        vst1q_u8( temp , _gf16v_mul_neon(aa,bp,mask_f,mask_3) );
        for(unsigned j=0;j<_num_byte;j++) a[j]=temp[j];
    }
}



static inline
void gf16v_madd_neon( uint8_t * accu_c, const uint8_t * a , uint8_t gf16_b, unsigned _num_byte ) {
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t bp = vdupq_n_u8(gf16_b&0xf);
#if defined(_GF16_REDUCE_WITH_TBL_)
    uint8x16_t mask_3 = vld1q_u8(__gf16_reduce);
#else
    uint8x16_t mask_3 = vdupq_n_u8( 3 );
#endif
    while( _num_byte >= 16 ) {
        uint8x16_t aa = vld1q_u8(a);
        uint8x16_t cc = vld1q_u8(accu_c);
        vst1q_u8( accu_c , cc^_gf16v_mul_neon(aa,bp,mask_f,mask_3) );
        _num_byte -= 16;
        a += 16;
        accu_c += 16;
    }
    if(_num_byte) {
        uint8_t temp[16];
        for(unsigned j=0;j<_num_byte;j++) temp[j]=a[j];
        uint8x16_t aa = vld1q_u8(temp);
        vst1q_u8( temp , _gf16v_mul_neon(aa,bp,mask_f,mask_3) );
        for(unsigned j=0;j<_num_byte;j++) accu_c[j] ^= temp[j];
    }
}



static inline
void gf16v_madd_multab_neon( uint8_t * accu_c, const uint8_t * a , const uint8_t * multab , unsigned _num_byte ) {
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tbl = vld1q_u8( multab );

    while( _num_byte >= 16 ) {
        uint8x16_t aa = vld1q_u8(a);
        uint8x16_t cc = vld1q_u8(accu_c);
        vst1q_u8( accu_c , cc^_gf16_tbl_x2(aa,tbl,mask_f) );
        _num_byte -= 16;
        a += 16;
        accu_c += 16;
    }
    if(_num_byte) {
        uint8x16_t aa = _load_Qreg( a , _num_byte );
        uint8x16_t cc = _load_Qreg( accu_c , _num_byte );
        _store_Qreg( accu_c , _num_byte , cc^_gf16_tbl_x2(aa,tbl,mask_f) );
    }
}



/////////////////////   GF(256)  ///////////////////



static inline
uint8x16_t _gf256_tbl( uint8x16_t a , uint8x16_t tbl0 , uint8x16_t tbl1 , uint8x16_t mask_f ) {
    return vqtbl1q_u8( tbl0 , a&mask_f ) ^ vqtbl1q_u8( tbl1 , vshrq_n_u8( a , 4 ));
}


// WARNING: Assuming _num_byte >= 16
static inline
void _gf256v_madd_multab_neon( uint8_t * accu_c, const uint8_t * a ,
        uint8x16_t tbl0, uint8x16_t tbl1 , unsigned _num_byte , uint8x16_t mask_f )
{
    if(15&_num_byte) {
        uint8x16_t aa = vld1q_u8(a);
        uint8x16_t cc = vld1q_u8(accu_c);
        unsigned len = 15&_num_byte;
        _store_Qreg( accu_c , len , cc^_gf256_tbl(aa,tbl0,tbl1,mask_f) );
        _num_byte -= len;
        accu_c += len;
        a += len;
    }
    while( _num_byte >= 48 ) {
        uint8x16_t a0 = vld1q_u8(a);
        uint8x16_t a1 = vld1q_u8(a+16);
        uint8x16_t a2 = vld1q_u8(a+32);
        uint8x16_t c0 = vld1q_u8(accu_c);
        uint8x16_t c1 = vld1q_u8(accu_c+16);
        uint8x16_t c2 = vld1q_u8(accu_c+32);
        vst1q_u8( accu_c    , c0^_gf256_tbl(a0,tbl0,tbl1,mask_f) );
        vst1q_u8( accu_c+16 , c1^_gf256_tbl(a1,tbl0,tbl1,mask_f) );
        vst1q_u8( accu_c+32 , c2^_gf256_tbl(a2,tbl0,tbl1,mask_f) );
        _num_byte -= 48;
        a += 48;
        accu_c += 48;
    }
    while( _num_byte ) {
        uint8x16_t aa = vld1q_u8(a);
        uint8x16_t cc = vld1q_u8(accu_c);
        vst1q_u8( accu_c , cc^_gf256_tbl(aa,tbl0,tbl1,mask_f) );
        _num_byte -= 16;
        a += 16;
        accu_c += 16;
    }
}

static inline
void gf256v_madd_multab_neon( uint8_t * accu_c, const uint8_t * a , const uint8_t * multab , unsigned _num_byte ) {
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tbl0 = vld1q_u8( multab );
    uint8x16_t tbl1 = vld1q_u8( multab+16 );
    if(16>_num_byte) {
        uint8x16_t aa = _load_Qreg(a     ,_num_byte);
        uint8x16_t cc = _load_Qreg(accu_c,_num_byte);
        _store_Qreg( accu_c , _num_byte , cc^_gf256_tbl(aa,tbl0,tbl1,mask_f) );
    } else {
        _gf256v_madd_multab_neon( accu_c, a, tbl0, tbl1, _num_byte, mask_f );
    }
}


// WARNING: Assuming _num_byte >= 16
static inline
void _gf256v_mul_scalar_multab_neon( uint8_t * c, uint8x16_t tbl0, uint8x16_t tbl1 , unsigned _num_byte, uint8x16_t mask_f ) {
    if(15&_num_byte) {
        unsigned len = 15&_num_byte;
        uint8x16_t cc = vld1q_u8( c );
        _store_Qreg( c , len , _gf256_tbl(cc,tbl0,tbl1,mask_f) );
        c += len;
        _num_byte -= len;
    }
    while( _num_byte ) {
        uint8x16_t cc = vld1q_u8(c);
        vst1q_u8( c , _gf256_tbl(cc,tbl0,tbl1,mask_f) );
        _num_byte -= 16;
        c += 16;
    }
}


static inline
void gf256v_mul_scalar_multab_neon( uint8_t * c, const uint8_t * multab , unsigned _num_byte ) {
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tbl0 = vld1q_u8( multab );
    uint8x16_t tbl1 = vld1q_u8( multab+16 );
    if(16>_num_byte) {
        uint8x16_t cc = _load_Qreg( c , _num_byte );
        _store_Qreg( c , _num_byte , _gf256_tbl(cc,tbl0,tbl1,mask_f) );
    } else {
        _gf256v_mul_scalar_multab_neon( c, tbl0, tbl1, _num_byte, mask_f );
    }
}



static inline
void gf256v_mul_scalar_pmul_neon( uint8_t * a, uint8_t b , unsigned _num_byte )
{
    uint8x16_t bp = vdupq_n_u8(b);
#if defined(_GF256_REDUCE_WITH_TBL_)
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
    uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);
#else
    uint8x16_t mask_0x1b = vdupq_n_u8( 0x1b );
    uint8x16_t mask_3 = vdupq_n_u8( 3 );
#endif
    while( _num_byte>=16 ) {
        uint8x16_t aa = vld1q_u8(a);
#if defined(_GF256_REDUCE_WITH_TBL_)
        vst1q_u8( a , _gf256v_mul_neon(aa,bp,mask_f,tab_rd0,tab_rd1) );
#else
        vst1q_u8( a , _gf256v_mul_neon(aa,bp,mask_3,mask_0x1b) );
#endif
        _num_byte -= 16;
        a += 16;
    }
    if(_num_byte) {
        uint8x16_t aa = _load_Qreg(a,_num_byte);
#if defined(_GF256_REDUCE_WITH_TBL_)
        uint8x16_t bb = _gf256v_mul_neon(aa,bp,mask_f,tab_rd0,tab_rd1);
#else
       uint8x16_t bb = _gf256v_mul_neon(aa,bp,mask_3,mask_0x1b);
#endif
        _store_Qreg( a , _num_byte , bb );
    }
}


static inline
void gf256v_madd_pmul_neon( uint8_t * accu_c, const uint8_t * a , uint8_t b, unsigned _num_byte )
{
    uint8x16_t bp = vdupq_n_u8(b);
#if defined(_GF256_REDUCE_WITH_TBL_)
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
    uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);
#else
    uint8x16_t mask_0x1b = vdupq_n_u8( 0x1b );
    uint8x16_t mask_3 = vdupq_n_u8( 3 );
#endif

    while( _num_byte>=16 ) {
        uint8x16_t aa = vld1q_u8(a);
        uint8x16_t cc = vld1q_u8(accu_c);
#if defined(_GF256_REDUCE_WITH_TBL_)
        vst1q_u8( accu_c , cc^_gf256v_mul_neon(aa,bp,mask_f,tab_rd0,tab_rd1) );
#else
        vst1q_u8( accu_c , cc^_gf256v_mul_neon(aa,bp,mask_3,mask_0x1b) );
#endif
        _num_byte -= 16;
        a += 16;
        accu_c += 16;
    }
    if(_num_byte) {
        uint8x16_t aa = _load_Qreg(a,_num_byte);
        uint8x16_t cc = _load_Qreg(accu_c,_num_byte);
#if defined(_GF256_REDUCE_WITH_TBL_)
        uint8x16_t bb = _gf256v_mul_neon(aa,bp,mask_f,tab_rd0,tab_rd1);
#else
        uint8x16_t bb = _gf256v_mul_neon(aa,bp,mask_3,mask_0x1b);
#endif
        _store_Qreg( accu_c , _num_byte , bb^cc );
    }

}





static inline
void gf256v_mul_scalar_neon( uint8_t * a, uint8_t b , unsigned _num_byte )
{
    // run unit_tests/neon-vecmul-test for decide the number
    if( 48 <= _num_byte  ) {
        uint8x16_t mask_f = vdupq_n_u8( 0xf );
        uint8x16x2_t t = gf256v_get_multab_neon(b);
        _gf256v_mul_scalar_multab_neon( a , t.val[0] , t.val[1] , _num_byte , mask_f );
    } else {
        gf256v_mul_scalar_pmul_neon( a , b , _num_byte );
    }
}




static inline
void gf256v_madd_neon( uint8_t * accu_c, const uint8_t * a , uint8_t b, unsigned _num_byte )
{
    // run unit_tests/neon-vecmul-test for decide the number
    if( 48 <= _num_byte  ) {
        uint8x16_t mask_f = vdupq_n_u8( 0xf );
        uint8x16x2_t t = gf256v_get_multab_neon(b);
        _gf256v_madd_multab_neon( accu_c , a , t.val[0] , t.val[1] , _num_byte , mask_f );
    } else {
        gf256v_madd_pmul_neon( accu_c, a , b, _num_byte );
    }
}



///////////////////////



static inline
void gf16v_generate_multabs_neon( uint8_t * multabs, const uint8_t * v , unsigned n_ele )
{
    uint8x16_t tab_reduce = vld1q_u8(__gf16_reduce);
    uint8x16_t tab_0_f = vld1q_u8(__0_f);

    while( 2 <= n_ele ) {
        uint8x16_t b0 = vdupq_n_u8(v[0]&0xf);
        uint8x16_t b1 = vdupq_n_u8(v[0]>>4);
        uint8x16_t mm0 = _gf16v_get_multab_neon(b0,tab_reduce,tab_0_f);
        uint8x16_t mm1 = _gf16v_get_multab_neon(b1,tab_reduce,tab_0_f);
        vst1q_u8( multabs , mm0 ); multabs += 16;
        vst1q_u8( multabs , mm1 ); multabs += 16;
        n_ele -= 2;
        v++;
    }
    if( n_ele ) {
        uint8x16_t b0 = vdupq_n_u8(v[0]&0xf);
        uint8x16_t mm0 = _gf16v_get_multab_neon(b0,tab_reduce,tab_0_f);
        vst1q_u8( multabs , mm0 );
    }
}


static inline
void gf256v_generate_multabs_neon( uint8_t * multabs, const uint8_t * v , unsigned n_ele )
{
    uint8x16_t tab_0_f = vld1q_u8(__0_f);
    uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
    uint8x16_t mask_f  = vdupq_n_u8(0xf);
#if !defined(_MAC_OS_)
    uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);
#endif

    while(n_ele) {
#ifdef _MAC_OS_
        uint8x16x2_t tab = _gf256v_get_multab_neon( v[0] , mask_f , tab_0_f , tab_rd0 );
#else
        uint8x16x2_t tab = _gf256v_get_multab_neon( v[0] , mask_f , tab_0_f , tab_rd0 , tab_rd1 );
#endif
        vst1q_u8(multabs,tab.val[0]); multabs += 16;
        vst1q_u8(multabs,tab.val[1]); multabs += 16;
        v++;
        n_ele--;
    }
}


//////////////////////


static inline
void byte_transpose_16x16_neon( uint8_t *dest, unsigned dest_vec_len, const uint8_t *src , unsigned src_vec_len )
{
   uint8x16_t r0 = vtrn1q_u64( vld1q_u8( src+0*src_vec_len) , vld1q_u8( src+8*src_vec_len) );
   uint8x16_t r8 = vtrn2q_u64( vld1q_u8( src+0*src_vec_len) , vld1q_u8( src+8*src_vec_len) );
   uint8x16_t r1 = vtrn1q_u64( vld1q_u8( src+1*src_vec_len) , vld1q_u8( src+9*src_vec_len) );
   uint8x16_t r9 = vtrn2q_u64( vld1q_u8( src+1*src_vec_len) , vld1q_u8( src+9*src_vec_len) );
   uint8x16_t r2 = vtrn1q_u64( vld1q_u8( src+2*src_vec_len) , vld1q_u8( src+10*src_vec_len) );
   uint8x16_t r10 = vtrn2q_u64( vld1q_u8( src+2*src_vec_len) , vld1q_u8( src+10*src_vec_len) );
   uint8x16_t r3 = vtrn1q_u64( vld1q_u8( src+3*src_vec_len) , vld1q_u8( src+11*src_vec_len) );
   uint8x16_t r11 = vtrn2q_u64( vld1q_u8( src+3*src_vec_len) , vld1q_u8( src+11*src_vec_len) );
   uint8x16_t r4 = vtrn1q_u64( vld1q_u8( src+4*src_vec_len) , vld1q_u8( src+12*src_vec_len) );
   uint8x16_t r12 = vtrn2q_u64( vld1q_u8( src+4*src_vec_len) , vld1q_u8( src+12*src_vec_len) );
   uint8x16_t r5 = vtrn1q_u64( vld1q_u8( src+5*src_vec_len) , vld1q_u8( src+13*src_vec_len) );
   uint8x16_t r13 = vtrn2q_u64( vld1q_u8( src+5*src_vec_len) , vld1q_u8( src+13*src_vec_len) );
   uint8x16_t r6 = vtrn1q_u64( vld1q_u8( src+6*src_vec_len) , vld1q_u8( src+14*src_vec_len) );
   uint8x16_t r14 = vtrn2q_u64( vld1q_u8( src+6*src_vec_len) , vld1q_u8( src+14*src_vec_len) );
   uint8x16_t r7 = vtrn1q_u64( vld1q_u8( src+7*src_vec_len) , vld1q_u8( src+15*src_vec_len) );
   uint8x16_t r15 = vtrn2q_u64( vld1q_u8( src+7*src_vec_len) , vld1q_u8( src+15*src_vec_len) );

   uint8x16_t s0 = vtrn1q_u32( r0 , r4 );
   uint8x16_t s4 = vtrn2q_u32( r0 , r4 );
   uint8x16_t s1 = vtrn1q_u32( r1 , r5 );
   uint8x16_t s5 = vtrn2q_u32( r1 , r5 );
   uint8x16_t s2 = vtrn1q_u32( r2 , r6 );
   uint8x16_t s6 = vtrn2q_u32( r2 , r6 );
   uint8x16_t s3 = vtrn1q_u32( r3 , r7 );
   uint8x16_t s7 = vtrn2q_u32( r3 , r7 );
   uint8x16_t s8 = vtrn1q_u32( r8 , r12 );
   uint8x16_t s12 = vtrn2q_u32( r8 , r12 );
   uint8x16_t s9 = vtrn1q_u32( r9 , r13 );
   uint8x16_t s13 = vtrn2q_u32( r9 , r13 );
   uint8x16_t s10 = vtrn1q_u32( r10 , r14 );
   uint8x16_t s14 = vtrn2q_u32( r10 , r14 );
   uint8x16_t s11 = vtrn1q_u32( r11 , r15 );
   uint8x16_t s15 = vtrn2q_u32( r11 , r15 );

   r0 = vtrn1q_u16( s0 , s2 );
   r2 = vtrn2q_u16( s0 , s2 );
   r1 = vtrn1q_u16( s1 , s3 );
   r3 = vtrn2q_u16( s1 , s3 );
   r4 = vtrn1q_u16( s4 , s6 );
   r6 = vtrn2q_u16( s4 , s6 );
   r5 = vtrn1q_u16( s5 , s7 );
   r7 = vtrn2q_u16( s5 , s7 );
   r8 = vtrn1q_u16( s8 , s10 );
   r10 = vtrn2q_u16( s8 , s10 );
   r9 = vtrn1q_u16( s9 , s11 );
   r11 = vtrn2q_u16( s9 , s11 );
   r12 = vtrn1q_u16( s12 , s14 );
   r14 = vtrn2q_u16( s12 , s14 );
   r13 = vtrn1q_u16( s13 , s15 );
   r15 = vtrn2q_u16( s13 , s15 );

   vst1q_u8( dest+0*dest_vec_len , vtrn1q_u8( r0 , r1 ) );
   vst1q_u8( dest+1*dest_vec_len , vtrn2q_u8( r0 , r1 ) );
   vst1q_u8( dest+2*dest_vec_len , vtrn1q_u8( r2 , r3 ) );
   vst1q_u8( dest+3*dest_vec_len , vtrn2q_u8( r2 , r3 ) );
   vst1q_u8( dest+4*dest_vec_len , vtrn1q_u8( r4 , r5 ) );
   vst1q_u8( dest+5*dest_vec_len , vtrn2q_u8( r4 , r5 ) );
   vst1q_u8( dest+6*dest_vec_len , vtrn1q_u8( r6 , r7 ) );
   vst1q_u8( dest+7*dest_vec_len , vtrn2q_u8( r6 , r7 ) );
   vst1q_u8( dest+8*dest_vec_len , vtrn1q_u8( r8 , r9 ) );
   vst1q_u8( dest+9*dest_vec_len , vtrn2q_u8( r8 , r9 ) );
   vst1q_u8( dest+10*dest_vec_len , vtrn1q_u8( r10 , r11 ) );
   vst1q_u8( dest+11*dest_vec_len , vtrn2q_u8( r10 , r11 ) );
   vst1q_u8( dest+12*dest_vec_len , vtrn1q_u8( r12 , r13 ) );
   vst1q_u8( dest+13*dest_vec_len , vtrn2q_u8( r12 , r13 ) );
   vst1q_u8( dest+14*dest_vec_len , vtrn1q_u8( r14 , r15 ) );
   vst1q_u8( dest+15*dest_vec_len , vtrn2q_u8( r14 , r15 ) );
}



#endif // _BLAS_NEON_H_

