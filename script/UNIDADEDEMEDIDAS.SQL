-- Table: public.unidademedida

-- DROP TABLE IF EXISTS public.unidademedida;

CREATE TABLE IF NOT EXISTS public.unidademedida
(
    id integer NOT NULL DEFAULT nextval('unidademedida_id_seq'::regclass),
    descricaounidademedida character varying(200) COLLATE pg_catalog."default",
    siglaunidademedida character(4) COLLATE pg_catalog."default",
    datacadastro date,
    CONSTRAINT unidademedida_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.unidademedida
    OWNER to postgres;