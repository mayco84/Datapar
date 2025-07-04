-- Table: public.pedido

-- DROP TABLE IF EXISTS public.pedido;

CREATE TABLE IF NOT EXISTS public.pedido
(
    id integer NOT NULL DEFAULT nextval('pedido_id_seq'::regclass),
    datapedido date,
    idcliente integer,
    total double precision,
    CONSTRAINT pedido_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.pedido
    OWNER to postgres;