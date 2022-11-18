# gramine-get-my-target-info-failure

`/dev/attestation/my_target_info` 文件在 gramine v1.3.1 无法被读取，而在 gramine v1.2 却可以被成功读取。

## 1. 问题复现

### 1.1. gramine v1.3.1 提示文件不存在

#### 1.1.1. 容器化 
```bash
# 确保 dockerize.sh 脚本中的 gramine_version 变量的值为 1.3.1
bash dockerize.sh
```

假设所得镜像名称为 `demo-gramine-get-my-target-info-failure:alpha-gramine1.3.1`。

#### 1.1.2. 运行

```bash
repo_tag=demo-gramine-get-my-target-info-failure:alpha-gramine1.3.1

docker run -it --rm                                   \
  --name xml-demo-gramine-get-my-target-info-failure  \
  --device /dev/kmsg:/dev/kmsg                        \
  --device /dev/sgx_enclave:/dev/sgx/enclave          \
  --device /dev/sgx_provision:/dev/sgx/provision      \
  $repo_tag
```

可见，无法读取到 target info，错误日志如下
```bash
Gramine is starting. Parsing TOML manifest file, this may take some time...
-----------------------------------------------------------------------------------------------------------------------
Gramine detected the following insecure configurations:

  - loader.insecure__use_cmdline_argv = true   (forwarding command-line args from untrusted host to the app)

Gramine will continue application execution, but this configuration must not be used in production!
-----------------------------------------------------------------------------------------------------------------------

Error: "read: No such file or directory (os error 2)"
```

### 1.2. gramine v1.2 成功获取到数据
#### 1.2.1. 容器化
```bash
# 调整 dockerize.sh 脚本中的 gramine_version 变量的值为 1.2
bash dockerize.sh
```

假设所得镜像名称为 `demo-gramine-get-my-target-info-failure:alpha-gramine1.2`。

#### 1.2.2. 运行

```bash
repo_tag=demo-gramine-get-my-target-info-failure:alpha-gramine1.2

docker run -it --rm                                   \
  --name xml-demo-gramine-get-my-target-info-failure  \
  --device /dev/kmsg:/dev/kmsg                        \
  --device /dev/sgx_enclave:/dev/sgx/enclave          \
  --device /dev/sgx_provision:/dev/sgx/provision      \
  $repo_tag
```

可见能够成功产出 target info 如下
```bash
Gramine is starting. Parsing TOML manifest file, this may take some time...
-----------------------------------------------------------------------------------------------------------------------
Gramine detected the following insecure configurations:

  - loader.insecure__use_cmdline_argv = true   (forwarding command-line args from untrusted host to the app)

Gramine will continue application execution, but this configuration must not be used in production!
-----------------------------------------------------------------------------------------------------------------------

hex(my_target_info) = 8b6920f108879865e6488eac250c9f25be95ecccd792071cdb77f5223a722be8050000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
```
