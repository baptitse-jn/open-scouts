-- Migration: Change embedding dimensions from OpenAI (1536) to Gemini (768)
-- This migration is required when switching from OpenAI text-embedding-3-small to Gemini text-embedding-004

-- Drop the existing index if it exists
DROP INDEX IF EXISTS scout_executions_embedding_idx;

-- Drop the existing column if it exists (this will clear all existing embeddings)
ALTER TABLE scout_executions DROP COLUMN IF EXISTS summary_embedding;

-- Create the column with new dimension (768 for Gemini text-embedding-004)
ALTER TABLE scout_executions ADD COLUMN summary_embedding vector(768);

-- Recreate the index for similarity search
CREATE INDEX scout_executions_embedding_idx
ON scout_executions
USING ivfflat (summary_embedding vector_cosine_ops)
WITH (lists = 100);

-- Add a comment to document the change
COMMENT ON COLUMN scout_executions.summary_embedding IS 'Gemini text-embedding-004 vector (768 dimensions)';
