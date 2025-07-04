-- Table: public.cliente

-- DROP TABLE IF EXISTS public.cliente;

CREATE TABLE IF NOT EXISTS public.cliente
(
    id integer NOT NULL DEFAULT nextval('cliente_id_seq'::regclass),
    nomecompleto character varying(200) COLLATE pg_catalog."default",
    fisicajuridica character(1) COLLATE pg_catalog."default",
    tipopessoa character(1) COLLATE pg_catalog."default",
    cpf character varying(25) COLLATE pg_catalog."default",
    rg character varying(25) COLLATE pg_catalog."default",
    endereco character varying(200) COLLATE pg_catalog."default",
    bairro character varying(200) COLLATE pg_catalog."default",
    cidade character varying(200) COLLATE pg_catalog."default",
    uf character(2) COLLATE pg_catalog."default",
    cep character varying(15) COLLATE pg_catalog."default",
    telefone character varying(20) COLLATE pg_catalog."default",
    email character varying(200) COLLATE pg_catalog."default",
    datanascimento date,
    numero character varying(20) COLLATE pg_catalog."default",
    complemento character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT cliente_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.cliente
    OWNER to postgres;