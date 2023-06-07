--Conocer el Precio de venta de inventario por producto Stock*Price


-- Declarar variables
DECLARE @id INT, @name VARCHAR(200), @description VARCHAR(500), @stock INT, @cost FLOAT, @price FLOAT, @id_category INT
DECLARE @inventory_cost FLOAT

-- Crear tabla temporal
CREATE TABLE #TempProducts (
    id INT,
    name VARCHAR(200),
    description VARCHAR(500),
    stock INT,
    cost FLOAT,
    price FLOAT,
    id_category INT,
    [Inventory Cost] FLOAT
);

-- Declarar el cursor
DECLARE productCursor CURSOR FOR
SELECT id, name, description, stock, cost, price, id_category
FROM Products;

-- Abrir el cursor
OPEN productCursor;

-- Obtener el primer registro
FETCH NEXT FROM productCursor INTO @id, @name, @description, @stock, @cost, @price, @id_category;

-- Iterar a través de los registros
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Calcular el costo del inventario
    SET @inventory_cost = @stock * @cost;

    -- Insertar el registro en la tabla temporal con el costo del inventario calculado
    INSERT INTO #TempProducts (id, name, description, stock, cost, price, id_category, [Inventory Cost])
    VALUES (@id, @name, @description, @stock, @cost, @price, @id_category, @inventory_cost);

    -- Obtener el siguiente registro
    FETCH NEXT FROM productCursor INTO @id, @name, @description, @stock, @cost, @price, @id_category;
END

-- Cerrar el cursor
CLOSE productCursor;

-- Liberar recursos del cursor
DEALLOCATE productCursor;

-- Mostrar los registros de la tabla temporal
SELECT * FROM #TempProducts;

-- Eliminar la tabla temporal
DROP TABLE #TempProducts;
