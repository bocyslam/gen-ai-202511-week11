-- Run this in Supabase SQL Editor
create or replace function match_embeddings (
  query_embedding vector(1536),
  match_threshold float,
  match_count int,
  filter_doc_id int
)
returns table (
  id bigint,
  content text,
  similarity float
)
language plpgsql
as $$
begin
  return query
  select
    embeddings.id,
    embeddings.content,
    1 - (embeddings.embedding <=> query_embedding) as similarity
  from embeddings
  where embeddings.doc_id = filter_doc_id
  and 1 - (embeddings.embedding <=> query_embedding) > match_threshold
  order by similarity desc
  limit match_count;
end;
$$;