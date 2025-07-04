-- Table: public.produtos

-- DROP TABLE IF EXISTS public.produtos;

CREATE TABLE IF NOT EXISTS public.produtos
(
    id integer NOT NULL DEFAULT nextval('produtos_id_seq'::regclass),
    descricaoproduto character varying(200) COLLATE pg_catalog."default",
    datacadastro date,
    idunidademedida double precision,
    valor double precision,
    CONSTRAINT produtos_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.produtos
    OWNER to postgres;