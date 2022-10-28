-- dao
CREATE TABLE daos (
    id SERIAL PRIMARY KEY,
    dao_name TEXT NOT NULL,
    dao_short_description TEXT,
    dao_url TEXT UNIQUE NOT NULL,
    governance_id INT, -- constraint maintained from governance table
    tokenomics_id INT, -- constraint maintained from tokenomics table
    design_id INT, -- constraint maintained from design table
    is_draft BOOLEAN,
    is_published BOOLEAN,
    nav_stage INT,
    is_review BOOLEAN
);

-- design
CREATE TABLE dao_themes (id SERIAL PRIMARY KEY);

CREATE TABLE dao_designs (
    id SERIAL PRIMARY KEY,
    dao_id INT REFERENCES daos(id) ON DELETE CASCADE,
    theme_id INT REFERENCES dao_themes(id),
    logo_url TEXT,
    show_banner BOOLEAN,
    banner_url TEXT,
    show_footer BOOLEAN,
    footer_text TEXT
);

CREATE TABLE footer_social_links (
    id SERIAL PRIMARY KEY,
    design_id INT REFERENCES dao_designs(id) ON DELETE CASCADE,
    social_network TEXT,
    link_url TEXT
);

-- governance
CREATE TABLE governances (
    id SERIAL PRIMARY KEY,
    dao_id INT REFERENCES daos(id) ON DELETE CASCADE,
    is_optimistic BOOLEAN,
    is_quadratic_voting BOOLEAN,
    time_to_challenge__sec INT,
    quorum INT,
    vote_duration__sec INT,
    amount DECIMAL,
    currency TEXT,
    support_needed INT
);

CREATE TABLE governance_whitelist (
    id SERIAL PRIMARY KEY,
    governance_id INT REFERENCES governances(id) ON DELETE CASCADE,
    ergo_address_id INT REFERENCES ergo_addresses(id)
);

-- tokenomics and distributions
CREATE TABLE tokenomics (
    id SERIAL PRIMARY KEY,
    dao_id INT REFERENCES daos(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    token_id TEXT,
    token_name TEXT,
    token_ticker TEXT,
    token_amount DECIMAL,
    token_image_url TEXT,
    token_remaining DECIMAL,
    is_activated BOOLEAN
);

CREATE TABLE token_holders (
    id SERIAL PRIMARY KEY,
    ergo_address_id INT REFERENCES ergo_addresses(id),
    percentage DECIMAL,
    balance DECIMAL
);

CREATE TABLE tokenomics_token_holders (
    id SERIAL PRIMARY KEY,
    token_holder_id INT REFERENCES token_holders(id) ON DELETE CASCADE,
    tokenomics_id INT REFERENCES tokenomics(id) ON DELETE CASCADE
);

CREATE TABLE distributions (
    id SERIAL PRIMARY KEY,
    tokenomics_id INT REFERENCES tokenomics(id) ON DELETE CASCADE,
    distribution_type TEXT NOT NULL,
    balance DECIMAL,
    percentage DECIMAL
);

CREATE TABLE distribution_token_holders (
    id SERIAL PRIMARY KEY,
    token_holder_id INT REFERENCES token_holders(id) ON DELETE CASCADE,
    distribution_id INT REFERENCES distributions(id) ON DELETE CASCADE
);

CREATE TABLE airdrop_validated_fields (
    id SERIAL PRIMARY KEY,
    distribution_id INT REFERENCES distributions(id) ON DELETE CASCADE,
    value TEXT,
    number INT
);

CREATE TABLE distribution_config (
    id SERIAL PRIMARY KEY,
    distribution_id INT REFERENCES distributions(id) ON DELETE CASCADE,
    property_name TEXT,
    property_value TEXT,
    property_data_type TEXT DEFAULT 'str'
);

-- execute after daos table is created
ALTER TABLE user_details
ADD CONSTRAINT user_details_dao_id_fkey
FOREIGN KEY (dao_id) REFERENCES daos(id) ON DELETE CASCADE;


CREATE VIEW vw_daos AS (
    SELECT
        D.id,
        D.dao_name,
        D.dao_url,
        T.token_id,
        DD.logo_url,
        T.token_ticker,
        COUNT(DISTINCT UD.id) AS member_count,
        COUNT(DISTINCT P.id) AS proposal_count
        
    FROM daos D
    INNER JOIN tokenomics T ON T.dao_id = D.id
    INNER JOIN dao_designs DD ON DD.dao_id = D.id
    LEFT JOIN user_details UD ON UD.dao_id = D.id
    LEFT JOIN proposals P ON P.dao_id = D.id
    GROUP BY D.id, D.dao_name, D.dao_url, T.token_id, DD.logo_url
)