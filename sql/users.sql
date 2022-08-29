-- users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    alias TEXT UNIQUE NOT NULL,
    primary_wallet_address_id INT UNIQUE,
    hashed_password TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    is_superuser BOOLEAN DEFAULT false
);

CREATE TABLE user_details (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    dao_id INT,
    name TEXT,
    profile_img_url TEXT,
    bio TEXT,
    level INT DEFAULT 0,
    xp INT DEFAULT 0,
    social_links JSON DEFAULT '{}'
);

CREATE TABLE user_followers (
    id SERIAL PRIMARY KEY,
    follower_id INT REFERENCES users(id) ON DELETE CASCADE,
    followee_id INT REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE user_profile_settings (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    dao_id INT,
    settings JSON DEFAULT '{}'
);

CREATE TABLE ergo_addresses (
    id SERIAL PRIMARY KEY,
    user_id INT, -- we keep the record on delete to maintain other dependencies
    address TEXT UNIQUE,
    is_smart_contract BOOLEAN DEFAULT false
);

CREATE TABLE jwt_blacklist (
    id SERIAL PRIMARY KEY,
    token TEXT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX ON jwt_blacklist (token);

-- execute after daos table is created
ALTER TABLE user_details
ADD CONSTRAINT user_details_dao_id_fkey
FOREIGN KEY (dao_id) REFERENCES daos(id) ON DELETE CASCADE;

ALTER TABLE user_profile_settings
ADD CONSTRAINT user_profile_settings_dao_id_fkey
FOREIGN KEY (dao_id) REFERENCES daos(id) ON DELETE CASCADE;
