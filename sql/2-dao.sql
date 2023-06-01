-- dao
CREATE TABLE daos (
    id UUID PRIMARY KEY,
    dao_key TEXT,
    config_height INT,
    dao_name TEXT NOT NULL,
    dao_short_description TEXT,
    dao_url TEXT UNIQUE NOT NULL,
    is_draft BOOLEAN,
    is_published BOOLEAN,
    nav_stage INT,
    is_review BOOLEAN
);

-- design
CREATE TABLE dao_themes (
    id UUID PRIMARY KEY,
    theme_name TEXT NOT NULL,
    primary_color TEXT NOT NULL,
    secondary_color TEXT NOT NULL,
    dark_primary_color TEXT NOT NULL,
    dark_secondary_color TEXT NOT NULL
);

CREATE TABLE dao_designs (
    id UUID PRIMARY KEY,
    dao_id UUID REFERENCES daos(id) ON DELETE CASCADE,
    theme_id UUID REFERENCES dao_themes(id),
    logo_url TEXT,
    show_banner BOOLEAN,
    banner_url TEXT,
    show_footer BOOLEAN,
    footer_text TEXT
);

CREATE TABLE footer_social_links (
    id UUID PRIMARY KEY,
    design_id UUID REFERENCES dao_designs(id) ON DELETE CASCADE,
    social_network TEXT,
    link_url TEXT
);

-- governance
CREATE TABLE governances (
    id UUID PRIMARY KEY,
    dao_id UUID REFERENCES daos(id) ON DELETE CASCADE,
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
    id UUID PRIMARY KEY,
    governance_id UUID REFERENCES governances(id) ON DELETE CASCADE,
    ergo_address_id UUID REFERENCES ergo_addresses(id)
);

-- tokenomics and distributions
CREATE TABLE tokenomics (
    id UUID PRIMARY KEY,
    dao_id UUID REFERENCES daos(id) ON DELETE CASCADE,
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
    id UUID PRIMARY KEY,
    ergo_address_id UUID REFERENCES ergo_addresses(id),
    percentage DECIMAL,
    balance DECIMAL
);

CREATE TABLE tokenomics_token_holders (
    id UUID PRIMARY KEY,
    token_holder_id UUID REFERENCES token_holders(id) ON DELETE CASCADE,
    tokenomics_id UUID REFERENCES tokenomics(id) ON DELETE CASCADE
);

CREATE TABLE distributions (
    id UUID PRIMARY KEY,
    tokenomics_id UUID REFERENCES tokenomics(id) ON DELETE CASCADE,
    distribution_type TEXT NOT NULL,
    balance DECIMAL,
    percentage DECIMAL
);

CREATE TABLE distribution_token_holders (
    id UUID PRIMARY KEY,
    token_holder_id UUID REFERENCES token_holders(id) ON DELETE CASCADE,
    distribution_id UUID REFERENCES distributions(id) ON DELETE CASCADE
);

CREATE TABLE airdrop_validated_fields (
    id UUID PRIMARY KEY,
    distribution_id UUID REFERENCES distributions(id) ON DELETE CASCADE,
    value TEXT,
    number INT
);

CREATE TABLE distribution_config (
    id UUID PRIMARY KEY,
    distribution_id UUID REFERENCES distributions(id) ON DELETE CASCADE,
    property_name TEXT,
    property_value TEXT,
    property_data_type TEXT DEFAULT 'str'
);

-- execute after daos table is created
ALTER TABLE user_details
ADD CONSTRAINT user_details_dao_id_fkey
FOREIGN KEY (dao_id) REFERENCES daos(id) ON DELETE CASCADE;

-- patches
ALTER TABLE daos ADD COLUMN category TEXT;
ALTER TABLE daos ADD COLUMN created_dtz TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP;
