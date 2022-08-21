-- activity log
CREATE TABLE activity_log (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    img_url TEXT,
    action TEXT,
    value TEXT,
    secondary_action TEXT,
    secondary_value TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    category TEXT
);

-- notifications
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    img TEXT,
    action TEXT,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    transaction_id TEXT,
    href TEXT,
    additional_text TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT false
);
