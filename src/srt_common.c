#include <pthread.h>
#include "srt_common.h"
#include "authenticator.h"
#include "published_stream.h"

void start_srt_thread(
        SRTSOCKET sock, char * addr, struct authenticator * auth,
        struct published_stream_map * map, void * (*thread_function)(void *))
{
    struct srt_thread_data * d = malloc(sizeof(struct srt_thread_data));
    d->sock = sock;
    d->addr = addr;
    d->auth = auth;
    d->map = map;

    pthread_t thread_handle;
    pthread_create(&thread_handle, NULL, thread_function, d);
}

#define SRT_STREAMID_MAX_LEN 512

char * get_socket_stream_id(SRTSOCKET sock) {
    char * name = malloc(sizeof(char) * SRT_STREAMID_MAX_LEN);
    int name_len = SRT_STREAMID_MAX_LEN;
    srt_getsockflag(sock, SRTO_STREAMID, name, &name_len);
    name = realloc(name, name_len);

    return name;
}