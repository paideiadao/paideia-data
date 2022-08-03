-- activity log
CREATE TABLE activity_logs (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
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
    user_id INT NOT NULL,
    img TEXT,
    action TEXT,
    proposal_id INT,
    proposal_name TEXT,
    transaction_id TEXT,
    href TEXT,
    additional_text TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT false
);
