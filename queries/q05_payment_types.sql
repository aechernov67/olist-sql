-- Q5. payments → по каждому способу оплаты (payment_type): число платежей, средняя сумма платежа payment_value и среднее число частей рассрочки payment_installments (обе округлить до 2); по убыванию числа платежей.

SELECT COALESCE(payment_type, 'no_payment_type') AS pay_type, COUNT(*) AS payments_number, ROUND(AVG(payment_value),2) as avg_value, ROUND(AVG(payment_installments), 2) AS avg_installments  
FROM payments
GROUP BY payment_type
ORDER BY payments_number DESC;
