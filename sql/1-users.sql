-- users
CREATE TABLE users (
    id UUID PRIMARY KEY,
    alias TEXT UNIQUE NOT NULL,
    primary_wallet_address_id UUID UNIQUE,
    hashed_password TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    is_superuser BOOLEAN DEFAULT false
);

-- has dao specific user data
CREATE TABLE user_details (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    dao_id UUID,
    name TEXT,
    profile_img_url TEXT,
    bio TEXT,
    level INT DEFAULT 0,
    xp INT DEFAULT 0,
    social_links JSON DEFAULT '[]',
    UNIQUE (user_id, dao_id)
);

CREATE TABLE user_followers (
    id UUID PRIMARY KEY,
    follower_id UUID REFERENCES user_details(id) ON DELETE CASCADE,
    followee_id UUID REFERENCES user_details(id) ON DELETE CASCADE
);

CREATE TABLE user_profile_settings (
    id UUID PRIMARY KEY,
    user_details_id UUID REFERENCES user_details(id) ON DELETE CASCADE,
    settings JSON DEFAULT '{}',
    UNIQUE (user_details_id)
);

CREATE TABLE ergo_addresses (
    id UUID PRIMARY KEY,
    user_id UUID, -- we keep the record on delete to maintain other dependencies
    address TEXT UNIQUE,
    is_smart_contract BOOLEAN DEFAULT false
);

CREATE TABLE jwt_blacklist (
    id UUID PRIMARY KEY,
    token TEXT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX ON jwt_blacklist (token);

-- patches
ALTER TABLE users
ADD CONSTRAINT users_primary_wallet_address_id_fkey
FOREIGN KEY (primary_wallet_address_id) REFERENCES ergo_addresses(id);

ALTER TABLE user_details
ADD CONSTRAINT user_details_dao_id_name_key UNIQUE (dao_id, name);
