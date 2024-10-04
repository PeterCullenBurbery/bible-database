ALTER TABLE database_information MODIFY
    database_id RAW(16) NULL;

SELECT
    database_id
FROM
    bible_work
ORDER BY
    date_created DESC
FETCH FIRST 1 ROWS ONLY;

SELECT
    bible_translation_id
FROM
    bible_translation
WHERE
    REGEXP_LIKE ( bible_translation,
                  'web',
                  'i' );

UPDATE database_information
SET
    database_id = (
        SELECT
            database_id
        FROM
            database
        WHERE
            REGEXP_LIKE ( database,
                          'Oracle',
                          'i' )
    )
WHERE
    database_information.database_information_id = (
        SELECT
            database_information_id
        FROM
            database_information
        ORDER BY
            date_created DESC
        FETCH FIRST 1 ROWS ONLY
    );

ALTER TABLE database_information MODIFY
    database_id RAW(16) NOT NULL;

SELECT
    di.database_information,
    db.database
FROM
         database_information di
    JOIN database db ON di.database_id = db.database_id;

CREATE VIEW database_information_view AS
SELECT
    di.database_information,
    db.database
FROM
         database_information di
    JOIN database db ON di.database_id = db.database_id;

SELECT
    *
FROM
    database_information_view;