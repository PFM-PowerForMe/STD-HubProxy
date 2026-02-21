### 📦 环境变量配置说明

| 变量名 | 类型 | 默认值 | 示例 | 功能说明 |
| :--- | :---: | :---: | :--- | :--- |
| **CR_NGINX_REAL_IP** | String | `X-Forwarded-For` | `CF-Connecting-IP EO-Connecting-IP` | 设置反代时识别真实 IP 的请求头（如使用 Cloudflare 时修改） |
| **ENABLE_H2C** | Boolean | `false` | `true` | HTTP/2 多路复用 |
| **ENABLE_FRONTEND** | Boolean | `true` | `false` | 是否开启前端静态页面访问 |
| **MAX_FILE_SIZE** | Number | `2147483648` | `1073741824` | 单文件大小上限（单位：字节），默认 2GB |
| **RATE_LIMIT** | Number | `500` | `100` | 周期内最大允许的请求次数 |
| **RATE_PERIOD_HOURS** | Number | `3` | `1` | 限流统计周期（单位：小时） |
| **IP_WHITELIST** | String | - | `127.0.0.1,10.0.0.0/8` | IP 白名单，支持 CIDR 格式，多个用逗号分隔 白名单中的IP不受限流限制 |
| **IP_BLACKLIST** | String | - | `1.2.3.4` | IP 黑名单，命中的请求将被拒绝访问 |
| **MAX_IMAGES** | Number | `10` | `5` | 批量下载镜像的最大数量限制 |
| **CR_HUBPROXY_PROXY** | String | `127.0.0.1:1080` | * | 代理隧道 解决云平台被限制连接DockerHub问题 |
| **CR_WIREPROXY_CONF64** | String | * | `ABCD` | `使用 base64 -w 0 config 生成` |

---
