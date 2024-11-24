-- EX5
-- Làm thế nào để tạo một index trên cột productName của bảng products?
CREATE INDEX idx_productName ON products(productName);
-- Hiển thị danh sách các index trong cơ sở dữ liệu?
SHOW INDEX FROM products;
-- Trình bày cách xóa index idx_productName đã tạo trước đó?
DROP INDEX idx_productName ON products;
-- Tạo một procedure tên getProductByPrice để lấy danh sách sản phẩm với giá lớn hơn một giá trị đầu vào (priceInput)?
DELIMITER $$
CREATE PROCEDURE getProductByPrice(IN priceInput DECIMAL)
BEGIN
    SELECT * FROM products WHERE price > priceInput;
END $$
DELIMITER ;
-- Làm thế nào để gọi procedure getProductByPrice với đầu vào là 500000?
CALL getProductByPrice(500000);
-- Tạo một procedure getOrderDetails trả về thông tin chi tiết đơn hàng với đầu vào là orderId?
DELIMITER $$
CREATE PROCEDURE getOrderDetails(IN orderId INT)
BEGIN
    SELECT * FROM orderDetails WHERE orderId = orderId;
END $$
DELIMITER ;
-- Làm thế nào để xóa procedure getOrderDetails?
DROP PROCEDURE getOrderDetails;
-- Tạo một procedure tên addNewProduct để thêm mới một sản phẩm vào bảng products. Các tham số gồm productName, price, description, và quantity.
DELIMITER $$
CREATE PROCEDURE addNewProduct(IN productName VARCHAR(255), IN price DECIMAL, IN description TEXT, IN quantity INT)
BEGIN
    INSERT INTO products (productName, price, description, quantity) VALUES (productName, price, description, quantity);
END $$
DELIMITER ;
-- Tạo một procedure tên deleteProductById để xóa sản phẩm khỏi bảng products dựa trên tham số productId.
DELIMITER $$
CREATE PROCEDURE deleteProductById(IN productId INT)
BEGIN
    DELETE FROM products WHERE productId = productId;
END $$
DELIMITER ;
-- Tạo một procedure tên searchProductByName để tìm kiếm sản phẩm theo tên (tìm kiếm gần đúng) từ bảng products.
DELIMITER $$
CREATE PROCEDURE searchProductByName(IN searchName VARCHAR(255))
BEGIN
    SELECT * FROM products WHERE productName LIKE CONCAT('%', searchName, '%');
END $$
DELIMITER ;
-- Tạo một procedure tên filterProductsByPriceRange để lấy danh sách sản phẩm có giá trong khoảng từ minPrice đến maxPrice.
DELIMITER $$
CREATE PROCEDURE filterProductsByPriceRange(IN minPrice DECIMAL, IN maxPrice DECIMAL)
BEGIN
    SELECT * FROM products WHERE price BETWEEN minPrice AND maxPrice;
END $$
DELIMITER ;
-- Tạo một procedure tên paginateProducts để phân trang danh sách sản phẩm, với hai tham số pageNumber và pageSize.
DELIMITER $$
CREATE PROCEDURE paginateProducts(IN pageNumber INT, IN pageSize INT)
BEGIN
    SET @offset = (pageNumber - 1) * pageSize;
    SET @query = CONCAT('SELECT * FROM products LIMIT ', @offset, ', ', pageSize);
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END $$
DELIMITER ;
