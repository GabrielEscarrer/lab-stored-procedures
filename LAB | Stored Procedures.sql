 -- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure.

drop procedure if exists customer_info_by_film_category;
delimiter //
create procedure customer_info_by_film_category ()
begin
	select first_name, last_name, email
	from customer
	join rental on customer.customer_id = rental.customer_id
	join inventory on rental.inventory_id = inventory.inventory_id
	join film on film.film_id = inventory.film_id
	join film_category on film_category.film_id = film.film_id
	join category on category.category_id = film_category.category_id
	where category.name = "Action"
	group by first_name, last_name, email;
end;
//
delimiter ;

call customer_info_by_film_category();

-- Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

drop procedure if exists customer_info_by_film_category;
delimiter //
create procedure customer_info_by_film_category (in param varchar(20))
begin
	select first_name, last_name, email
	from customer
	join rental on customer.customer_id = rental.customer_id
	join inventory on rental.inventory_id = inventory.inventory_id
	join film on film.film_id = inventory.film_id
	join film_category on film_category.film_id = film.film_id
	join category on category.category_id = film_category.category_id
	where category.name = param
	group by first_name, last_name, email;
end;
//
delimiter ;

call customer_info_by_film_category("Action");

-- Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

select category.name, count(count_of_category) as category_counts
from film
join film_category using (film_id)
join category using (category_id)
join (select count(*) as count_of_category, category_id
from film_category fc
group by category_id)sub using (category_id)
group by category.name;

drop procedure if exists counts_film_category;
delimiter //
create procedure counts_film_category (in param int)
begin
select * from (select category.name, count(count_of_category) as category_counts
from film
join film_category using (film_id)
join category using (category_id)
join (select count(*) as count_of_category, category_id 
from film_category fc 
group by category_id)sub using (category_id)
group by category.name)sub
where category_counts > param;
end;
//
delimiter ;

call counts_film_category(50);