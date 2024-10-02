

CREATE TABLE bible_translation (
    bible_translation_id RAW(16) DEFAULT sys_guid() PRIMARY KEY,
    bible_translation varchar2(1000) not null,
    CONSTRAINT uq_bible_translation UNIQUE ( bible_translation ),

    -- Additional columns for note and dates
    note                       VARCHAR2(4000),  -- General-purpose note field
    date_created               TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9) NOT NULL,
    date_updated               TIMESTAMP(9) WITH TIME ZONE,
        date_created_or_updated    TIMESTAMP(9) WITH TIME ZONE GENERATED ALWAYS AS ( coalesce(date_updated, date_created) ) VIRTUAL
);

-- Trigger to update date_updated for operating_system
CREATE OR REPLACE TRIGGER trg_set_date_updated_bible_translation
BEFORE UPDATE ON bible_translation
FOR EACH ROW
BEGIN
    :NEW.date_updated := systimestamp;
END;
/

-- 1. Create the bible table
CREATE TABLE bible_work (
    bible_work_id RAW(16) DEFAULT sys_guid() PRIMARY KEY,
    random_bible_verse varchar2(4000) not null,
    bible    VARCHAR2(1000) NOT NULL,
    bible_translation_id raw(16) not null,
    date_read               TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9),
    CONSTRAINT uq_bible UNIQUE ( bible ),

    -- Additional columns for note and dates
    note                       VARCHAR2(4000),  -- General-purpose note field
    date_created               TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9) NOT NULL,
    date_updated               TIMESTAMP(9) WITH TIME ZONE,
        date_created_or_updated    TIMESTAMP(9) WITH TIME ZONE GENERATED ALWAYS AS ( coalesce(date_updated, date_created) ) VIRTUAL,
        CONSTRAINT fk_bible_work_references_bible_translation FOREIGN KEY ( bible_translation_id )
        REFERENCES bible_translation ( bible_translation_id )
);


-- Trigger to update date_updated for operating_system
CREATE OR REPLACE TRIGGER trg_set_date_updated_bible_work 
BEFORE UPDATE ON bible_work
FOR EACH ROW
BEGIN
    :NEW.date_updated := systimestamp;
END;
/