Use session8;
-- EX2
-- Bảng products
ALTER TABLE products ADD CONSTRAINT fk_products_categories FOREIGN KEY(categoryId) REFERENCES categories(categoryId);
ALTER TABLE products ADD CONSTRAINT fk_products_stores FOREIGN KEY(storeId) REFERENCES stores(storeId);
-- Bảng images
ALTER TABLE images ADD CONSTRAINT fk_images_products FOREIGN KEY(productId) REFERENCES products(productId);
-- Bảng reviews
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_users FOREIGN KEY(userId) REFERENCES users(userId);
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_products FOREIGN KEY(productId) REFERENCES products(productId);
-- Bảng carts
ALTER TABLE carts ADD CONSTRAINT fk_carts_users FOREIGN KEY(userId) REFERENCES users(userId);
ALTER TABLE carts ADD CONSTRAINT fk_carts_products FOREIGN KEY(productId) REFERENCES products(productId);
-- Bảng order_details
ALTER TABLE order_details ADD CONSTRAINT fk_order_details_products FOREIGN KEY(productId) REFERENCES products(productId);
ALTER TABLE order_details ADD CONSTRAINT fk_order_details_orders FOREIGN KEY(orderId) REFERENCES orders(orderId);
-- Bảng ordres
ALTER TABLE orders ADD CONSTRAINT fk_orders_users FOREIGN KEY(userId) REFERENCES users(userId);
ALTER TABLE orders ADD CONSTRAINT fk_orders_stores FOREIGN KEY(storeId) REFERENCES stores(storeId);
-- Bảng stores
ALTER TABLE stores ADD CONSTRAINT fk_stores_users FOREIGN KEY(userId) REFERENCES users(userId);

-- EX3

-- Liệt kê tất cả các thông tin về sản phẩm (products)
SELECT * FROM products;
-- Tìm tất cả các đơn hàng (orders) có tổng giá trị (totalPrice) lớn hơn 500,000.
SELECT * FROM orders 
WHERE totalPrice > 500000;
-- Liệt kê tên và địa chỉ của tất cả các cửa hàng (stores).
SELECT storeName, addressStore FROM stores;
-- Tìm tất cả người dùng (users) có địa chỉ email kết thúc bằng '@gmail.com'.
SELECT * FROM users WHERE email LIKE "%@gmail.com";
-- Hiển thị tất cả các đánh giá (reviews) với mức đánh giá (rate) bằng 5.
SELECT * FROM reviews WHERE rate = '5';
-- Liệt kê tất cả các sản phẩm có số lượng (quantity) dưới 10.
SELECT * FROM products WHERE quantity < 10;
-- Tìm tất cả các sản phẩm thuộc danh mục categoryId = 1.
SELECT * FROM products WHERE  categoryId = '1';
-- Đếm số lượng người dùng (users) có trong hệ thống.
SELECT COUNT(*) FROM users;
-- Tính tổng giá trị của tất cả các đơn hàng (orders).
SELECT SUM(totalPrice) FROM orders;
-- Tìm sản phẩm có giá cao nhất (price).
SELECT * FROM products WHERE price = (SELECT MAX(price) FROM products);
SELECT * FROM products ORDER BY price DESC LIMIT 1;
-- Liệt kê tất cả các cửa hàng đang hoạt động (statusStore = 1).
SELECT * FROM stores WHERE statusStore = '1';
-- Đếm số lượng sản phẩm theo từng danh mục (categories).
SELECT categoryId, COUNT(*) FROM products GROUP BY categoryId;
-- Tìm tất cả các sản phẩm mà chưa từng có đánh giá.
SELECT * FROM products WHERE productId NOT IN (
					   SELECT productId FROM reviews);
-- Hiển thị tổng số lượng hàng đã bán (quantityOrder) của từng sản phẩm.
SELECT p.productId, p.productName, SUM(od.quantityOrder) 
FROM order_details od
JOIN products p ON od.productId = p.productId
GROUP BY p.productId, p.productName;
-- Tìm các người dùng (users) chưa đặt bất kỳ đơn hàng nào.
SELECT * FROM users WHERE userId NOT IN (SELECT userId FROM orders);

