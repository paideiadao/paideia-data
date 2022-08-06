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
    user_id INT UNIQUE NOT NULL,
    name TEXT,
    profile_img_url TEXT,
    bio TEXT,
    level INT DEFAULT 0,
    xp INT DEFAULT 0,
    social_links JSON DEFAULT '{}'
);

CREATE TABLE user_followers (
    id SERIAL PRIMARY KEY,
    follower_id INT NOT NULL,
    followee_id INT NOT NULL
);

CREATE TABLE user_profile_settings (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    settings JSON DEFAULT '{}'
);

CREATE TABLE ergo_addresses (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    address TEXT UNIQUE,
    is_smart_contract BOOLEAN DEFAULT false
);

CREATE TABLE jwt_blacklist (
    id SERIAL PRIMARY KEY,
    token TEXT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX ON jwt_blacklist (token);
