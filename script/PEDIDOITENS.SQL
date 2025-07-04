-- Table: public.pedidoitens

-- DROP TABLE IF EXISTS public.pedidoitens;

CREATE TABLE IF NOT EXISTS public.pedidoitens
(
    id integer NOT NULL DEFAULT nextval('pedidoitens_id_seq'::regclass),
    idpedido integer,
    idunidademedida integer,
    quantidade double precision,
    valor double precision,
    total double precision,
    CONSTRAINT pedidoitens_pkey PRIMARY KEY (id),
    CONSTRAINT pedidoitens_idpedido_fkey FOREIGN KEY (idpedido)
        REFERENCES public.pedido (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.pedidoitens
    OWNER to postgres;
-- Index: idpedidofk

-- DROP INDEX IF EXISTS public.idpedidofk;

CREATE INDEX IF NOT EXISTS idpedidofk
    ON public.pedidoitens USING btree
    (idpedido ASC NULLS LAST)
    TABLESPACE pg_default;