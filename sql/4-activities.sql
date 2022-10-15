-- activity log
CREATE TABLE activity_log (
    id SERIAL PRIMARY KEY,
    user_details_id INT REFERENCES user_details(id) ON DELETE CASCADE,
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
    user_details_id INT REFERENCES user_details(id) ON DELETE CASCADE,
    img TEXT,
    action TEXT,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    transaction_id TEXT,
    href TEXT,
    additional_text TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT false
);

CREATE VIEW vw_activity_log AS (
    SELECT
        AL.id,
        AL.user_details_id,
        UD.name,
        UD.profile_img_url as img_url,
        AL.action,
        AL.value,
        AL.secondary_action,
        AL.secondary_value,
        date,
        category
    FROM
        activity_log AL
        INNER JOIN user_details UD ON UD.id = AL.user_details_id
);