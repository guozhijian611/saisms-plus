-- ----------------------------
-- UPDATE
-- ----------------------------
INSERT INTO `saisms_config`
(`gateway`, `config_name`, `config`, `status`, `sort`, `remark`, `created_by`, `updated_by`, `create_time`, `update_time`, `delete_time`)
VALUES
('smsbao', '短信宝', '{\"user\":\"\",\"password\":\"\",\"api_key\":\"\"}', 1, 98, '短信宝网关', 1, 1, now(), now(), NULL)
ON DUPLICATE KEY UPDATE
`config_name` = VALUES(`config_name`),
`config` = VALUES(`config`),
`sort` = VALUES(`sort`),
`remark` = VALUES(`remark`),
`status` = VALUES(`status`),
`delete_time` = NULL,
`update_time` = now();
