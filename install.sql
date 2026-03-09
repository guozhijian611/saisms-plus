-- ----------------------------
-- Table structure for saipay_order
-- ----------------------------
CREATE TABLE IF NOT EXISTS `saisms_config`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '编号',
  `gateway` varchar(50) DEFAULT NULL COMMENT '网关标识',
  `config_name` varchar(50) DEFAULT NULL COMMENT '网关名称',
  `config` varchar(1000) DEFAULT NULL COMMENT '配置',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态',
  `sort` smallint(6) NULL DEFAULT 100 COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) NULL DEFAULT NULL COMMENT '创建人',
  `updated_by` int(11) NULL DEFAULT NULL COMMENT '更新人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime(0) NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unx_gateway`(`gateway`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 COMMENT = '短信配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of saisms_config
-- ----------------------------
INSERT INTO `saisms_config` VALUES (1, 'aliyun', '阿里云', '{\"access_key_id\":\"\",\"access_key_secret\":\"\"}', 1, 100, NULL, 1, 1, now(), now(), NULL);
INSERT INTO `saisms_config` VALUES (2, 'qcloud', '腾讯云', '{\"sdk_app_id\":\"\",\"secret_id\":\"\"}', 1, 100, NULL, 1, 1, now(), now(), NULL);
INSERT INTO `saisms_config` VALUES (3, 'qiniu', '七牛云', '{\"secret_key\":\"\",\"access_key\":\"\"}', 1, 200, NULL, 1, 1, now(), now(), NULL);
INSERT INTO `saisms_config` VALUES (4, 'link', '凌凯短信', '{\"CorpID\":\"\",\"Pwd\":\"\"}', 1, 99, NULL, 1, 1, now(), now(), NULL);
INSERT INTO `saisms_config` VALUES (5, 'baidu', '百度云', '{\"ak\":\"\",\"sk\":\"\",\"invoke_id\":\"\",\"domain\":\"\"}', 1, 100, NULL, 1, 1, now(), now(), NULL);
INSERT INTO `saisms_config` VALUES (6, 'smsbao', '短信宝', '{\"user\":\"\",\"password\":\"\",\"api_key\":\"\"}', 1, 98, NULL, 1, 1, now(), now(), NULL);

-- ----------------------------
-- Table structure for saisms_record
-- ----------------------------
CREATE TABLE IF NOT EXISTS `saisms_record`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '编号',
  `gateway` varchar(50) DEFAULT NULL COMMENT '网关',
  `mobile` varchar(20) DEFAULT NULL COMMENT '手机号码',
  `code` varchar(20) DEFAULT NULL COMMENT '验证码',
  `content` varchar(500) DEFAULT NULL COMMENT '短信内容',
  `status` varchar(20) DEFAULT NULL COMMENT '发送状态',
  `response` varchar(500) DEFAULT NULL COMMENT '返回结果',
  `is_verify` tinyint(1) NULL DEFAULT 2 COMMENT '是否验证',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 COMMENT = '短信记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for saisms_tag
-- ----------------------------
CREATE TABLE IF NOT EXISTS `saisms_tag`  (
   `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '编号',
   `tag_name` varchar(50) DEFAULT NULL COMMENT '标签名称',
   `gateway` varchar(50) DEFAULT NULL COMMENT '网关标识',
   `sms_type` tinyint(1) NULL DEFAULT 1 COMMENT '短信类型',
   `template_id` varchar(255) DEFAULT NULL COMMENT '模板编号',
   `content` varchar(255) DEFAULT NULL COMMENT '短信内容',
   `remark` varchar(255) DEFAULT NULL COMMENT '备注',
   `created_by` int(11) NULL DEFAULT NULL COMMENT '创建人',
   `updated_by` int(11) NULL DEFAULT NULL COMMENT '更新人',
   `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
   `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
   `delete_time` datetime(0) NULL DEFAULT NULL COMMENT '删除时间',
   PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 COMMENT = '短信标签' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table data for sa_system_menu
-- ----------------------------
INSERT INTO `sa_system_menu` VALUES(NULL, 0, 'SAISMS', 'Saisms', '', 1, '/saisms', '', NULL, 'ri:messenger-line', 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
SET @id := LAST_INSERT_ID();

INSERT INTO `sa_system_menu` VALUES(NULL, @id, '短信配置', 'saisms/config', '', 2, 'saisms/config', '/plugin/saisms/config/index', NULL, 'ri:list-unordered', 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
SET @parent_one := LAST_INSERT_ID();
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '列表', NULL, 'saisms:config:index', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '保存', NULL, 'saisms:config:save', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '更新', NULL, 'saisms:config:update', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '读取', NULL, 'saisms:config:read', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '删除', NULL, 'saisms:config:destroy', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '修改状态', NULL, 'saisms:config:changeStatus', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);


INSERT INTO `sa_system_menu` VALUES(NULL, @id, '短信标签', 'saisms/tag', '', 2, 'saisms/tag', '/plugin/saisms/tag/index', NULL, 'ri:list-unordered', 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
SET @parent_one := LAST_INSERT_ID();
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '列表', NULL, 'saisms:tag:index', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '保存', NULL, 'saisms:tag:save', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '更新', NULL, 'saisms:tag:update', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '读取', NULL, 'saisms:tag:read', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '删除', NULL, 'saisms:tag:destroy', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '发送测试', NULL, 'saisms:tag:testTag', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);

INSERT INTO `sa_system_menu` VALUES(NULL, @id, '短信记录', 'saisms/record', '', 2, 'saisms/record', '/plugin/saisms/record/index', NULL, 'ri:list-unordered', 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
SET @parent_one := LAST_INSERT_ID();
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '列表', NULL, 'saisms:record:index', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '读取', NULL, 'saisms:record:read', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
INSERT INTO `sa_system_menu` VALUES(NULL, @parent_one, '删除', NULL, 'saisms:record:destroy', 3, NULL, NULL, NULL, NULL, 100, '', 2, 2, 2, 2, 2, 0, 'plugin\saisms\app\api\controller\IndexController', 1, '', 1, 1, '2026-01-01 11:11:11', '2026-01-01 11:11:11', NULL);
