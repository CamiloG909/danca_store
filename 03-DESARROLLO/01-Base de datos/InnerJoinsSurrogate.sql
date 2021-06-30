SET search_path TO surr;

--Consulta para saber qué tipo de documento no está en uso
select dt.initials, dt.document_name, dt.status 
    from document_type dt
        left join client ct on dt.id = ct.id_document_type
    WHERE ct.id_document_type is null
;

--Consulta para saber que producto aún no ha vendido ninguna unidad
select pt.reference, pt.name, pt.price, pt.stock, sr.company_name, pc.category_name 
    from product pt 
        left join order_details dts on pt.id = dts.id_product
	    inner join supplier sr on pt.id_supplier = sr.id
	    inner join product_category pc on pt.id_category = pc.id
    WHERE dts.id_product is null
;

--Consulta para ver la información de todos los usuarios registrados
select dt.initials, dt.document_name, ct.document_number, ct.name, ct.last_name, ur.email, ur.phone_number, ur.status
    from client ct
        inner join user_ ur on ct.id_user = ur.id
        inner join document_type dt on ct.id_document_type = dt.id
		order by ct.name
;

--Consulta para saber la información de los clientes que han pagado con Tarjeta de Crédito
select dt.initials, c.document_number, c.name, c.last_name, p.bill_date, mp.method_payment, p.status
    from payment p
        inner join method_payment mp on p.id_method_payment = mp.id
		inner join order_ o on p.id_order = o.id
        inner join client c on o.id_client = c.id
        inner join document_type dt on c.id_document_type = dt.id
	WHERE mp.method_payment = 'Tarjeta de Crédito' and p.status = 'Completo'
	ORDER BY p.bill_date desc
;

--Consulta para ver los detalles de pedidos cancelados
select dt.initials, c.document_number, c.name, c.last_name, p.name, od.total_value, od.color, od.amount,  o.order_date, o.status
    from order_details od
        inner join order_ o on od.id_order = o.id
        inner join client c on o.id_client = c.id
        inner join document_type dt on c.id_document_type = dt.id
		inner join product p on od.id_product = p.id
	WHERE o.status = 'Cancelado'
;

--Consultar productos vendidos
select p.reference, p.name, p.price, od.color, p.status, p.stock 
    from order_ o 
        inner join order_details od on od.id_order = o.id
		inner join product p on od.id_product = p.id
    WHERE o.status = 'Completado'
;

--Consultar usuarios suspendidos
select dt.initials, c.document_number, c.name, c.last_name, u.email, u.phone_number
	from client c
		inner join user_ u on c.id_user = u.id
		inner join document_type dt on c.id_document_type = dt.id
	WHERE u.status = 'Suspendido'
;

--Consultar todos los celulares a la venta
select p.reference, p.name, p.price, p.stock, p.status
	from product p
		inner join product_category pc on p.id_category = pc.id
	WHERE pc.category_name = 'Celulares'
;

--Consulta para conocer los pedidos ya entregados a los clientes
select s.status, s.shipping_company_name, c.name, c.last_name, s.town, s.address, s.delivery_date
	from shipping s
		inner join order_ o on s.id_order = o.id
		inner join client c on o.id_client = c.id
	WHERE s.status = 'Entregado'
;

--Consultar información de los usuarios que han realizado alguna compra
select dt.initials, c.document_number, c.name, c.last_name, u.email
	from payment p
		inner join order_ o on p.id_order = o.id
		inner join client c on o.id_client = c.id
		inner join user_ u on c.id_user = u.id
		inner join document_type dt on c.id_document_type = dt.id
	WHERE p.status = 'Completo'
;