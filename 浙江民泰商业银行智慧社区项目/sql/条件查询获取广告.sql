
/**********************修改前的sql*****************************/
SELECT
	ID,
	TITLE,
	EFFECT_STRATEGY,
	EFFECT_APP,
	REDIRECT_TYPE,
	START_TIME,
	END_TIME,
	AGENCY_NUM,
	COMMUNITY_NUM,
	AREA_NUM,
	ENABLED,
	SEQ_NUM,
	USER_NAME,
	CREATE_TIME
FROM
	(
	SELECT
		ID,
		TITLE,
		EFFECT_STRATEGY,
		EFFECT_APP,
		REDIRECT_TYPE,
		START_TIME,
		END_TIME,
		AGENCY_NUM,
		COMMUNITY_NUM,
		AREA_NUM,
		ENABLED,
		SEQ_NUM,
		CREATE_USER,
		USER_NAME,
		CREATE_TIME,
		ROWNUM RN
	FROM
		(
		SELECT
			T_F. ID,
			T_F.TITLE,
			T_F.EFFECT_STRATEGY,
			T_F.EFFECT_APP,
			T_F.REDIRECT_TYPE,
			T_F.START_TIME,
			T_F.END_TIME,
			T_F.AGENCY_NUM,
			T_F.COMMUNITY_NUM,
			T_F.AREA_NUM,
			T_F.ENABLED,
			T_F.SEQ_NUM,
			T_F.CREATE_USER,
			T_U.USER_NAME,
			T_F.CREATE_TIME
		FROM
			(
			SELECT
				T_AI. ID,
				T_AI.TITLE,
				T_AI.EFFECT_STRATEGY,
				T_AI.EFFECT_APP,
				T_AI.REDIRECT_TYPE,
				T_AI.START_TIME,
				T_AI.END_TIME,
				T_AI.AGENCY_NUM,
				T_AI.COMMUNITY_NUM,
				T_AI.AREA_NUM,
				T_AI.ENABLED,
				T_AI.SEQ_NUM,
				T_AI.CREATE_USER,
				T_AI.CREATE_TIME
			FROM
				ADVERT_INFO T_AI
			WHERE
				T_AI.AREA_NUM = '全部城市'
				AND T_AI.AREA_NUM IS NOT NULL
		UNION
			SELECT
				T_AI. ID,
				T_AI.TITLE,
				T_AI.EFFECT_STRATEGY,
				T_AI.EFFECT_APP,
				T_AI.REDIRECT_TYPE,
				T_AI.START_TIME,
				T_AI.END_TIME,
				T_AI.AGENCY_NUM,
				T_AI.COMMUNITY_NUM,
				T_AI.AREA_NUM,
				T_AI.ENABLED,
				T_AI.SEQ_NUM,
				T_AI.CREATE_USER,
				T_AI.CREATE_TIME
			FROM
				(
				SELECT
					TT.SUBJECT_ID ADVERT_INFO_ID
				FROM
					(
					SELECT
						SUBJECT_ID,
						XMLAGG( XMLELEMENT (E,
						RESOURCE_ID || ',')). EXTRACT ('//text()').getclobval() RESOURCE_ID
					FROM
						(
						SELECT
							SUBJECT_ID,
							RESOURCE_ID COMMUNITY_ID,
							TAG,
							RESOURCE_ID
						FROM
							RELATION
						WHERE
							TAG = 'AREA_ID' )
					GROUP BY
						SUBJECT_ID ) TT
				WHERE
					INSTR ( TT.RESOURCE_ID,
					'340300' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'340200' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'340100' ) > 0 ) T_T
			LEFT JOIN ADVERT_INFO T_AI ON
				T_AI. ID = T_T.ADVERT_INFO_ID
			WHERE
				T_AI. ID IS NOT NULL
				AND T_AI.TITLE IS NOT NULL ) T_F
		LEFT JOIN USERS T_U ON
			T_F.CREATE_USER = T_U.USER_ID
		WHERE
			1 = 1
		ORDER BY
			T_F.CREATE_TIME DESC )
	WHERE
		ROWNUM <= 10 )
WHERE
	RN > 0


SELECT
	COUNT(*) CT
