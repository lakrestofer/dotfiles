create table if not exists table document (
  id integer,
  name text not null,
  n_pages integer not null default 0
);
