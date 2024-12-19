#include "mbedtls/config.h"
#include "mbedtls/platform.h"
#include "mbedtls/net_sockets.h"
#include "mbedtls/ssl.h"
#include "mbedtls/entropy.h"
#include "mbedtls/ctr_drbg.h"
#include "mbedtls/error.h"

#include <stdio.h> // Make sure to include this for printf

int main() {
    mbedtls_net_context server_fd;
    mbedtls_ssl_context ssl;
    mbedtls_ssl_config conf;
    mbedtls_entropy_context entropy;
    mbedtls_ctr_drbg_context ctr_drbg;

    printf("Size of server_fd: %zu bytes\n", sizeof(server_fd));
    printf("Size of ssl: %zu bytes\n", sizeof(ssl));
    printf("Size of conf: %zu bytes\n", sizeof(conf));
    printf("Size of entropy: %zu bytes\n", sizeof(entropy));
    printf("Size of ctr_drbg: %zu bytes\n", sizeof(ctr_drbg));

    return 0;
}
