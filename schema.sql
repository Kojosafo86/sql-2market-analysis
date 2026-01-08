-- Customer marketing data
CREATE TABLE marketing_data (
    id INT PRIMARY KEY,
    year_birth INT,
    education VARCHAR(50),
    marital_status VARCHAR(50),
    income NUMERIC,
    kidhome INT,
    teenhome INT,
    dt_customer DATE,
    recency INT,
    amtliq INT,
    amtvege INT,
    amtnonveg INT,
    amtpesc INT,
    amtchocolates INT,
    amtcomm INT,
    numdeals INT,
    numwebbuy INT,
    numwalkinpur INT,
    numvisits INT,
    response INT,
    complain INT,
    country VARCHAR(10),
    count_success INT
);

-- Advertising channel data
CREATE TABLE ad_data (
    id INT PRIMARY KEY,
    bulkmail_ad INT,
    twitter_ad INT,
    instagram_ad INT,
    facebook_ad INT,
    brochure_ad INT
);
