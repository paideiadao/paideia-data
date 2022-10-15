-- proposals
CREATE TABLE proposals (
    id SERIAL PRIMARY KEY,
    dao_id INT REFERENCES daos(id) ON DELETE CASCADE,
    user_details_id INT, -- keeps the proposal as anonymous
    name TEXT NOT NULL,
    image_url TEXT,
    category TEXT,
    content TEXT,
    voting_system TEXT,
    actions JSON DEFAULT '{}',
    tags JSON DEFAULT '{}',
    attachments JSON DEFAULT '{}',
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status TEXT,
    is_proposal BOOLEAN DEFAULT false
);

CREATE TABLE proposal_addendums (
    id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    content TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE proposal_comments (
    id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    user_details_id INT, -- keeps the comment as anonymous
    comment TEXT,
    parent INT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE proposal_comments_likes (
    id SERIAL PRIMARY KEY,
    comment_id INT REFERENCES proposal_comments(id) ON DELETE CASCADE,
    user_details_id INT REFERENCES user_details(id) ON DELETE CASCADE,
    liked BOOLEAN -- true if liked, false if disliked
);

CREATE TABLE proposal_likes (
    id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    user_details_id INT REFERENCES user_details(id) ON DELETE CASCADE,
    liked BOOLEAN -- true if liked, false if disliked
);

CREATE TABLE proposal_followers (
    id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    user_details_id INT REFERENCES user_details(id) ON DELETE CASCADE
);

CREATE TABLE proposal_references (
    id SERIAL PRIMARY KEY,
    referred_proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    referring_proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE
);

-- patches
ALTER TABLE proposal_comments
ADD CONSTRAINT proposal_comments_parent_fkey
FOREIGN KEY (parent) REFERENCES proposal_comments(id)
ON DELETE CASCADE;
