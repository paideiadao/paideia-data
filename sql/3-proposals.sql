-- proposals
CREATE TABLE proposals (
    id UUID PRIMARY KEY,
    dao_id UUID REFERENCES daos(id) ON DELETE CASCADE,
    on_chain_id INT,
    user_details_id UUID, -- keeps the proposal as anonymous
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
    is_proposal BOOLEAN DEFAULT false,
    box_height INT,
    votes JSON
);

CREATE TABLE proposal_addendums (
    id UUID PRIMARY KEY,
    proposal_id UUID REFERENCES proposals(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    content TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE proposal_comments (
    id UUID PRIMARY KEY,
    proposal_id UUID REFERENCES proposals(id) ON DELETE CASCADE,
    user_details_id UUID, -- keeps the comment as anonymous
    comment TEXT,
    parent UUID,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE proposal_comments_likes (
    id UUID PRIMARY KEY,
    comment_id UUID REFERENCES proposal_comments(id) ON DELETE CASCADE,
    user_details_id UUID REFERENCES user_details(id) ON DELETE CASCADE,
    liked BOOLEAN -- true if liked, false if disliked
);

CREATE TABLE proposal_likes (
    id UUID PRIMARY KEY,
    proposal_id UUID REFERENCES proposals(id) ON DELETE CASCADE,
    user_details_id UUID REFERENCES user_details(id) ON DELETE CASCADE,
    liked BOOLEAN -- true if liked, false if disliked
);

CREATE TABLE proposal_followers (
    id UUID PRIMARY KEY,
    proposal_id UUID REFERENCES proposals(id) ON DELETE CASCADE,
    user_details_id UUID REFERENCES user_details(id) ON DELETE CASCADE
);

CREATE TABLE proposal_references (
    id UUID PRIMARY KEY,
    referred_proposal_id UUID REFERENCES proposals(id) ON DELETE CASCADE,
    referring_proposal_id UUID REFERENCES proposals(id) ON DELETE CASCADE
);

-- patches
ALTER TABLE proposal_comments
ADD CONSTRAINT proposal_comments_parent_fkey
FOREIGN KEY (parent) REFERENCES proposal_comments(id)
ON DELETE CASCADE;
