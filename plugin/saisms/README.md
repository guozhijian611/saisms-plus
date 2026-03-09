# SaiSms 统一短信插件

## 简介

`saisms` 是基于 SaiAdmin / Webman 的统一短信插件，底层封装 `overtrue/easy-sms`，用于统一管理短信网关、短信模板标签以及发送记录。

插件当前提供三类核心能力：

- 短信网关配置管理
- 按业务标签发送短信
- 短信发送记录留痕

这意味着业务侧通常不需要直接对接具体厂商 SDK，只需要关心：

- 发给谁
- 用哪个标签
- 是否指定某个网关

## 功能特性

- 支持多短信服务商统一接入
- 支持多网关轮询发送
- 支持按标签组织短信模板
- 支持验证码发送记录与失败记录
- 支持通过后台直接测试发送
- 支持自定义扩展网关
- 已内置短信宝 `smsbao` 网关

## 目录结构

```text
plugin/saisms/
├── app/
│   ├── admin/
│   │   ├── controller/                    # 管理后台控制器
│   │   └── logic/                         # 管理后台逻辑层
│   ├── model/                             # 模型
│   ├── validate/                          # 验证器
│   └── functions.php                      # 工具函数
├── config/
│   ├── autoload.php                       # 自动加载函数文件
│   ├── log.php                            # 插件日志配置
│   └── saithink.php                       # 插件缓存配置
├── service/
│   ├── Sms.php                            # 统一短信发送入口
│   ├── Link.php                           # 自定义网关示例
│   └── Smsbao.php                         # 短信宝网关
└── README.md
```

## 数据表说明

插件依赖以下三张核心表：

### `saisms_config`

短信网关配置表，用于保存各网关的连接参数。

核心字段：

- `gateway`：网关标识，例如 `aliyun`、`smsbao`
- `config_name`：展示名称
- `config`：JSON 配置内容
- `status`：启用状态
- `sort`：排序值

### `saisms_tag`

短信标签表，用于把业务场景和短信模板绑定起来。

核心字段：

- `tag_name`：标签名称，例如 `login_code`
- `gateway`：该模板对应的网关
- `template_id`：模板编号
- `content`：短信内容

### `saisms_record`

短信发送记录表，用于记录验证码、网关、发送状态和响应内容。

## 已支持网关

当前内置：

- `aliyun`
- `qcloud`
- `qiniu`
- `baidu`
- `link`
- `smsbao`

说明：

- `link` 主要用于演示如何接入自定义服务商
- `smsbao` 为本仓库新增完善的短信宝接入

## 后台使用流程

### 1. 配置网关

进入 `SAISMS -> 短信配置`，为每个厂商新增一条配置。

系统发送时只会读取 `status = 1` 的网关，并按 `sort` 倒序参与选择。

### 2. 配置标签

进入 `SAISMS -> 短信标签`，按业务场景维护标签。

示例标签：

- `login_code`
- `register_code`
- `reset_password`

### 3. 发送测试

在标签列表中可直接点“发送测试”，快速验证：

- 网关配置是否正确
- 模板内容是否可用
- 目标手机号是否正常接收

### 4. 查看记录

进入 `SAISMS -> 短信记录` 可查看：

- 使用的网关
- 发送手机号
- 生成的验证码
- 发送结果
- 返回报文

## 业务接入方式

### 推荐方式：使用 `SmsRecordLogic::sendCode`

这是当前插件最适合业务层直接调用的方法。

它会自动处理：

- 生成 6 位验证码
- 校验发送频率
- 调用短信发送
- 写入发送记录
- 记录失败原因

示例：

```php
$smsLogic = new \plugin\saisms\app\admin\logic\SmsRecordLogic();

$result = $smsLogic->sendCode([
    'mobile' => '13800138000',
    'tag_name' => 'login_code',
]);
```

指定网关发送：

```php
$smsLogic = new \plugin\saisms\app\admin\logic\SmsRecordLogic();

$result = $smsLogic->sendCode([
    'mobile' => '13800138000',
    'tag_name' => 'login_code',
    'gateway' => ['smsbao'],
]);
```

### 底层方式：直接调用 `Sms::sendByTag`

如果你需要在特定逻辑中直接调用发送服务，也可以这样用：

```php
use plugin\saisms\service\Sms;

$result = Sms::sendByTag(
    '13800138000',
    'login_code',
    ['code' => '123456'],
    ['smsbao']
);
```

## 验证码校验示例

```php
$smsLogic = new \plugin\saisms\app\admin\logic\SmsRecordLogic();

$model = $smsLogic->where('mobile', $data['mobile'])
    ->where('status', 'success')
    ->order('create_time', 'desc')
    ->findOrEmpty();

if ($model->isEmpty() || ($model->is_verify == 1) || (strtotime($model->create_time) < time() - 5 * 60)) {
    throw new \plugin\saiadmin\exception\ApiException('验证码错误或已过期');
}

if ($model->code != trim($data['code'])) {
    throw new \plugin\saiadmin\exception\ApiException('验证码错误或已过期');
}

$model->is_verify = 1;
$model->save();
```

## 占位符替换规则

`content` 支持以下两种写法：

- `{code}`
- `${code}`

发送时会通过 [functions.php](./app/functions.php) 中的 `autoReplace()` 自动替换。

例如：

```text
【你的签名】您的验证码是{code}，5分钟内有效
```

## 短信宝配置示例

如果你要接入短信宝，请在 `SAISMS -> 短信配置` 中新增一条网关配置：

- `gateway`: `smsbao`
- `config_name`: `短信宝`
- `config.user`: 短信宝用户名
- `config.password`: 短信宝登录密码，支持填写明文密码或 32 位 MD5 值
- `config.api_key`: 可选。若已开通短信宝 ApiKey，可直接填写，优先级高于 `password`

标签配置说明：

- `template_id` 可留空
- `content` 需要填写完整短信内容
- 建议自行在 `content` 中带上短信签名

示例内容：

```text
【你的签名】您的验证码是{code}，5分钟内有效
```

## 默认行为

当前版本中的默认行为：

- 验证码长度：`6 位`
- 同一手机号最小发送间隔：`2 分钟`
- 配置变更后自动清理网关缓存

## 自定义网关扩展

如果需要新增服务商，建议参考以下文件：

- [Sms.php](./service/Sms.php)
- [Link.php](./service/Link.php)
- [Smsbao.php](./service/Smsbao.php)

基本步骤：

1. 新建一个网关类，继承 EasySms 的 `Gateway`
2. 实现 `send()` 方法
3. 在 `Sms::getSender()` 中通过 `extend()` 注册
4. 在后台新增对应 `gateway` 配置
5. 配置对应标签并测试发送

## 注意事项

1. 发送前请先确保网关配置已启用。
2. 标签必须与实际发送使用的网关一致。
3. 若新增配置后仍发送失败，请重启 Webman 服务。
4. 若宿主项目未安装 `overtrue/easy-sms`，发送会直接报错。
5. `saisms_record` 会保留验证码，请按你的业务安全要求决定是否需要额外脱敏或清理。