FROM
	(
	SELECT
		T_F. ID,
		T_F.TITLE,
		T_F.EFFECT_STRATEGY,
		T_F.EFFECT_APP,
		T_F.REDIRECT_TYPE,
		T_F.START_TIME,
		T_F.END_TIME,
		T_F.AGENCY_NUM,
		T_F.COMMUNITY_NUM,
		T_F.AREA_NUM,
		T_F.ENABLED,
		T_F.SEQ_NUM,
		T_F.CREATE_USER,
		T_U.USER_NAME,
		T_F.CREATE_TIME
	FROM
		(
		SELECT
			T_AI. ID,
			T_AI.TITLE,
			T_AI.EFFECT_STRATEGY,
			T_AI.EFFECT_APP,
			T_AI.REDIRECT_TYPE,
			T_AI.START_TIME,
			T_AI.END_TIME,
			T_AI.AGENCY_NUM,
			T_AI.COMMUNITY_NUM,
			T_AI.AREA_NUM,
			T_AI.ENABLED,
			T_AI.SEQ_NUM,
			T_AI.CREATE_USER,
			T_AI.CREATE_TIME
		FROM
			ADVERT_INFO T_AI
		WHERE
			T_AI.COMMUNITY_NUM = '全部小区'
			AND T_AI.AGENCY_NUM = '全部物业'
			AND T_AI.COMMUNITY_NUM IS NOT NULL
			AND T_AI.AGENCY_NUM IS NOT NULL
	UNION
		SELECT
			T_AI. ID,
			T_AI.TITLE,
			T_AI.EFFECT_STRATEGY,
			T_AI.EFFECT_APP,
			T_AI.REDIRECT_TYPE,
			T_AI.START_TIME,
			T_AI.END_TIME,
			T_AI.AGENCY_NUM,
			T_AI.COMMUNITY_NUM,
			T_AI.AREA_NUM,
			T_AI.ENABLED,
			T_AI.SEQ_NUM,
			T_AI.CREATE_USER,
			T_AI.CREATE_TIME
		FROM
			(
			SELECT
				TT.SUBJECT_ID ADVERT_INFO_ID
			FROM
				(
				SELECT
					SUBJECT_ID,
					XMLAGG( XMLELEMENT (E,
					RESOURCE_ID || ',')). EXTRACT ('//text()').getclobval() RESOURCE_ID
				FROM
					(
					SELECT
						SUBJECT_ID,
						RESOURCE_ID,
						TAG
					FROM
						RELATION
					WHERE
						TAG = 'COMMUNITY_ID'
				UNION ALL
					SELECT
						T1.SUBJECT_ID,
						T2.COMMUNITY_ID RESOURCE_ID,
						T1.TAG
					FROM
						RELATION T1
					LEFT JOIN COMMUNITY T2 ON
						T1.RESOURCE_ID = T2.AGENCY_ID
					WHERE
						T1.TAG = 'AGENCY_ID'
						AND T2.COMMUNITY_ID IS NOT NULL )
				GROUP BY
					SUBJECT_ID ) TT
			WHERE
				INSTR ( TT.RESOURCE_ID,
				'330100' ) > 0 T_T
			LEFT JOIN ADVERT_INFO T_AI ON
				T_AI. ID = T_T.ADVERT_INFO_ID
			WHERE
				T_AI. ID IS NOT NULL
				AND T_AI.TITLE IS NOT NULL ) T_F
		LEFT JOIN USERS T_U ON
			T_F.CREATE_USER = T_U.USER_ID
		WHERE
			1 = 1 ) 

/**************************修改后的sql********************************/

SELECT
	ID,
	TITLE,
	EFFECT_STRATEGY,
	EFFECT_APP,
	REDIRECT_TYPE,
	START_TIME,
	END_TIME,
	AGENCY_NUM,
	COMMUNITY_NUM,
	AREA_NUM,
	ENABLED,
	SEQ_NUM,
	USER_NAME,
	CREATE_TIME
FROM
	(
	SELECT
		ID,
		TITLE,
		EFFECT_STRATEGY,
		EFFECT_APP,
		REDIRECT_TYPE,
		START_TIME,
		END_TIME,
		AGENCY_NUM,
		COMMUNITY_NUM,
		AREA_NUM,
		ENABLED,
		SEQ_NUM,
		CREATE_USER,
		USER_NAME,
		CREATE_TIME,
		ROW_NUMBER() OVER() AS RN
	FROM
		(
		SELECT
			T_F. ID,
			T_F.TITLE,
			T_F.EFFECT_STRATEGY,
			T_F.EFFECT_APP,
			T_F.REDIRECT_TYPE,
			T_F.START_TIME,
			T_F.END_TIME,
			T_F.AGENCY_NUM,
			T_F.COMMUNITY_NUM,
			T_F.AREA_NUM,
			T_F.ENABLED,
			T_F.SEQ_NUM,
			T_F.CREATE_USER,
			T_U.USER_NAME,
			T_F.CREATE_TIME
		FROM
			(
			SELECT
				T_AI. ID,
				T_AI.TITLE,
				T_AI.EFFECT_STRATEGY,
				T_AI.EFFECT_APP,
				T_AI.REDIRECT_TYPE,
				T_AI.START_TIME,
				T_AI.END_TIME,
				T_AI.AGENCY_NUM,
				T_AI.COMMUNITY_NUM,
				T_AI.AREA_NUM,
				T_AI.ENABLED,
				T_AI.SEQ_NUM,
				T_AI.CREATE_USER,
				T_AI.CREATE_TIME
			FROM
				ADVERT_INFO T_AI
			WHERE
				T_AI.AREA_NUM = '全部城市'
				AND T_AI.AREA_NUM IS NOT NULL
		UNION
			SELECT
				T_AI. ID,
				T_AI.TITLE,
				T_AI.EFFECT_STRATEGY,
				T_AI.EFFECT_APP,
				T_AI.REDIRECT_TYPE,
				T_AI.START_TIME,
				T_AI.END_TIME,
				T_AI.AGENCY_NUM,
				T_AI.COMMUNITY_NUM,
				T_AI.AREA_NUM,
				T_AI.ENABLED,
				T_AI.SEQ_NUM,
				T_AI.CREATE_USER,
				T_AI.CREATE_TIME
			FROM
				(
				SELECT
					TT.SUBJECT_ID ADVERT_INFO_ID
				FROM
					(
					SELECT
						SUBJECT_ID,
						REPLACE ( REPLACE ( REPLACE ( xml2clob ( xmlagg ( xmlelement ( NAME A,
						RESOURCE_ID ) ) ),
						'</A><A>',
						',' ),
						'</A>',
						'' ),
						'<A>',
						'' ) RESOURCE_ID
					FROM
						(
						SELECT
							SUBJECT_ID,
							RESOURCE_ID COMMUNITY_ID,
							TAG,
							RESOURCE_ID
						FROM
							RELATION
						WHERE
							TAG = 'AREA_ID' )
					GROUP BY
						SUBJECT_ID ) TT
				WHERE
					INSTR ( TT.RESOURCE_ID,
					'330100' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'330200' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'330300' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'330400' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'330500' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'330600' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'330700' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'330800' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'330900' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'331000' ) > 0
					AND INSTR ( TT.RESOURCE_ID,
					'331100' ) > 0 ) T_T
			LEFT JOIN ADVERT_INFO T_AI ON
				T_AI. ID = T_T.ADVERT_INFO_ID
			WHERE
				T_AI. ID IS NOT NULL
				AND T_AI.TITLE IS NOT NULL ) T_F
		LEFT JOIN USERS T_U ON
			T_F.CREATE_USER = T_U.USER_ID
		WHERE
			1 = 1
		ORDER BY
			T_F.CREATE_TIME DESC ) )
WHERE
	RN BETWEEN 1 AND 10
	
	
SELECT
	COUNT(*) CT
FROM
	(
	SELECT
		T_F. ID,
		T_F.TITLE,
		T_F.EFFECT_STRATEGY,
		T_F.EFFECT_APP,
		T_F.REDIRECT_TYPE,
		T_F.START_TIME,
		T_F.END_TIME,
		T_F.AGENCY_NUM,
		T_F.COMMUNITY_NUM,
		T_F.AREA_NUM,
		T_F.ENABLED,
		T_F.SEQ_NUM,
		T_F.CREATE_USER,
		T_U.USER_NAME,
		T_F.CREATE_TIME
	FROM
		(
		SELECT
			T_AI. ID,
			T_AI.TITLE,
			T_AI.EFFECT_STRATEGY,
			T_AI.EFFECT_APP,
			T_AI.REDIRECT_TYPE,
			T_AI.START_TIME,
			T_AI.END_TIME,
			T_AI.AGENCY_NUM,
			T_AI.COMMUNITY_NUM,
			T_AI.AREA_NUM,
			T_AI.ENABLED,
			T_AI.SEQ_NUM,
			T_AI.CREATE_USER,
			T_AI.CREATE_TIME
		FROM
			ADVERT_INFO T_AI
		WHERE
			T_AI.AREA_NUM = '全部城市'
			AND T_AI.AREA_NUM IS NOT NULL
	UNION
		SELECT
			T_AI. ID,
			T_AI.TITLE,
			T_AI.EFFECT_STRATEGY,
			T_AI.EFFECT_APP,
			T_AI.REDIRECT_TYPE,
			T_AI.START_TIME,
			T_AI.END_TIME,
			T_AI.AGENCY_NUM,
			T_AI.COMMUNITY_NUM,
			T_AI.AREA_NUM,
			T_AI.ENABLED,
			T_AI.SEQ_NUM,
			T_AI.CREATE_USER,
			T_AI.CREATE_TIME
		FROM
			(
			SELECT
				TT.SUBJECT_ID ADVERT_INFO_ID
			FROM
				(
				SELECT
					SUBJECT_ID,
					REPLACE ( REPLACE ( REPLACE ( xml2clob ( xmlagg ( xmlelement ( NAME A,
					RESOURCE_ID ) ) ),
					'</A><A>',
					',' ),
					'</A>',
					'' ),
					'<A>',
					'' ) RESOURCE_ID
				FROM
					(
					SELECT
						SUBJECT_ID,
						RESOURCE_ID COMMUNITY_ID,
						TAG,
						RESOURCE_ID
					FROM
						RELATION
					WHERE
						TAG = 'AREA_ID' )
				GROUP BY
					SUBJECT_ID ) TT
			WHERE
				INSTR ( TT.RESOURCE_ID,
				'330100' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'330200' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'330300' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'330400' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'330500' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'330600' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'330700' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'330800' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'330900' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'331000' ) > 0
				AND INSTR ( TT.RESOURCE_ID,
				'331100' ) > 0 ) T_T
		LEFT JOIN ADVERT_INFO T_AI ON
			T_AI. ID = T_T.ADVERT_INFO_ID
		WHERE
			T_AI. ID IS NOT NULL
			AND T_AI.TITLE IS NOT NULL ) T_F
	LEFT JOIN USERS T_U ON
		T_F.CREATE_USER = T_U.USER_ID
	WHERE
		1 = 1 )