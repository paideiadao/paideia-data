-- activity log
CREATE TABLE activity_log (
    id UUID PRIMARY KEY,
    user_details_id UUID REFERENCES user_details(id) ON DELETE CASCADE,
    action TEXT,
    value TEXT,
    secondary_action TEXT,
    secondary_value TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    category TEXT
);

-- notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY,
    user_details_id UUID REFERENCES user_details(id) ON DELETE CASCADE,
    img TEXT,
    action TEXT,
    proposal_id UUID REFERENCES proposals(id) ON DELETE CASCADE,
    transaction_id TEXT,
    href TEXT,
    additional_text TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT false
);

ALTER TABLE activity_log ADD COLUMN link TEXT;
