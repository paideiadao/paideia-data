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
