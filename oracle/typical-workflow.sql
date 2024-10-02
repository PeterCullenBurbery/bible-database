ALTER TABLE bible_work MODIFY
    bible_translation_id RAW(16) NULL;

SELECT
    bible_work_id
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

UPDATE bible_work
SET
    bible_translation_id = (
        SELECT
            bible_translation_id
        FROM
            bible_translation
        WHERE
            REGEXP_LIKE ( bible_translation,
                          'web',
                          'i' )
    )
WHERE
    bible_work_id = (
        SELECT
            bible_work_id
        FROM
            bible_work
        ORDER BY
            date_created DESC
        FETCH FIRST 1 ROWS ONLY
    );

ALTER TABLE bible_work MODIFY
    bible_translation_id RAW(16) NOT NULL;

SELECT
    bw.random_bible_verse,
    bw.bible,
    bt.bible_translation,
    bw.date_read
FROM
         bible_work bw
    JOIN bible_translation bt ON bw.bible_translation_id = bt.bible_translation_id;

CREATE VIEW bible_reading AS
    SELECT
        bw.random_bible_verse,
        bw.bible,
        bt.bible_translation,
        bw.date_read
    FROM
             bible_work bw
        JOIN bible_translation bt ON bw.bible_translation_id = bt.bible_translation_id;

SELECT
    *
FROM
    bible_reading;