CREATE DATABASE bible;
USE bible;

CREATE TABLE bible_translation (
    bible_translation_id BINARY(16) PRIMARY KEY,  -- RAW(16) is mapped to BINARY(16) in MySQL
    bible_translation VARCHAR(4000) NOT NULL,
    CONSTRAINT uq_bible_translation UNIQUE (bible_translation(255)),

    -- Additional columns for note and dates
    note VARCHAR(4000),  -- General-purpose note field
    date_created TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,  -- TIMESTAMP(9) doesn't exist, use TIMESTAMP(6) for microseconds
    date_updated TIMESTAMP(6) NULL ON UPDATE CURRENT_TIMESTAMP(6),  -- MySQL updates automatically when a row is modified
    date_created_or_updated TIMESTAMP(6) AS (COALESCE(date_updated, date_created))  -- Virtual column in MySQL
);

CREATE TABLE bible_work (
    bible_work_id BINARY(16) PRIMARY KEY,  -- RAW(16) is mapped to BINARY(16)
    random_bible_verse VARCHAR(4000) NOT NULL,
    bible VARCHAR(4000) NOT NULL,
    bible_translation_id BINARY(16) NOT NULL,
    date_read TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),  -- Same as above, use TIMESTAMP(6)
    CONSTRAINT uq_bible UNIQUE (bible(255)),

    -- Additional columns for note and dates
    note VARCHAR(4000),  -- General-purpose note field
    date_created TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,
    date_updated TIMESTAMP(6) NULL ON UPDATE CURRENT_TIMESTAMP(6),
    date_created_or_updated TIMESTAMP(6) AS (COALESCE(date_updated, date_created)),  -- Virtual column in MySQL

    -- Foreign key constraint
    CONSTRAINT fk_bible_work_references_bible_translation FOREIGN KEY (bible_translation_id)
        REFERENCES bible_translation (bible_translation_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Trigger to update the date_updated column on update
DELIMITER $$

CREATE TRIGGER trg_set_date_updated_bible_work
BEFORE UPDATE ON bible_work
FOR EACH ROW
BEGIN
    SET NEW.date_updated = CURRENT_TIMESTAMP(6);
END$$

DELIMITER ;

-- Trigger to update the date_updated column on update
DELIMITER $$

CREATE TRIGGER trg_set_date_updated_bible_translation
BEFORE UPDATE ON bible_translation
FOR EACH ROW
BEGIN
    SET NEW.date_updated = CURRENT_TIMESTAMP(6);
END$$

DELIMITER ;
