BEGIN
    -- 从资源设备表获取数据后存放数据的变量
    DECLARE v_tl_device_name VARCHAR(255);
    DECLARE v_tl_device_assemblename VARCHAR(255);
    DECLARE v_tl_device_telnet_ip VARCHAR(255);
    DECLARE v_tl_device_attribute VARCHAR(255);
    -- DECLARE v_tl_device_model VARCHAR(255);
    DECLARE v_tl_device_manufactory VARCHAR(255);
    DECLARE v_tl_device_cityname VARCHAR(255);
    DECLARE v_tl_small_country VARCHAR(255);
    DECLARE v_tl_marketing_area VARCHAR(255);
    DECLARE v_tl_circle_name VARCHAR(255);
    DECLARE v_tl_project_status VARCHAR(255);
    DECLARE v_tl_use_status VARCHAR(255);
    DECLARE v_tl_device_room VARCHAR(255);
    DECLARE v_tl_material_object_id VARCHAR(255);
    DECLARE v_tl_createdate DATETIME;
    DECLARE v_tl_modifydate DATETIME;
    DECLARE v_tl_device_metacategory VARCHAR(255);
    DECLARE v_tl_device_roles VARCHAR(255);
    DECLARE v_tl_network_layer VARCHAR(255);
    DECLARE v_tl_speciality VARCHAR(255);
    DECLARE v_tl_belong_specicality VARCHAR(255);

    -- 存放游标cur_wg_device所指向的结果集的变量，也作为子过程调用的入参
    DECLARE v_device_compare_id BIGINT(20);
    DECLARE v_wg_device_name VARCHAR(255);
    DECLARE v_wg_device_telnet_ip VARCHAR(255);

    -- 子过程出参
    DECLARE v_tl_device_meid VARCHAR(255);
    DECLARE v_device_compare_result VARCHAR(255);
    DECLARE v_device_illustration VARCHAR(255);

    -- 声明游标wg_device以及循环句柄
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_wg_device CURSOR FOR
    SELECT device_compare_id,wg_device_name,wg_device_telnet_ip
    FROM ipran_device_compare_result;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 创建比对结果表
    DROP TABLE IF EXISTS `ipran_device_compare_result`;
    CREATE TABLE `ipran_device_compare_result`(
        `device_compare_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '设备比对ID（递增）',
        `device_compare_result` VARCHAR(255) NULL DEFAULT NULL COMMENT '比对结果',
        `wg_device_name` VARCHAR(255) NULL DEFAULT NULL COMMENT '网管EMS名称',
        `tl_device_name` VARCHAR(255) NULL DEFAULT NULL COMMENT '资源EMS名称',
        `wg_device_assemblename` VARCHAR(255) NULL DEFAULT NULL COMMENT '网管拼装名称',
        `tl_device_assemblename` VARCHAR(255) NULL DEFAULT NULL COMMENT '资源拼装名称',
        `wg_device_telnet_ip` VARCHAR(255) NULL DEFAULT NULL COMMENT '网管设备Telnet_IP',
        `tl_device_telnet_ip` VARCHAR(255) NULL DEFAULT NULL COMMENT '资源设备Telnet_IP',
        `wg_device_attribute` VARCHAR(255) NULL DEFAULT NULL COMMENT '网管设备类型',
        `tl_device_attribute` VARCHAR(255) NULL DEFAULT NULL COMMENT '资源设备类型',
        -- `wg_device_model` VARCHAR(255) NULL DEFAULT NULL COMMENT '网管设备型号',
        -- `tl_device_model` VARCHAR(255) NULL DEFAULT NULL COMMENT '资源设备型号',
        `wg_device_manufactory` VARCHAR(255) NULL DEFAULT NULL COMMENT '网管设备厂商',
        `tl_device_manufactory` VARCHAR(255) NULL DEFAULT NULL COMMENT '资源设备厂商',
        `wg_device_cityname` VARCHAR(255) NULL DEFAULT NULL COMMENT '网管分公司',
        `tl_device_cityname` VARCHAR(255) NULL DEFAULT NULL COMMENT '资源分公司',
        `tl_small_country` VARCHAR(255) NULL DEFAULT NULL COMMENT '划小区县 eg:斗门分公司',
        `tl_marketing_area` VARCHAR(255) NULL DEFAULT NULL COMMENT '划小营服中心 eg:桥东营销服务中心',
        `wg_loop_name` VARCHAR(255) NULL DEFAULT NULL COMMENT '网管接入环名称',
        `tl_circle_name` VARCHAR(255) NULL DEFAULT NULL COMMENT '资源接入环名称',
        `tl_project_status` VARCHAR(255) NULL DEFAULT NULL COMMENT '资源验收状态',
        `tl_use_status` VARCHAR(255) NULL DEFAULT NULL COMMENT '设备使用状态',
        `tl_device_room` VARCHAR(255) NULL DEFAULT NULL COMMENT '设备所在机房',
        `device_compare_date` DATETIME NULL DEFAULT NULL COMMENT '对比时间',
        `tl_device_meid` VARCHAR(255) NULL DEFAULT NULL COMMENT '设备MEID',
        `tl_material_object_id` VARCHAR(255) NULL DEFAULT NULL COMMENT '实物ID',
        `wg_version` VARCHAR(255) NULL DEFAULT NULL COMMENT '网管软件版本',
        `tl_createdate` DATETIME NULL DEFAULT NULL COMMENT '记录录入时间',
        `tl_modifydate` DATETIME NULL DEFAULT NULL COMMENT '记录修改时间',
        `wg_device_metacategory` VARCHAR(255) DEFAULT NULL COMMENT '资源设备种类 eg:三层交换机',
        `tl_device_metacategory` VARCHAR(255) DEFAULT NULL COMMENT '资源设备种类 eg:路由器',
        `wg_device_roles` VARCHAR(255) DEFAULT NULL COMMENT '网管设备属性 eg:IPRAN设备',
        `tl_device_roles` VARCHAR(255) DEFAULT NULL COMMENT '资源设备属性',
        `wg_network_layer` VARCHAR(255) DEFAULT NULL COMMENT '网管网络层次 eg:接入层',
        `tl_network_layer` VARCHAR(255) DEFAULT NULL COMMENT '资源网络层次 eg:接入层',
        `wg_speciality` VARCHAR(255) DEFAULT NULL COMMENT '网管所属网络 eg:IPRAN网',
        `tl_speciality` VARCHAR(255) DEFAULT NULL COMMENT '资源所属网络 eg:IRPAN',
        `wg_subspeciality` VARCHAR(255) DEFAULT NULL COMMENT '网管专业子层次 eg:城域网及VPN业务',
        `tl_belong_speciality` VARCHAR(255) DEFAULT NULL COMMENT '资源所属专业 eg:数据',
        `device_illustration` VARCHAR(255) NULL DEFAULT NULL COMMENT '比对结果说明',
        PRIMARY KEY(`device_compare_id`),
        INDEX `ind_wg_device_name` (`wg_device_name`),
        INDEX `ind_tl_device_name` (`tl_device_name`),
        INDEX `ind_wg_device_telnet_ip` (`wg_device_telnet_ip`),
        INDEX `ind_tl_device_telnet_ip` (`tl_device_telnet_ip`),
        INDEX `ind_tl_device_meid` (`tl_device_meid`)
        )
    COLLATE='utf8_general_ci'
    ENGINE=MyISAM;

    -- 将网管数据导入结果表
    INSERT INTO ipran_device_compare_result(
        wg_device_name,
        wg_device_assemblename,
        wg_device_attribute,
        wg_device_manufactory,
        wg_device_telnet_ip,
        wg_device_roles,
        wg_device_metacategory,
        wg_network_layer,
        wg_speciality,
        wg_subspeciality,
        wg_loop_name,
        wg_version,
        wg_device_cityname,
        device_compare_date)
    SELECT 
    gtdi.NAME_EN,
    gtdi.NAME_CN,
    gtdi.MODEL_NAME,
    gtdi.FACTORY_NAME,
    gtdi.NM_LB_IP,
    gtdi.TYPE_NAME,
    gtdi.ROLE_NAME,
    gtdi.NET_LEVEL,
    gtdi.PRO_CATEGORY,
    gtdi.PRO_SUBCATEGORY,
    gtdi.LOOP_NAME,
    gtdi.SOFTWARE_VERSION,
    gtdi.CITY_NAME,
    SYSDATE()
    FROM gd4g.tisson_dev_info gtdi
    WHERE gtdi.CITY_NAME = '珠海';

    OPEN cur_wg_device;
    READ_LOOP:
    LOOP
        FETCH cur_wg_device INTO v_device_compare_id,v_wg_device_name,v_wg_device_telnet_ip;
        IF done THEN
            LEAVE READ_LOOP;
        END IF;

        -- 每次循环之前先清空每个变量
        SET v_tl_device_name = NULL;
        SET v_tl_device_assemblename = NULL;
        SET v_tl_device_telnet_ip = NULL;
        SET v_tl_device_attribute = NULL;
        -- SET v_tl_device_model = NULL;
        SET v_tl_device_manufactory = NULL;
        SET v_tl_device_cityname = NULL;
        SET v_tl_small_country = NULL;
        SET v_tl_marketing_area = NULL;
        SET v_tl_circle_name = NULL;
        SET v_tl_project_status = NULL;
        SET v_tl_use_status = NULL;
        SET v_tl_device_room = NULL;
        SET v_tl_device_meid = NULL;
        SET v_tl_material_object_id = NULL;
        SET v_tl_device_metacategory = NULL;
        SET v_tl_createdate = NULL;
        SET v_tl_modifydate = NULL;
        SET v_tl_device_roles = NULL;
        SET v_tl_network_layer = NULL;
        SET v_tl_speciality = NULL;
        SET v_tl_belong_specicality = NULL;

        CALL ipran_get_meid_by_hostname_ip(v_wg_device_name,v_wg_device_telnet_ip,v_tl_device_meid,v_device_compare_result,v_device_illustration);
        -- 根据device_meid去资源设备表获取数据,放入相应变量
        IF IFNULL(v_tl_device_meid,0) > 0 THEN
            SELECT
            tidi.tl_device_name,
            tidi.tl_device_assemblename,
            tidi.tl_device_telnet_ip,
            tidi.tl_device_attribute,
            -- tidi.tl_device_model,
            tidi.tl_device_manufactory,
            tidi.tl_device_cityname,
            tidi.tl_small_country,
            tidi.tl_marketing_area,
            tidi.tl_circle_name,
            tidi.tl_project_status,
            tidi.tl_use_status,
            tidi.tl_device_room,
            tidi.tl_material_object_id,
            tidi.tl_createdate,
            tidi.tl_modifydate,
            tidi.tl_device_metacategory,
            tidi.tl_device_roles,
            tidi.tl_network_layer,
            tidi.tl_speciality,
            tidi.tl_belong_speciality
            INTO
            v_tl_device_name,
            v_tl_device_assemblename,
            v_tl_device_telnet_ip,
            v_tl_device_attribute,
            -- v_tl_device_model,
            v_tl_device_manufactory,
            v_tl_device_cityname,
            v_tl_small_country,
            v_tl_marketing_area,
            v_tl_circle_name,
            v_tl_project_status,
            v_tl_use_status,
            v_tl_device_room,
            v_tl_material_object_id,
            v_tl_createdate,
            v_tl_modifydate,
            v_tl_device_metacategory,
            v_tl_device_roles,
            v_tl_network_layer,
            v_tl_speciality,
            v_tl_belong_specicality
            FROM tl_ipran_device_items tidi
            WHERE tidi.tl_meid = v_tl_device_meid;
        END IF;
        -- 将相应数据插入结果表
        UPDATE ipran_device_compare_result idcr
        SET
        idcr.tl_device_name = v_tl_device_name,
        idcr.tl_device_assemblename = v_tl_device_assemblename,
        idcr.tl_device_telnet_ip = v_tl_device_telnet_ip,
        idcr.tl_device_attribute = v_tl_device_attribute,
        -- idcr.tl_device_model = v_tl_device_model,
        idcr.tl_device_manufactory = v_tl_device_manufactory,
        idcr.tl_device_cityname = v_tl_device_cityname,
        idcr.tl_small_country = v_tl_small_country,
        idcr.tl_marketing_area = v_tl_marketing_area,
        idcr.tl_circle_name = v_tl_circle_name,
        idcr.tl_project_status = v_tl_project_status,
        idcr.tl_use_status = v_tl_use_status,
        idcr.tl_device_room = v_tl_device_room,
        idcr.tl_material_object_id = v_tl_material_object_id,
        idcr.tl_createdate = v_tl_createdate,
        idcr.tl_modifydate = v_tl_modifydate,
        idcr.tl_device_metacategory = v_tl_device_metacategory,
        idcr.tl_device_roles = v_tl_device_roles,
        idcr.tl_network_layer = v_tl_network_layer,
        idcr.tl_speciality = v_tl_speciality,
        idcr.tl_belong_speciality = v_tl_belong_specicality,
        idcr.tl_device_meid = v_tl_device_meid,
        idcr.device_compare_result = v_device_compare_result,
        idcr.device_illustration =  v_device_illustration
        WHERE idcr.device_compare_id = v_device_compare_id;

    END LOOP; 
    CLOSE cur_wg_device;

    -- 资源有网管无
    INSERT INTO ipran_device_compare_result(
        device_compare_result,
        tl_device_name,
        tl_device_assemblename,
        tl_device_telnet_ip,
        tl_device_attribute,
        -- tl_device_model,
        tl_device_manufactory,
        tl_device_cityname,
        tl_small_country,
        tl_marketing_area,
        tl_circle_name,
        tl_project_status,
        tl_use_status,
        tl_device_room,
        tl_material_object_id,
        tl_createdate,
        tl_modifydate,
        tl_device_metacategory,
        tl_device_roles,
        tl_network_layer,
        tl_speciality,
        tl_belong_speciality)
    SELECT
        '资源有网管无' AS device_compare_result,
        tidi.tl_device_name,
        tidi.tl_device_assemblename,
        tidi.tl_device_telnet_ip,
        tidi.tl_device_attribute,
        -- tidi.tl_device_model,
        tidi.tl_device_manufactory,
        tidi.tl_device_cityname,
        tidi.tl_small_country,
        tidi.tl_marketing_area,
        tidi.tl_circle_name,
        tidi.tl_project_status,
        tidi.tl_use_status,
        tidi.tl_device_room,
        tidi.tl_material_object_id,
        tidi.tl_createdate,
        tidi.tl_modifydate,
        tidi.tl_device_metacategory,
        tidi.tl_device_roles,
        tidi.tl_network_layer,
        tidi.tl_speciality,
        tidi.tl_belong_speciality
    FROM tl_ipran_device_items tidi
    WHERE NOT EXISTS (SELECT 1 FROM ipran_device_compare_result idcr WHERE idcr.tl_device_meid = tidi.tl_meid);

    UPDATE ipran_device_compare_result idcr
    SET idcr.tl_project_status = 
    CASE
    WHEN idcr.tl_project_status = '80204666' THEN '预录入'
    WHEN idcr.tl_project_status = '80204667' THEN '待验收'
    WHEN idcr.tl_project_status = '80204668' THEN '已验收'
    END
    WHERE idcr.tl_project_status IS NOT NULL;

    UPDATE ipran_device_compare_result idcr
    SET idcr.tl_use_status = 
    CASE
    WHEN idcr.tl_use_status = '80204847' THEN '已用'
    WHEN idcr.tl_use_status = '80204848' THEN '在建'
    WHEN idcr.tl_use_status = '100375' THEN '退网'
    WHEN idcr.tl_use_status = '100376' THEN '闲置'
    WHEN idcr.tl_use_status = '102383' THEN '报废'
    WHEN idcr.tl_use_status = '80204684' THEN '调拨'
    WHEN idcr.tl_use_status = '80206209' THEN '计划退网'
    END
    WHERE idcr.tl_use_status IS NOT NULL;

    UPDATE ipran_device_compare_result idcr
    SET idcr.tl_network_layer = 
    CASE
    WHEN idcr.tl_network_layer = '80206934' THEN 'MCE层'
    WHEN idcr.tl_network_layer = '80206932' THEN '城域核心层'
    WHEN idcr.tl_network_layer = '100655' THEN '汇聚层'
    WHEN idcr.tl_network_layer = '100656' THEN '接入层'
    WHEN idcr.tl_network_layer = '80206933' THEN '省核心层'
    END
    WHERE idcr.tl_network_layer IS NOT NULL;

    UPDATE ipran_device_compare_result idcr
    SET idcr.tl_belong_speciality = 
    CASE
    WHEN idcr.tl_belong_speciality = '80204670' THEN '数据'
    WHEN idcr.tl_belong_speciality = '80204675' THEN '光缆'
    WHEN idcr.tl_belong_speciality = '80204676' THEN '电缆'
    WHEN idcr.tl_belong_speciality = '80204674' THEN '公共'
    WHEN idcr.tl_belong_speciality = '80204669' THEN '传输'
    WHEN idcr.tl_belong_speciality = '80204677' THEN '支撑'
    WHEN idcr.tl_belong_speciality = '80204673' THEN '动力'
    WHEN idcr.tl_belong_speciality = '80204671' THEN '交换'
    WHEN idcr.tl_belong_speciality = '80204672' THEN '无线'
    END
    WHERE idcr.tl_belong_speciality IS NOT NULL;

    UPDATE ipran_device_compare_result idcr
    SET idcr.tl_speciality = 
    CASE
    WHEN idcr.tl_speciality = '102566' THEN 'IDC'
    WHEN idcr.tl_speciality = '102567' THEN 'IPTV'
    WHEN idcr.tl_speciality = '80204680' THEN '视频网络'
    WHEN idcr.tl_speciality = '102562' THEN 'CN2'
    WHEN idcr.tl_speciality = '80204678' THEN '宽带接入网'
    WHEN idcr.tl_speciality = '102561' THEN 'CHINANET'
    WHEN idcr.tl_speciality = '101397' THEN 'IPRAN'
    WHEN idcr.tl_speciality = '100741' THEN 'DCN'
    WHEN idcr.tl_speciality = '80204679' THEN '金融专网'
    WHEN idcr.tl_speciality = '102587' THEN '客户网络'
    WHEN idcr.tl_speciality = '102578' THEN '城域网'
    WHEN idcr.tl_speciality = '102585' THEN '基础数据网'
    WHEN idcr.tl_speciality = '101387' THEN 'CDMA'
    WHEN idcr.tl_speciality = '101413' THEN '软交换'
    WHEN idcr.tl_speciality = '102576' THEN 'WIFI'
    END
    WHERE idcr.tl_speciality IS NOT NULL;

    DELETE FROM ipran_device_compare_result
    WHERE tl_use_status IN ('退网','报废','闲置','计划退网','调拨')
    AND device_compare_result <> '设备名称+IP一致';

END