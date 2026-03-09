-- ----------------------------
-- Table structure for saisms_config
-- ----------------------------
DROP TABLE IF EXISTS `saisms_config`;

-- ----------------------------
-- Table structure for saisms_record
-- ----------------------------
DROP TABLE IF EXISTS `saisms_record`;

-- ----------------------------
-- Table structure for saisms_tag
-- ----------------------------
DROP TABLE IF EXISTS `saisms_tag`;

-- ----------------------------
-- Records of eb_system_menu
-- ----------------------------
UPDATE `sa_system_menu` set `delete_time` = now() WHERE `generate_key` = 'plugin\saisms\app\api\controller\IndexController' and `create_time` = '2026-01-01 11:11:11' and ISNULL(`delete_time`);
