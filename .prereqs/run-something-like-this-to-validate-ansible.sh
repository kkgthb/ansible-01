ansible localhost -m 'ansible.builtin.stat' -a 'path=./helloworld.txt'     
# localhost | SUCCESS => {
#     "changed": false,
#     "stat": {
#         "exists": false
#     }
# }




ansible localhost -m 'ansible.builtin.file' -a 'path=./helloworld.txt state=touch'
# localhost | CHANGED => {
#     "changed": true,
#     "dest": "./helloworld.txt",
#     "gid": 123456,
#     "group": "example@example.com",
#     "mode": "0664",
#     "owner": "example@example.com",
#     "size": 0,
#     "state": "file",
#     "uid": 123456
# }



ansible localhost -m 'ansible.builtin.stat' -a 'path=helloworld.txt'     
# localhost | SUCCESS => {
#     "changed": false,
#     "stat": {
#         "atime": 1749697782.4307315,
#         "attr_flags": "e",
#         "attributes": [
#             "extents"
#         ],
#         "block_size": 4096,
#         "blocks": 0,
#         "charset": "binary",
#         "checksum": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
#         "ctime": 1749697782.4307315,
#         "dev": 2049,
#         "device_type": 0,
#         "executable": false,
#         "exists": true,
#         "gid": 123456,
#         "gr_name": "example@example.com",
#         "inode": 301509,
#         "isblk": false,
#         "ischr": false,
#         "isdir": false,
#         "isfifo": false,
#         "isgid": false,
#         "islnk": false,
#         "isreg": true,
#         "issock": false,
#         "isuid": false,
#         "mimetype": "inode/x-empty",
#         "mode": "0664",
#         "mtime": 1749697782.4307315,
#         "nlink": 1,
#         "path": "helloworld.txt",
#         "pw_name": "example@example.com",
#         "readable": true,
#         "rgrp": true,
#         "roth": true,
#         "rusr": true,
#         "size": 0,
#         "uid": 123456,
#         "version": "2646008039",
#         "wgrp": true,
#         "woth": false,
#         "writeable": true,
#         "wusr": true,
#         "xgrp": false,
#         "xoth": false,
#         "xusr": false
#     }
# }