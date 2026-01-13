SELECT
    c.Country,
    o.OrderDate,
    COUNT(o.OrderID) AS TotalCompletedOrders,
    SUM(OrderAmount) AS TotalRevenue
FROM Customers AS c
JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Completed'
GROUP BY 
    o.OrderDate,
    c.Country
ORDER BY 
    o.OrderDate ASC,
    c.Country ASC
