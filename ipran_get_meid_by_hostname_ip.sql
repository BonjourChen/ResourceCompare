BEGIN
	DECLARE v_count1 INT;
	DECLARE v_count2 INT;
	DECLARE v_count3 INT;
	DECLARE v_count INT;
	LABEL:
	BEGIN
		SELECT COUNT(1) INTO v_count1 FROM tl_ipran_device_items tidi
		WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
		AND tidi.tl_device_name = p_wg_device_name;

		SELECT COUNT(1) INTO v_count2 FROM tl_ipran_device_items tidi
		WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
		AND IFNULL(tidi.tl_device_name,-99)<>IFNULL(p_wg_device_name,-98);

		SELECT COUNT(1) INTO v_count3 FROM tl_ipran_device_items tidi
		WHERE tidi.tl_device_name = p_wg_device_name
		AND IFNULL(tidi.tl_device_telnet_ip,-99)<>IFNULL(p_wg_device_ip,-98);

		IF v_count1 = 1 THEN
			SET p_device_compare_result = '设备名称+IP一致';
			SELECT tidi.tl_meid INTO p_tl_device_meid
			FROM tl_ipran_device_items tidi
			WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
			AND tidi.tl_device_name = p_wg_device_name;
			LEAVE LABEL;
		ELSEIF v_count1 > 1 THEN
			SELECT COUNT(1) INTO v_count FROM tl_ipran_device_items tidi
			WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
			AND tidi.tl_device_name = p_wg_device_name
			AND tidi.tl_project_status = '80204668';
			IF v_count = 1 THEN
				SET p_device_compare_result = '设备名称+IP一致';
				SELECT tidi.tl_meid INTO p_tl_device_meid
				FROM tl_ipran_device_items tidi
				WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
				AND tidi.tl_device_name = p_wg_device_name
				AND tidi.tl_project_status = '80204668';
				LEAVE LABEL;
			ELSEIF v_count > 1 THEN
				SET p_device_compare_result = '资源匹配出多条记录';
				SET p_device_compare_illustration = '通过HOSTNAME+IP查到多台已验收设备';
				LEAVE LABEL;
			ELSEIF v_count = 0 THEN
				SELECT COUNT(1) INTO v_count FROM tl_ipran_device_items tidi
				WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
				AND tidi.tl_device_name = p_wg_device_name
				AND tidi.tl_project_status = '80204667';
				IF v_count = 1 THEN
					SET p_device_compare_result = '设备名称+IP一致';
					SELECT tidi.tl_meid INTO p_tl_device_meid
					FROM tl_ipran_device_items tidi
					WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
					AND tidi.tl_device_name = p_wg_device_name
					AND tidi.tl_project_status = '80204667';
					LEAVE LABEL;
				ELSEIF v_count > 1 THEN
					SET p_device_compare_result = '资源匹配出多条记录';
					SET p_device_compare_illustration = '通过HOSTNAME+IP查到多台待验收设备';
					LEAVE LABEL;
				ELSEIF v_count = 0 THEN
					SELECT COUNT(1) INTO v_count FROM tl_ipran_device_items tidi
					WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
					AND tidi.tl_device_name = p_wg_device_name
					AND tidi.tl_project_status = '80204666';
					IF v_count = 1 THEN
						SET p_device_compare_result = '设备名称+IP一致';
						SELECT tidi.tl_meid INTO p_tl_device_meid
						FROM tl_ipran_device_items tidi
						WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
						AND tidi.tl_device_name = p_wg_device_name
						AND tidi.tl_project_status = '80204666';
						LEAVE LABEL;
					ELSEIF v_count > 1 THEN
						SET p_device_compare_result = '资源匹配出多条记录';
						SET p_device_compare_illustration = '通过HOSTNAME+IP查到多台预录入设备';
						LEAVE LABEL;
					ELSE
						SET p_device_compare_result = '无法确认设备验收状态';
						LEAVE LABEL;
					END IF;
				END IF;
			END IF;
		ELSE
			IF v_count2 = 1 THEN
				SET p_device_compare_result = 'IP一致设备名称不一致';
				SELECT tidi.tl_meid INTO p_tl_device_meid
				FROM tl_ipran_device_items tidi
				WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
				AND IFNULL(tidi.tl_device_name,-99)<>IFNULL(p_wg_device_name,-98);
				LEAVE LABEL;
			ELSEIF v_count2 > 1 THEN
				SELECT COUNT(1) INTO v_count FROM tl_ipran_device_items tidi
				WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
				AND IFNULL(tidi.tl_device_name,-99)<>IFNULL(p_wg_device_name,-98)
				AND tidi.tl_project_status = '80204668';
				IF v_count = 1 THEN
					SET p_device_compare_result = 'IP一致设备名称不一致';
					SELECT tidi.tl_meid INTO p_tl_device_meid
					FROM tl_ipran_device_items tidi
					WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
					AND IFNULL(tidi.tl_device_name,-99)<>IFNULL(p_wg_device_name,-98)
					AND tidi.tl_project_status = '80204668';
					LEAVE LABEL;
				ELSEIF v_count > 1 THEN
					SET p_device_compare_result = '资源匹配出多条记录';
                    SET p_device_compare_illustration = '通过IP查到多台已验收设备';
                    LEAVE LABEL;
                ELSEIF v_count = 0 THEN
                	SELECT COUNT(1) INTO v_count FROM tl_ipran_device_items tidi
					WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
					AND IFNULL(tidi.tl_device_name,-99)<>IFNULL(p_wg_device_name,-98)
					AND tidi.tl_project_status = '80204667';
					IF v_count = 1 THEN
						SET p_device_compare_result = 'IP一致设备名称不一致';
						SELECT tidi.tl_meid INTO p_tl_device_meid
						FROM tl_ipran_device_items tidi
						WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
						AND IFNULL(tidi.tl_device_name,-99)<>IFNULL(p_wg_device_name,-98)
						AND tidi.tl_project_status = '80204667';
						LEAVE LABEL;
					ELSEIF v_count > 1 THEN
						SET p_device_compare_result = '资源匹配出多条记录';
                        SET p_device_compare_illustration = '通过IP查到多台待验收设备';
                        LEAVE LABEL;
                    ELSEIF v_count = 0 THEN
                    	SELECT COUNT(1) INTO v_count FROM tl_ipran_device_items tidi
						WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
						AND IFNULL(tidi.tl_device_name,-99)<>IFNULL(p_wg_device_name,-98)
						AND tidi.tl_project_status = '80204666';
						IF v_count = 1 THEN
							SET p_device_compare_result = 'IP一致设备名称不一致';
							SELECT tidi.tl_meid INTO p_tl_device_meid
							FROM tl_ipran_device_items tidi
							WHERE tidi.tl_device_telnet_ip = p_wg_device_ip
							AND IFNULL(tidi.tl_device_name,-99)<>IFNULL(p_wg_device_name,-98)
							AND tidi.tl_project_status = '80204666';
							LEAVE LABEL;
						ELSEIF v_count > 1 THEN
							SET p_device_compare_result = '资源匹配出多条记录';
	                        SET p_device_compare_illustration = '通过IP查到多台预录入设备';
	                        LEAVE LABEL;
	                    ELSE
	                    	SET p_device_compare_result = '无法确认设备验收状态';
							LEAVE LABEL;
						END IF;
					END IF;
				END IF;
			ELSE
				IF v_count3 = 1 THEN
					SET p_device_compare_result = 'IP不一致设备名称一致';
					SELECT tidi.tl_meid INTO p_tl_device_meid
					FROM tl_ipran_device_items tidi
					WHERE tidi.tl_device_name = p_wg_device_name
					AND IFNULL(tidi.tl_device_telnet_ip,-99)<>IFNULL(p_wg_device_ip,-98);
					LEAVE LABEL;
				ELSEIF v_count3 > 1 THEN
					SELECT COUNT(1) INTO v_count FROM tl_ipran_device_items tidi
					WHERE tidi.tl_device_name = p_wg_device_name
					AND IFNULL(tidi.tl_device_telnet_ip,-99)<>IFNULL(p_wg_device_ip,-98)
					AND tidi.tl_project_status = '80204668';
					IF v_count = 1 THEN
						SET p_device_compare_result = 'IP不一致设备名称一致';
						SELECT tidi.tl_meid INTO p_tl_device_meid
						FROM tl_ipran_device_items tidi
						WHERE tidi.tl_device_name = p_wg_device_name
						AND IFNULL(tidi.tl_device_telnet_ip,-99)<>IFNULL(p_wg_device_ip,-98)
						AND tidi.tl_project_status = '80204668';
						LEAVE LABEL;
					ELSEIF v_count > 1 THEN
						SET p_device_compare_result = '资源匹配出多条记录';
                        SET p_device_compare_illustration = '通过HOSTNAME查到多台已验收设备';
                     	LEAVE LABEL;
                    ELSEIF v_count = 0 THEN
                    	SELECT COUNT(1) INTO v_count FROM tl_ipran_device_items tidi
						WHERE tidi.tl_device_name = p_wg_device_name
						AND IFNULL(tidi.tl_device_telnet_ip,-99)<>IFNULL(p_wg_device_ip,-98)
						AND tidi.tl_project_status = '80204667';
						IF v_count = 1 THEN
							SET p_device_compare_result = 'IP不一致设备名称一致';
							SELECT tidi.tl_meid INTO p_tl_device_meid
							FROM tl_ipran_device_items tidi
							WHERE tidi.tl_device_name = p_wg_device_name
							AND IFNULL(tidi.tl_device_telnet_ip,-99)<>IFNULL(p_wg_device_ip,-98)
							AND tidi.tl_project_status = '80204667';
							LEAVE LABEL;
						ELSEIF v_count > 1 THEN
							SET p_device_compare_result = '资源匹配出多条记录';
	                        SET p_device_compare_illustration = '通过HOSTNAME查到多台待验收设备';
	                     	LEAVE LABEL;
	                    ELSEIF v_count = 0 THEN
	                    	SELECT COUNT(1) INTO v_count FROM tl_ipran_device_items tidi
							WHERE tidi.tl_device_name = p_wg_device_name
							AND IFNULL(tidi.tl_device_telnet_ip,-99)<>IFNULL(p_wg_device_ip,-98)
							AND tidi.tl_project_status = '80204666';
							IF v_count = 1 THEN
								SET p_device_compare_result = 'IP不一致设备名称一致';
								SELECT tidi.tl_meid INTO p_tl_device_meid
								FROM tl_ipran_device_items tidi
								WHERE tidi.tl_device_name = p_wg_device_name
								AND IFNULL(tidi.tl_device_telnet_ip,-99)<>IFNULL(p_wg_device_ip,-98)
								AND tidi.tl_project_status = '80204666';
								LEAVE LABEL;
							ELSEIF v_count > 1 THEN
								SET p_device_compare_result = '资源匹配出多条记录';
		                        SET p_device_compare_illustration = '通过HOSTNAME查到多台预录入设备';
		                     	LEAVE LABEL;
		                    ELSEIF v_count = 0 THEN
		                    	SET p_device_compare_result = '无法确认设备验收状态';
								LEAVE LABEL;
		                    END IF;
						END IF;
					END IF;
				ELSEIF v_count3 = 0 THEN
					SET p_device_compare_result = '网管有资源无';
                    SET p_device_compare_illustration = '通过HOSTNAME+IP或HOSTNAME或IP都查不到设备';
                    LEAVE LABEL;
				END IF;
			END IF;
		END IF;
	END;
END