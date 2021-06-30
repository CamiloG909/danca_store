SET search_path TO natu;

--Consulta para saber qué tipo de documento no está en uso
select dt.initials, dt.document_name, dt.status
    from document_type dt
        left join client ct on dt.initials = ct.initials
    WHERE ct.initials is null
;

--Consulta para saber que producto aún no ha vendido ninguna unidad
select pt.reference, pt.name, pt.price, pt.stock, sr.company_name, pc.category_name 
    from product pt 
        left join order_details dts on pt.reference = dts.reference
	    inner join supplier sr on pt.company_name_supplier = sr.company_name
	    inner join product_category pc on pt.category_name = pc.category_name
    WHERE dts.reference is null
;

--Consulta para ver la información de todos los usuarios registrados
select dt.initials, dt.document_name, ct.document_number, ct.name, ct.last_name, ur.email, ur.phone_number, ur.status
    from client ct
        inner join user_ ur on ct.login = ur.login
        inner join document_type dt on ct.initials = dt.initials
		order by ct.name
;

--Consulta para saber la información de los clientes que han pagado con Tarjeta de Crédito
select c.initials, c.document_number, c.name, c.last_name, p.bill_date, p.method_payment, p.status
    from payment p
		inner join order_ o on p.order_number = o.order_number
        inner join client c on o.document_number = c.document_number and o.initials = c.initials
	WHERE p.method_payment = 'Tarjeta de Crédito' and p.status = 'Completo'
	ORDER BY p.bill_date desc
;

--Consulta para ver los detalles de pedidos cancelados
select c.initials, c.document_number, c.name, c.last_name, p.name, od.total_value, od.color, od.amount,  o.order_date, o.status
    from order_ o
        inner join order_details od on od.order_number = o.order_number
        inner join client c on o.document_number = c.document_number and o.initials = c.initials
		inner join product p on od.reference = p.reference
	WHERE o.status = 'Cancelado'
;

--Consultar productos vendidos
select p.reference, p.name, p.price, od.color, p.status, p.stock 
    from order_ o 
        inner join order_details od on od.order_number = o.order_number
		inner join product p on od.reference = p.reference
    WHERE o.status = 'Completado'
;

--Consultar usuarios suspendidos
select c.initials, c.document_number, c.name, c.last_name, u.email, u.phone_number
	from client c
		inner join user_ u on c.login = u.login
	WHERE u.status = 'Suspendido'
;

--Consultar todos los celulares a la venta
select p.reference, p.name, p.price, p.stock, p.status
	from product p
		inner join product_category pc on p.category_name = pc.category_name
	WHERE pc.category_name = 'Celulares'
;

--Consulta para conocer los pedidos ya entregados a los clientes
select s.status, s.shipping_company_name, c.name, c.last_name, s.town, s.address, s.delivery_date
	from shipping s
		inner join order_ o on s.order_number = o.order_number
		inner join client c on o.document_number = c.document_number and o.initials = c.initials
	WHERE s.status = 'Entregado'
;

--Consultar información de los usuarios que han realizado alguna compra
select c.initials, c.document_number, c.name, c.last_name, c.login
	from payment p
		inner join order_ o on p.order_number = o.order_number
		inner join client c on o.document_number = c.document_number and o.initials = c.initials
	WHERE p.status = 'Completo'
;