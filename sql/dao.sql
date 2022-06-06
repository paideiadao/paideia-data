-- dao
CREATE TABLE daos (
    id SERIAL PRIMARY KEY,
    dao_name TEXT NOT NULL,
    dao_short_description TEXT,
    dao_url TEXT NOT NULL,
    governance_id INT,
    tokenomics_id INT,
    design_id INT,
    is_draft BOOLEAN,
    is_published BOOLEAN,
    nav_stage INT,
    is_review BOOLEAN
);

-- design
CREATE TABLE dao_designs (
    id SERIAL PRIMARY KEY,
    dao_id INT NOT NULL,
    theme_id INT NOT NULL,
    logo_url TEXT,
    show_banner BOOLEAN,
    banner_url TEXT,
    show_footer BOOLEAN,
    footer_text TEXT
);

CREATE TABLE dao_themes (id SERIAL PRIMARY KEY);

CREATE TABLE footer_social_links (
    id SERIAL PRIMARY KEY,
    design_id INT NOT NULL,
    social_network TEXT,
    link_url TEXT
);

-- governance
CREATE TABLE governances (
    id SERIAL PRIMARY KEY,
    dao_id INT NOT NULL,
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
    governance_id INT NOT NULL,
    user_id INT NOT NULL
);

-- tokenomics and distributions
CREATE TABLE tokenomics (
    id SERIAL PRIMARY KEY,
    dao_id INT NOT NULL,
    type TEXT NOT NULL,
    token_name TEXT,
    token_ticker TEXT,
    token_amount DECIMAL,
    token_image_url TEXT,
    token_remaining DECIMAL,
    is_activated BOOLEAN
);

CREATE TABLE token_holders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    percentage DECIMAL,
    balance DECIMAL
);

CREATE TABLE tokenomics_token_holders (
    id SERIAL PRIMARY KEY,
    token_holder_id INT NOT NULL,
    tokenomics_id INT NOT NULL
);

CREATE TABLE distributions (
    id SERIAL PRIMARY KEY,
    tokenomics_id INT NOT NULL,
    distribution_type TEXT NOT NULL,
    balance DECIMAL,
    percentage DECIMAL
);

CREATE TABLE distribution_token_holders (
    id SERIAL PRIMARY KEY,
    token_holder_id INT NOT NULL,
    distribution_id INT NOT NULL
);

CREATE TABLE airdrop_validated_fields (
    id SERIAL PRIMARY KEY,
    distribution_id INT NOT NULL,
    value TEXT,
    number INT
);

CREATE TABLE distribution_config (
    id SERIAL PRIMARY KEY,
    distribution_id INT NOT NULL,
    property_name TEXT,
    property_value TEXT,
    property_data_type TEXT DEFAULT 'str'
);
