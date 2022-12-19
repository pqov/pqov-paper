
#include "hal-flash.h"
#include <string.h>

#ifdef KEYS_IN_FLASH

#if defined(STM32L4R5ZI)
#include <libopencm3/stm32/flash.h>
#define FLASH_PAGE_SIZE  0x1000
// starts at offset 1 MiB
// flash starts at 0x08000000
// our data starts at 0x08100000
#define FLASH_PAGE_START_IDX  256
// 768 KiB (there is some more space though)
#define FLASH_N_PAGES      192
#define FLASH_SIZE    ((FLASH_N_PAGES)*(FLASH_PAGE_SIZE))


#define FLASH_PAGE_OFFSET_PK 0
#define FLASH_PAGE_OFFSET_SK (FLASH_PAGE_OFFSET_PK + (CRYPTO_PUBLICKEYBYTES + FLASH_PAGE_SIZE - 1)/FLASH_PAGE_SIZE)

__attribute__((__section__(".flash_data"))) const unsigned char flash_data[FLASH_SIZE];

// pk: 412,160 bytes (101 pages)
// cpk: 66,592 (17 pages)
// sk: 348,704 (86 pages)
// csk: 64 (1 page)

// classic: pk + sk = 187 pages <-- worst case
// pkc: cpk + sk = 103 pages
// pkc+skc: cpk + csk + sk = 104 pages

static const unsigned char *pkflash = &flash_data[0];
static const unsigned char *skflash = &flash_data[FLASH_PAGE_OFFSET_SK*FLASH_PAGE_SIZE];

#ifdef _OV_PKC_SKC
#define FLASH_PAGE_OFFSET_TMP (FLASH_PAGE_OFFSET_SK + (CRYPTO_SECRETKEYBYTES + FLASH_PAGE_SIZE - 1)/FLASH_PAGE_SIZE)
static const unsigned char *tmpflash = &flash_data[FLASH_PAGE_OFFSET_TMP*FLASH_PAGE_SIZE];
#endif


static uint64_t byte_to_uint64_le(const unsigned char *d, size_t len){
    uint64_t v = 0;
    if(len > 0) v |= ((uint64_t)d[0]) << (8*0);
    if(len > 1) v |= ((uint64_t)d[1]) << (8*1);
    if(len > 2) v |= ((uint64_t)d[2]) << (8*2);
    if(len > 3) v |= ((uint64_t)d[3]) << (8*3);
    if(len > 4) v |= ((uint64_t)d[4]) << (8*4);
    if(len > 5) v |= ((uint64_t)d[5]) << (8*5);
    if(len > 6) v |= ((uint64_t)d[6]) << (8*6);
    if(len > 7) v |= ((uint64_t)d[7]) << (8*7);
    return v;
}

static int write_to_flash(const unsigned char *ptr, unsigned char *data, size_t len, size_t first_page){
    if(len > FLASH_SIZE) return -1;

    size_t last_page  = first_page + (len + FLASH_PAGE_SIZE - 1) / FLASH_PAGE_SIZE;


    // unlock flash
    flash_unlock();

    // erase flash
    for(size_t i=first_page;i<last_page;i++) flash_erase_page(i);

    // write to flash
    flash_program((uint32_t)ptr, data, len);
    if(len % 8){
        flash_program_double_word((uint32_t)(ptr + len - (len % 8)), byte_to_uint64_le(data + len - (len % 8), len % 8));
    }

    // lock flash
    flash_lock();

    return 0;
}


void write_pk_to_flash(unsigned char *pk)
{
    write_to_flash(pkflash, pk, CRYPTO_PUBLICKEYBYTES, FLASH_PAGE_START_IDX+FLASH_PAGE_OFFSET_PK);
}

void write_sk_to_flash(unsigned char *sk)
{
    write_to_flash(skflash, sk, CRYPTO_SECRETKEYBYTES, FLASH_PAGE_START_IDX+FLASH_PAGE_OFFSET_SK);
}

#ifdef _OV_PKC_SKC
void write_tmp_to_flash(unsigned char *tmp)
{
    write_to_flash(tmpflash, tmp, OV_SK_UNCOMPRESSED_BYTES, FLASH_PAGE_START_IDX+FLASH_PAGE_OFFSET_TMP);
}
#endif


const unsigned char *get_sk_flash()
{
    return skflash;
}

const unsigned char *get_pk_flash()
{
    return pkflash;
}

#ifdef _OV_PKC_SKC
const unsigned char *get_tmp_flash()
{
    return tmpflash;
}
#endif
#elif defined(MPS2_AN386)

static unsigned char pkflash[CRYPTO_PUBLICKEYBYTES];
static unsigned char skflash[CRYPTO_SECRETKEYBYTES];


#ifdef _OV_PKC_SKC
static unsigned char tmpflash[OV_SK_UNCOMPRESSED_BYTES];
#endif


void write_sk_to_flash(unsigned char *sk)
{
    memcpy(skflash, sk, CRYPTO_SECRETKEYBYTES);
}
void write_pk_to_flash(unsigned char *pk)
{
    memcpy(pkflash, pk, CRYPTO_PUBLICKEYBYTES);
}

#ifdef _OV_PKC_SKC
void write_tmp_to_flash(unsigned char *tmp)
{
    memcpy(tmpflash, tmp, OV_SK_UNCOMPRESSED_BYTES);
}
#endif


const unsigned char *get_sk_flash()
{
    return skflash;
}

const unsigned char *get_pk_flash()
{
    return pkflash;
}

#ifdef _OV_PKC_SKC
const unsigned char *get_tmp_flash()
{
    return tmpflash;
}
#endif


#endif


#endif