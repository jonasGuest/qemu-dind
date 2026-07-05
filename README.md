
example mise file:

```
[tools]
"http:qemu-dind" = { version = "9f5c4ef", url = "https://github.com/jonasGuest/qemu-dind/archive/9f5c4ef.tar.gz", strip_components = 1 }

[env]
DOCKER_HOST = "tcp://127.0.0.1:2375"
```
