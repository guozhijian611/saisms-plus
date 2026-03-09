# saisms-plus

`saisms-plus` 是一个面向 SaiAdmin / Webman 项目的独立短信插件仓库，包含后端插件代码、管理后台页面、安装脚本以及升级脚本。

当前版本已经内置以下能力：

- 统一短信网关封装，底层基于 `overtrue/easy-sms`
- 短信配置管理
- 短信标签管理
- 短信发送记录管理
- 短信宝 `smsbao` 网关支持
- 自定义网关扩展示例 `link`

## 仓库结构

```text
saisms-plus/
├── plugin/saisms/                               # Webman 后端插件
├── saiadmin-artd/src/views/plugin/saisms/      # SaiAdmin 后台页面
├── install.sql                                  # 安装脚本
├── update.sql                                   # 升级脚本
├── uninstall.sql                                # 卸载脚本
├── info.ini                                     # 插件信息
└── config.json                                  # 依赖声明
```

## 适用场景

这个仓库不是一个可独立启动的完整业务项目，而是一个插件源码仓库，适合以下两种使用方式：

1. 把插件代码合并到现有的 SaiAdmin 项目中使用。
2. 作为二次开发仓库，继续增加新的短信服务商或业务接入逻辑。

## 依赖要求

- PHP `>= 8.1`
- Webman `2.x`
- SaiAdmin `6.x`
- Composer 依赖 `overtrue/easy-sms`

`config.json` 中已经声明：

```json
{
  "require": {
    "overtrue/easy-sms": "*"
  }
}
```

如果你的宿主项目还没有安装，请在宿主项目后端执行：

```bash
composer require overtrue/easy-sms
```

## 安装到宿主项目

以下说明基于典型的 SaiAdmin 项目目录：

```text
your-project/
├── server/
│   └── plugin/
├── saiadmin-artd/
└── ...
```

### 1. 复制后端插件代码

把本仓库的：

```text
plugin/saisms
```

复制到宿主项目：

```text
server/plugin/saisms
```

### 2. 复制后台前端页面

把本仓库的：

```text
saiadmin-artd/src/views/plugin/saisms
```

复制到宿主项目：

```text
saiadmin-artd/src/views/plugin/saisms
```

### 3. 导入数据库脚本

- 首次安装执行 [install.sql](./install.sql)
- 已安装旧版 `saisms`，升级时执行 [update.sql](./update.sql)
- 卸载时参考 [uninstall.sql](./uninstall.sql)

脚本会创建以下数据表：

- `saisms_config`
- `saisms_tag`
- `saisms_record`

同时会插入菜单和权限点，后台入口为：

- `SAISMS / 短信配置`
- `SAISMS / 短信标签`
- `SAISMS / 短信记录`

### 4. 重启后端服务

```bash
php start.php restart
```

### 5. 重新启动后台前端

```bash
cd saiadmin-artd
pnpm install
pnpm dev
```

## 支持的网关

当前仓库已内置以下网关：

- `aliyun`
- `qcloud`
- `qiniu`
- `baidu`
- `link`
- `smsbao`

其中：

- `link` 是自定义网关扩展示例
- `smsbao` 是本仓库已经补齐的短信宝网关

## 快速开始

### 1. 配置短信网关

进入后台 `SAISMS -> 短信配置`，新增或修改网关配置。

常见字段：

- `gateway`：网关标识，必须唯一
- `config_name`：网关名称
- `config`：该网关所需的 JSON 配置
- `status`：是否启用
- `sort`：排序值，越大越靠前

系统发送时会读取所有启用状态的网关，并按排序参与发送。

### 2. 配置短信标签

进入后台 `SAISMS -> 短信标签` 配置标签。

标签主要用于抽象业务场景，例如：

- `login_code`
- `register_code`
- `reset_password`

每个标签可绑定不同网关的模板信息：

- `template_id`：模板编号
- `content`：短信内容

变量占位符支持：

- `{code}`
- `${code}`

### 3. 测试发送

在 `短信标签` 页面可以直接使用“发送测试”功能验证配置是否生效。

### 4. 业务代码接入

推荐直接使用 `SmsRecordLogic::sendCode()`，因为它已经包含：

- 验证码生成
- 短信发送
- 发送记录落库
- 异常记录

示例：

```php
$smsLogic = new \plugin\saisms\app\admin\logic\SmsRecordLogic();

$result = $smsLogic->sendCode([
    'mobile' => '13800138000',
    'tag_name' => 'login_code',
]);
```

如果要指定网关发送：

```php
$smsLogic = new \plugin\saisms\app\admin\logic\SmsRecordLogic();

$result = $smsLogic->sendCode([
    'mobile' => '13800138000',
    'tag_name' => 'login_code',
    'gateway' => ['smsbao'],
]);
```

## 短信宝配置说明

短信宝网关标识为 `smsbao`。

后台新增短信配置时，可填写：

- `gateway`: `smsbao`
- `config_name`: `短信宝`
- `config.user`: 短信宝用户名
- `config.password`: 短信宝登录密码
- `config.api_key`: 可选，若已开通则优先使用

说明：

- `password` 支持明文密码，也支持 32 位 MD5 值
- 若填写了 `api_key`，发送时优先使用 `api_key`
- 短信宝主要依赖 `content` 发短信，`template_id` 可留空
- `content` 里建议直接带签名，例如 `【你的签名】您的验证码是{code}，5分钟内有效`

## 默认行为说明

当前插件代码中的默认行为如下：

- 同一手机号发送验证码的最小间隔为 `2 分钟`
- 验证码示例有效期通常按业务代码控制，示例中为 `5 分钟`
- 配置变更后会自动清理短信网关缓存

## 常见问题

### 1. 后台新增了配置但发送仍然报错

优先检查：

- 对应网关是否启用
- 标签是否绑定了正确网关
- 标签内容是否为空
- 宿主项目是否已经安装 `overtrue/easy-sms`
- 后端服务是否已经重启

### 2. 为什么短信宝的 `template_id` 可以为空

因为当前 `smsbao` 网关发送时主要使用最终拼接后的 `content` 内容。

### 3. 如何新增自己的服务商

可以参考：

- [Link.php](./plugin/saisms/service/Link.php)
- [Smsbao.php](./plugin/saisms/service/Smsbao.php)
- [Sms.php](./plugin/saisms/service/Sms.php)

新增网关类后，在 `Sms::getSender()` 中通过 `extend()` 注册即可。

## 相关文件

- 插件说明见 [plugin/saisms/README.md](./plugin/saisms/README.md)
- 插件信息见 [info.ini](./info.ini)
- 依赖声明见 [config.json](./config.json)