SELECT * FROM users u
LEFT JOIN orders o ON u.userId = o.userId
WHERE o.orderId IS NULL;
-- Hiển thị tên cửa hàng và tổng số đơn hàng được thực hiện tại từng cửa hàng.
SELECT s.storeName, COUNT(o.orderId) FROM stores s
JOIN orders o ON s.storeId = o.storeId
GROUP BY s.storeName;
-- Hiển thị thông tin của sản phẩm, kèm số lượng hình ảnh liên quan.
SELECT p.*, COUNT(i.imageId) FROM products p
LEFT JOIN images i ON i.productId = p.productId
GROUP BY p.productId;
-- Hiển thị các sản phẩm kèm số lượng đánh giá và đánh giá trung bình.
SELECT p.*, COUNT(r.reviewId), AVG(r.rate) FROM products p
LEFT JOIN reviews r ON r.productId = p.productId
GROUP BY p.productId;
-- Tìm người dùng có số lượng đánh giá nhiều nhất.
SELECT u.*, COUNT(r.reviewId) AS SLDG FROM users u
LEFT JOIN reviews r ON r.userId = u.userId
GROUP BY u.userId
ORDER BY SLDG DESC
LIMIT 1;
-- Hiển thị top 3 sản phẩm bán chạy nhất (dựa trên số lượng đã bán).
SELECT p.*, SUM(quantityOrder) AS totalSold
FROM products p
JOIN order_details od ON od.productId = p.productId
GROUP BY productId
ORDER BY totalSold DESC
LIMIT 3;
-- Tìm sản phẩm bán chạy nhất tại cửa hàng có storeId = 'S001'.
SELECT p.*, SUM(quantityOrder) AS totalSold FROM products p
JOIN order_details od ON od.productId = p.productId
JOIN orders o ON od.orderId = o.orderId
WHERE p.storeId = 'S001'
GROUP BY productId
ORDER BY totalSold DESC
LIMIT 1;
-- Hiển thị danh sách tất cả các sản phẩm có giá trị tồn kho lớn hơn 1 triệu (giá * số lượng).
SELECT p.*, (price * quantity) AS GTTK
FROM products p
WHERE (price * quantity) > 1000000;
-- Tìm cửa hàng có tổng doanh thu cao nhất.
SELECT s.*, SUM(o.totalPrice) AS totalRevenue 
FROM stores s
JOIN orders o ON s.storeId = o.storeId
GROUP BY s.storeId
ORDER BY totalRevenue DESC
LIMIT 1;
-- Hiển thị danh sách người dùng và tổng số tiền họ đã chi tiêu.
SELECT u.*, SUM(o.totalPrice) AS totalSpent
FROM users u
JOIN orders o ON u.userId = o.userId
GROUP BY u.userId;
-- Tìm đơn hàng có tổng giá trị cao nhất và liệt kê thông tin chi tiết.
SELECT * FROM orders WHERE totalPrice = (
					 SELECT MAX(totalPrice) FROM orders);
-- Tính số lượng sản phẩm trung bình được bán ra trong mỗi đơn hàng.
SELECT AVG(quantityOrder) FROM order_details;
-- Hiển thị tên sản phẩm và số lần sản phẩm đó được thêm vào giỏ hàng.
SELECT p.productName, COUNT(c.productId) AS SLTVGH
FROM products p
JOIN carts c ON p.productId = c.productId
GROUP BY p.productName;

-- Tìm tất cả các sản phẩm đã bán nhưng không còn tồn kho trong kho hàng.
SELECT * FROM products WHERE productId IN (
                       SELECT productId FROM order_details) AND quantity = 0;
-- Tìm các đơn hàng được thực hiện bởi người dùng có email là duong@gmail.com'.
SELECT * FROM orders o
JOIN users u ON o.userId = u.userId
WHERE u.email = 'duong@gmail.com';
-- Hiển thị danh sách các cửa hàng kèm theo tổng số lượng sản phẩm mà họ sở hữu.
SELECT s.*, SUM(p.quantity) AS totalProducts
FROM stores s
JOIN products p ON s.storeId = p.storeId
GROUP BY s.storeId;

