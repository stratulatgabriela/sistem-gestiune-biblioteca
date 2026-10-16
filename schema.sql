create table public."AutoriInfo" (
  id uuid not null default gen_random_uuid (),
  nume_autor text not null default ''::text,
  biografie text null,
  data_nasterii date null,
  gen_literar text null,
  poza_url text null,
  alte_info text null,
  constraint "AutoriInfo_pkey" primary key (id),
  constraint "AutoriInfo_nume_autor_key" unique (nume_autor)
) TABLESPACE pg_default;

create index IF not exists idx_autoriinfo_nume_autor on public."AutoriInfo" using btree (nume_autor) TABLESPACE pg_default;

create table public."Carti" (
  id uuid not null default gen_random_uuid (),
  titlu text not null,
  autor text null,
  an_publicare integer null,
  gen text null,
  disponibila boolean null,
  constraint "Carti_pkey" primary key (id),
  constraint carti_an_publicare_check check (
    (
      (an_publicare is null)
      or (
        (an_publicare >= 1400)
        and (
          an_publicare <= (
            EXTRACT(
              year
              from
                now()
            )
          )::integer
        )
      )
    )
  )
) TABLESPACE pg_default;

create index IF not exists idx_carti_titlu on public."Carti" using btree (titlu) TABLESPACE pg_default;

create index IF not exists idx_carti_autor on public."Carti" using btree (autor) TABLESPACE pg_default;

create table public."Feedback" (
  id uuid not null default gen_random_uuid (),
  user_id text not null,
  mesaj text null,
  data timestamp without time zone null default now(),
  constraint "Feedback_pkey" primary key (id)
) TABLESPACE pg_default;

create table public."Imprumuturi" (
  id uuid not null default gen_random_uuid (),
  carte_id uuid not null,
  utilizator_id uuid null default gen_random_uuid (),
  data_imprumut timestamp without time zone null,
  data_returnare timestamp without time zone null,
  status text null,
  constraint "Imprumuturi_pkey" primary key (id)
) TABLESPACE pg_default;

create table public."Utilizatori" (
  id uuid not null default gen_random_uuid (),
  nume text not null,
  email text not null,
  telefon text null,
  data_inregistrare timestamp without time zone null,
  rol text not null default 'cititor'::text,
  constraint "Utilizatori_pkey" primary key (id),
  constraint utilizatori_email_uniq unique (email),
  constraint "Utilizatori_rol_check" check (
    (rol = any (array['cititor'::text, 'admin'::text]))
  )
) TABLESPACE pg_default;

create table public.favorite (
  id uuid not null default gen_random_uuid (),
  id_cititor bigint not null,
  id_carte uuid null,
  data_adaugare timestamp without time zone null default now(),
  constraint favorite_pkey primary key (id)
) TABLESPACE pg_default;

create table public.rezervari (
  id uuid not null default gen_random_uuid (),
  id_cititor bigint not null,
  id_carte uuid null,
  data_rezervare timestamp without time zone null default now(),
  status text null,
  constraint rezervari_pkey primary key (id)
) TABLESPACE pg_default;