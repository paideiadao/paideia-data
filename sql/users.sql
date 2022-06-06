-- users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    alias TEXT UNIQUE NOT NULL,
    primary_wallet_address_id INT,
    profile_img_url TEXT,
    hashed_password TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    is_superuser BOOLEAN DEFAULT false
);

CREATE TABLE ergo_addresses (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    address TEXT,
    is_smart_contract BOOLEAN DEFAULT false
);

CREATE TABLE jwt_blacklist (
    id SERIAL PRIMARY KEY,
    token TEXT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX ON jwt_blacklist (token);
